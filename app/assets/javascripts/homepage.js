var results;
var map;


window.onload = function() {
  results = document.getElementById("results");
  var mapOptions = {
    zoom: 13,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("mapSurface"), mapOptions);


  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      geolocationSuccess, geolocationFailure
    );

    results.innerHTML = "The search has begun.";
  } else {
    results.innerHTML = "This browser doesn't support geolocation.";
  }
}

function geolocationSuccess(position) {

      var location = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
      map.setCenter(location);

var infowindow = new google.maps.InfoWindow();

      infowindow.setContent("You are here, or somewhere thereabouts.");
      infowindow.setPosition(location);
      infowindow.open(map);

 results.innerHTML = "Now you're on the map.";
}

function geolocationFailure(positionError) {
  if (positionError.code == 1) {
    results.innerHTML = 
     "You decided not to share, but that's OK. We won't ask again.";
  }
  else if (positionError.code == 2) {
    results.innerHTML =
     "The network is down or the positioning service can't be reached.";
  }
  else if (positionError.code == 3) {
    results.innerHTML =
     "The attempt timed out before it could get the location data.";
  }
  else {
    results.innerHTML =
     "This the mystery error. Something else happened, but we don't know what.";
  }
}
  var input = document.getElementById('pac-input');
  var searchBox = new google.maps.places.SearchBox(input);
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

  // Bias the SearchBox results towards current map's viewport.
  map.addListener('bounds_changed', function() {
    searchBox.setBounds(map.getBounds());
  });

  var markers = [];
  // [START region_getplaces]
  // Listen for the event fired when the user selects a prediction and retrieve
  // more details for that place.
  searchBox.addListener('places_changed', function() {
    var places = searchBox.getPlaces();

    if (places.length == 0) {
      return;
    }

    // Clear out the old markers.
    markers.forEach(function(marker) {
      marker.setMap(null);
    });
    markers = [];

    // For each place, get the icon, name and location.
    var bounds = new google.maps.LatLngBounds();
    places.forEach(function(place) {
      var icon = {
        url: place.icon,
        size: new google.maps.Size(71, 71),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(17, 34),
        scaledSize: new google.maps.Size(25, 25)
      };

      // Create a marker for each place.
      markers.push(new google.maps.Marker({
        map: map,
        icon: icon,
        title: place.name,
        position: place.geometry.location
      }));

      if (place.geometry.viewport) {
        // Only geocodes have viewport.
        bounds.union(place.geometry.viewport);
      } else {
        bounds.extend(place.geometry.location);
      }
    });
    map.fitBounds(bounds);
  });
  // [END region_getplaces]

