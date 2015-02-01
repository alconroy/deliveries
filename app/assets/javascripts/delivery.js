/*
 *  Main javascript object, acts as a module namespace for the rest of mapping
 *  scripts. Also, contains setup and other common functions.
 */
var delivery = {
  // redirects to map page when needed
  ensureMapView: function() {
    var location = window.location;
    // assign location to root/home view, if not already
    if (location.pathname != "/") {
      location.assign("/");
    }
  },
  // Add listeners for van dropdown
  addDropListeners: function() {
    $("#nav-user-list li a").each(function(index) {
      var link_id = $(this).attr("id");
      var user_id = $(this).data("user-id");
      var van_id = $(this).data("van-id");
      if (/user\-all/.test(link_id)) {
        // display current postions
        $(this).click(function(e) {
          e.preventDefault();
          delivery.ensureMapView();
          delivery.map.setTitle("Current Van Locations");
          //console.log("Clicked All - " + link_id);
          delivery.api.getLocations();
        });
      } else if (/user\-\d+/.test(link_id)) {
        // display this vans route and position
        $(this).click(function(e) {
          e.preventDefault();
          delivery.ensureMapView();
          delivery.map.setTitle("Deliveries for Van " + van_id);
          //console.log("Clicked - " + link_id);
          delivery.api.getDeliveries(user_id);
        });
      }
    });
  },
  // recalculate route button
  // recalcButton: function() {
  //   $("#mobile-recalc-btn").click(function(e) {
  //     e.preventDefault();
  //     delivery.ensureMapView();
  //     delivery.api.calculateRoute();
  //   });
  // },
  // functions for showing/hiding ajax loading image
  showAjaxLoader: function() {
    $('#loading-modal').fadeIn();
  },
  hideAjaxLoader: function() {
    $('#loading-modal').fadeOut();
  },
  // initialize map and other scripts
  init: function() {
    // initialize map stuff
    delivery.map.init();
    // add buton listeners
    delivery.addDropListeners();
    //delivery.recalcButton();
    // Auto close alert boxes after 5 secs
    window.setTimeout(function() {
      $(".alert-box a.close").trigger("click.fndtn.alert");
    }, 5000);
  }
};