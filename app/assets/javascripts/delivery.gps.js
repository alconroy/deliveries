/**
 *  Setups and starts the HTML5 GeoLocation API
 */
delivery.gps = (function() {

  var watchId = null;
  var current = null;

  /*
   * Setup geolocation service.
   */
  var init = function() {
    // check if geolocation api is supported
    if (navigator.geolocation) {
      watchGeo();
      /* fake geo location, for demonstration (comment out line above) */
      //fakeGeo();
    } else {
      alert('Your browser does not support geolocation.');
    }
  };

  /*
   * Set geolocation event, to continually watch for changes.
   */
  var watchGeo = function() {
    var optns = {
      enableHighAccuracy: false,
      timeout: 5000,
      // maybe adjust max age, if too many updates
      maximumAge: 0
    };
    // start watch, and record id so watch can be stopped
    watchId = navigator.geolocation.watchPosition(function(position) {
      if (position != null) {
        current = position.coords;
        ///console.log(current.latitude);
        delivery.map.updatePosition(current.latitude, current.longitude);
      } else {
        console.log("geolocation: unkown error - position invalid");
      }
    }, errorCase);
  };

  /*
   * Handle geolocation errors.
   */
  var errorCase = function(err) {
    console.log("geolocation: watch update - failed");
    if (err.code == 1) {
      // geolocation is not enabled or has been refused
      // 'user denied geolocation'
      console.log("geolocation: denied by user");
      // stop watching geolocation
      if (watchId != null) {
        navigator.geolocation.clearWatch(watchId);
      }
      alert("Geolocation information will not be recorded. This is needed" + 
        "for the app to work correctly.");
    } else if (err.code == 2) {
      // error retrieving position, usually browser or device settings
      console.log("geolocation: error getting location");
      alert("There is a problem getting your location. "
        + "Check the settings for your device.");
    } else {
      // timeout error
      console.log("geolocation: timeout");
    }
  };  

  /*
   * Fake the GeoLocation API by updating with random locations.
   */
  var fakeGeo = function() {
    var locations = delivery.fakegps.dublin_luas();
    var i = 0, len = locations.length;
    // now use timer
    setInterval(function() {
      var p = locations[i];
      current = { latitude: p.latitude, longitude: p.longitude };
      //console.log("interval call: " + p.latitude + ", " + p.longitude);
      delivery.map.updatePosition(p.latitude, p.longitude);
      i++;
      if (i >= len) {
        // keep going back to start
        i = 0;
      }
    }, 2000); // interval gap in milliseconds
  };

  /*
   *  Get the latest gps location from this device directly (not via DB)
   */
  var getCurrent = function() {
    return current;
  };

  return {
    init: init,
    getCurrent: getCurrent
  };

})();
