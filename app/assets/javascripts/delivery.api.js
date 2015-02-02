/**
 *  Handles communications with the server
 */
delivery.api = (function() {

  var currentDestination = null;

  /*
   * Get the deliveries assigned to a user and display them with the current route.
   */
  var getDeliveries = function(user_id) {
    var url = "deliveries.json";
    // if user_id is given get the respecitive deliveries, for that user
    // otherwise use the current_user via deliveries/index
    if (user_id != null) {
      url = "deliveries/user/" + user_id + ".json";
    }
    delivery.showAjaxLoader();
    $.getJSON(url, function (delivery_data) {
      // callback to do the acutal work on data
      handleDeliveries(delivery_data, user_id);
    });
  }

  /*
   * Handle delivery json data for a user, in order to display it.
   */
  var handleDeliveries = function(delivery_data, user_id) {
    // check that some deliveries exist
    if (delivery_data.length > 0) {
      // object to hold the highest priority delivery (i.e. the current destination)
      var highest = { idx: -1, p: null, lat: 0, lon: 0 };
      // get the highest priority delivery by going through them all,
      // a lower number means higher priority
      $.each(delivery_data, function(key, val) {
        if (highest.p == null && val.precedence != null) {
          // this is the first element, set it as highest
          highest.idx = key;
          highest.p = val.precedence;
          highest.lat = val.customer.latitude;
          highest.lon = val.customer.longitude;
        } else if (val.precedence != null && val.precedence < highest.p) {
          // higher precedence found, set it as new highest
          highest.idx = key;
          highest.p = val.precedence;
          highest.lat = val.customer.latitude;
          highest.lon = val.customer.longitude;
        }
      });
      // if highest is valid, continue with displaying deliveries
      if (highest.p != null) {
        // set the currrent destination variable of delivery.api
        currentDestination = new Microsoft.Maps.Location(highest.lat, highest.lon);
        // get the last known location from DB and display all on map
        $.getJSON("location/latest", function (latest_data) {
          displayDeliveryInfo(delivery_data, latest_data, user_id, highest.idx);
        });
      } else {
        // invalid highest, center on home
        showHome();
      }
    } else {
      // when no deliveries center map on home
      showHome();
    }
  }

  /*
   * Using delivery info and lastest position, show the routes and markers on the map.
   */
  var displayDeliveryInfo = function(deliveries, latest, user_id, highest_idx) {
    var lastKnown = null;
    var currentDelivery = deliveries[highest_idx];
    // latest contains last position for each user/van,
    // get the one for the user of interest
    if (user_id == null) {
      // if no user_id get from gps
      lastKnown = delivery.gps.getCurrent();
    } else {
      $.each(latest, function (key, value) {
        if (value.user_id === user_id) {
          lastKnown = value;
        }
      });
    }
    // clear the map
    delivery.map.clear();
    // add pins for all deliveries, labeled by precedence
    $.each(deliveries, function (key, value) {
      // don't add pins for completed deliveries
      if (value.complete == null) {
        var pintext = '?';
        if (value.precedence > 0) {
          pintext = value.precedence.toString();
        }
        delivery.map.addMarker(
          value.customer.latitude,
          value.customer.longitude,
          pintext,
          value.customer.name,
          value.customer.address
        );
      }
    });
    // add marker for home
    delivery.map.pinHome();
    // caculate the route from lastKnown to delivery location
    // and show on map
    calculateLeg(lastKnown.latitude + ',' + lastKnown.longitude,
      currentDelivery.customer.latitude + ',' + currentDelivery.customer.longitude);
    // update the last known of van (will update live on device)
    if (delivery.map.isAdmin()) {
      // for admin view, don't need to update location to DB
      delivery.map.addPin(
        lastKnown.latitude, lastKnown.longitude, 'images/truck3_pin.png');
    } else {
      // user/van view (eq null), update latest location aswell as display
      delivery.map.updatePosition(lastKnown.latitude, lastKnown.longitude);
    }
    delivery.hideAjaxLoader();
  }

  /*
   *  Utility mehtod to show only the home marker
   */
  var showHome = function() {
    delivery.map.clear();
    delivery.map.pinHome();
    delivery.map.centerOnHome();
    delivery.hideAjaxLoader();
  }

  /*
   *  Update the view to fit current postion and destination better.
   */
  var updateView = function(location) {
    //console.log("updateView - location: " + location);
    // get rectangle from location to destination
    var rect = Microsoft.Maps.LocationRect.fromLocations(
      location, currentDestination);
    delivery.map.viewToRect(rect, location);
  }

  /*
   * Do a caculation for point to point route, for map display only.
   */
  var calculateLeg = function(start, finish) {
    var optimize = 'distance';
    var url = 'http://dev.virtualearth.net/REST/v1/Routes/Driving?wp.0=' +
      start + '&wp.1=' + finish + '&optimize=' + optimize + '&key=' +
      delivery.map.getApiKey() + '&jsonp=?';
    $.getJSON(url, function(data) {
      // route leg was found
      //console.log(data);
      //console.log(data.statusCode);
      if (data.statusCode == 404) {
        // TODO: do something
        return;
      }
      // array len=4
      bbox = data.resourceSets[0].resources[0].bbox;
      // array of arrays
      coords = data.resourceSets[0].resources[0].routePath.line.coordinates;
      // draw the route on the map and zoom to its bounds
      delivery.map.drawRoute(data.resourceSets[0].resources[0].routePath);
      delivery.map.zoomToBounds(bbox);
    });
  }

  /*
   * Sends a location to database.
   */
  var sendLocation = function(point) {
    //console.log("sending: " + point);
    var gps_data = { location:
      { time: new Date().toUTCString(),
        latitude: point.latitude,
        longitude: point.longitude
      } };
    $.ajax({
      url: "location/update",
      dataType: "json",
      type: "POST",
      processData: false,
      contentType: "application/json",
      data: JSON.stringify(gps_data)
    });
  };

  /*
   * Gets the most recent locations for all users, and display on map.
   */
  var getLocations = function() {
    delivery.showAjaxLoader();
    $.getJSON("location/latest", function( data ) {
      // store all locations here for zoom calculation
      var locationPoints = [];
      // clear map and add home pin
      delivery.map.clear();
      delivery.map.pinHome();
      // NOTE: if any happen to be in exact same position, only one will show
      // loop through returned locations (one for each van/user)
      $.each( data, function( key, val ) {
        //console.log(key + "," + val.time);
        //console.log(val.user_id + " @ " + val.latitude + ", " + val.longitude);
        var time_formatted = moment(val.time).format("h:mm:ss MMMM Do YYYY");
        delivery.map.addMarker(
          val.latitude,
          val.longitude,
          val.user.van.toString(),
          val.user.email,
          time_formatted
        );
        locationPoints.push(new Microsoft.Maps.Location(val.latitude, val.longitude));
      });
      // create rectangle from locations and zoom to it
      var rect = Microsoft.Maps.LocationRect.fromLocations(locationPoints);
      delivery.map.viewToRect(rect);
      delivery.hideAjaxLoader();
    });
  };

  /*
   * Recalculate the route for current user (not if admin)
   */
  var calculateRoute = function() {
    delivery.showAjaxLoader();
    $.getJSON("deliveries/calc")
      .done(function(data) {
        //console.log("recalc: " + data.status);
        getDeliveries();
        delivery.hideAjaxLoader();
      })
      .fail(function( jqxhr, textStatus, error ) {
        console.log( "Request Failed: " + err );
        //delivery.hideAjaxLoader();
      });
    }

  return {
    getDeliveries: getDeliveries,
    calculateRoute: calculateRoute,
    updateView: updateView,
    sendLocation: sendLocation,
    getLocations: getLocations
  };

})();
