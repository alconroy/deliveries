/**
 *  Handles display of Map and drawing of lines and points
 */
delivery.map = (function() {

  var theMap;
  var currentPosition;

  var apiKey;
  var homeLatitude;
  var homeLongitude;
  var viewAll;
  var adminUser;
  var currUserId;

  /*
   * Initialize map and look for apikey in HTML.
   */
  var init = function() {
    getJsVars();
    if (apiKey != null) {
      // must be a map page init the map
      Microsoft.Maps.loadModule('Microsoft.Maps.Themes.BingTheme', {
        callback: setupMap
      });
    }
  };

  /*
   * Sets default map behaviour, locations vs deliveries.
   */
  var initData = function() {
    if (viewAll == true) {
      // true => Admin view, defaults to showing all van locations
      delivery.api.getLocations();
    } else {
      // false => Mobile view    
      delivery.api.getDeliveries(currUserId);
      hideTitle();
    }
    // setup gps watch if not admin
    if (!adminUser) {
      delivery.gps.init();
    }
  }

  /*
   * Actual map setup, define default settings.
   */
  var setupMap = function() {
    theMap = new Microsoft.Maps.Map(
      document.getElementById("map-container"),
      {
        credentials: apiKey,
        center: new Microsoft.Maps.Location(homeLatitude, homeLongitude),
        mapTypeId: Microsoft.Maps.MapTypeId.road,
        zoom: 12,
        enableClickableLogo: false,
        enableSearchLogo: false,
        showDashboard: false,
        showCopyright: true,
        showScalebar: false,
        theme: new Microsoft.Maps.Themes.BingTheme()
      }
    );
    initData();
    // For testing, the map click event used to update position by click.
    //Microsoft.Maps.Events.addHandler(theMap, 'click', clickToUpdatePosition);
  }

  /*
   * Set the side label title on the map.
   */
  var setTitle = function(title) {
    $("#map-title").text(title);
  };

  /*
   * Hide the sidel label title on the map. Used on device.
   */
  var hideTitle = function() {
    $("#map-title").hide();
  }

  var updatePosition = function(latitude, longitude) {
    var loc = new Microsoft.Maps.Location(latitude, longitude);
    // check to see if map already has current position marked
    if (currentPosition == null) {
      currentPosition = new Microsoft.Maps.Pushpin(loc, { icon: 'images/truck3_pin.png' });
      theMap.entities.push(currentPosition);
    } else {
      // find current position pin, and change it to new location
      idx = theMap.entities.indexOf(currentPosition);
      if (idx >= 0) {
        theMap.entities.get(idx).setLocation(loc);
      } else {
        currentPosition = new Microsoft.Maps.Pushpin(loc, { icon: 'images/truck3_pin.png' });
        theMap.entities.push(currentPosition);
      }
    }
    delivery.api.sendLocation(loc);
    delivery.api.updateView(loc);
  };


  /*
   * Add simple pin with image icon and no popup.
   */
  var addPin = function(latitude, longitude, icon) {
    var loc = new Microsoft.Maps.Location(latitude, longitude);
    theMap.entities.push(new Microsoft.Maps.Pushpin( loc, { icon: icon } ));
  };

  /*
   * Add a Bing pin with text icon and popup.
   */
  var addMarker = function(latitude, longitude, number, title, description) {
    loc = new Microsoft.Maps.Location(latitude, longitude);
    ibox = new Microsoft.Maps.Infobox(loc, {
      title: title,
      description: description,
      visible: true});
    pin = new Microsoft.Maps.Pushpin(loc, { text: number, infobox: ibox });
    theMap.entities.push(pin);
    theMap.entities.push(ibox);
  };

  var drawRoute = function(path) {
      var points = path.line.coordinates;
      var map_points = [];
      //console.log("points: " + points.length)
      for (var i = 0; i < points.length; i++) {
          lat = points[i][0];
          lon = points[i][1];
          p = new Microsoft.Maps.Location(lat, lon);
          map_points.push(p)
      }
      theMap.entities.push(
        new Microsoft.Maps.Polyline(map_points, { strokeThickness: 5 }));
  };

  /*
   * Zoom the map to a rectangle bounding box.
   */
  var zoomToBounds = function(bbox) {
    var bounds = Microsoft.Maps.LocationRect.fromCorners(
      new Microsoft.Maps.Location(bbox[0],bbox[1]),
      new Microsoft.Maps.Location(bbox[2],bbox[3]));
    theMap.setView({bounds: bounds});
  }
  var viewToRect = function(rect, center) {
    //theMap.setView({center: center, zoom: 14});
    theMap.setView({bounds: rect, padding: 100});
  }

  /*
   * Clear all map pins etc.
   */
  var clear = function() {
    theMap.entities.clear();
  }

  /*
   * Add pin at home location.
   */
  var pinHome = function() {
    addPin(homeLatitude, homeLongitude, 'images/home_pin.png');
  }

  /*
   * Center the map on the home location.
   */
  var centerOnHome = function() {
    theMap.setView({
      center: new Microsoft.Maps.Location(homeLatitude, homeLongitude), 
      zoom: 14
    });
  }

  /*
   * Test to see if admin user.
   */
   var isAdmin = function() {
    return adminUser === "true";
   }

  /*
   * Get the variables added to the HTML by the rails app.
   */
  var getJsVars = function() {
    var coords;
    viewAll = $('#js-vars').data('view-all');
    apiKey = $('#js-vars').data('key');
    coords = $('#js-vars').data('home');
    adminUser = $('#js-vars').data('admin');
    currUserId = $('#js-vars').data('uid');
    if (coords != null) {
      coords = coords.split(',');
      homeLatitude = parseFloat(coords[0]);
      homeLongitude = parseFloat(coords[1]);
    }
  }

  /* 
   * A testing function to update postion on the map by mouse click.
   * (Need to uncomment event handler in setupMap() to enable)
   */
  var clickToUpdatePosition = function(e) {
    if (e.targetType == "map") {
      var point = new Microsoft.Maps.Point(e.getX(), e.getY());
      var loc = e.target.tryPixelToLocation(point);
      updatePosition(loc.latitude, loc.longitude);
    }
  }

  /*
   *  Return the Bing API Key
   */
  var getApiKey = function() {
    return apiKey;
  }

  return {
    init: init,
    updatePosition: updatePosition,
    addPin: addPin,
    addMarker: addMarker,
    drawRoute: drawRoute,
    zoomToBounds: zoomToBounds,
    viewToRect: viewToRect,
    initData: initData,
    setTitle: setTitle,
    clear: clear,
    centerOnHome: centerOnHome,
    pinHome: pinHome,
    isAdmin: isAdmin,
    getApiKey: getApiKey
  };

})();