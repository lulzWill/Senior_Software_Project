
function collapseYelp()
{
  $("#demo").toggle();
}
function collapseKayak()
{
  $("#demo2").toggle();
}

var map;
var location;
var title;
var longitude;
var latitude;
var searchTerm;


function initAutocomplete() 
{
  var map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: -34.397, lng: 150.644},
    zoom: 14,
    mapTypeControl: true,
    mapTypeControlOptions: {
        style: google.maps.MapTypeControlStyle.VERTICAL_BAR,
        position: google.maps.ControlPosition.TOP_CENTER
    },
    zoomControl: true,
    zoomControlOptions: {
        position: google.maps.ControlPosition.LEFT_CENTER
    },
    scaleControl: true,
    streetViewControl: true,
    streetViewControlOptions: {
        position: google.maps.ControlPosition.RIGHT_CENTER
    }
  });
  var infoWindow = new google.maps.InfoWindow({map: map});

  // Try HTML5 geolocation.
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };

      infoWindow.setPosition(pos);
      infoWindow.setContent('You Are Here!!');
      map.setCenter(pos);
    }, function() {
      handleLocationError(true, infoWindow, map.getCenter());
    });
  } else {
    // Browser doesn't support Geolocation
    handleLocationError(false, infoWindow, map.getCenter());
    infoWindow.setContent('We could not find you!!');
  }

  // Create the search box and link it to the UI element.
  var input = document.getElementById('pac-input');
  var searchBox = new google.maps.places.SearchBox(input);
  map.controls[google.maps.ControlPosition.TOP_CENTER].push(input);
  //map.setCenter(location);
  
  
  
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
    var i;
    for(i = 0; i< places.length;i++) 
    {
      var icon = {
        url: places[i].icon,
        size: new google.maps.Size(71, 71),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(17, 34),
        scaledSize: new google.maps.Size(25, 25)
      };
      var address = places[i].formatted_address;
      // Create a marker for each place.
      
      markers.push(new google.maps.Marker({
        map: map,
        title: places[i].name,
        id: places[i].name,
        icon: icon,
        address: address,
        review: places[i].rating,
        position: places[i].geometry.location,
        latitude: places[i].geometry.location.lat(),
        longitude: places[i].geometry.location.lng()
      }));
      var markerCount = 0;
      markers.forEach(function(marker) 
      {
        google.maps.event.addListener(marker, 'click', function() 
        {
          searchTerm = document.getElementById("pac-input").value;
          title = marker.title;
          longitude = marker.longitude;
          latitude = marker. latitude;
          infoWindow.setContent("<div id=\"title\">"+marker.title+"</div><br/><div id=\"address\">"
            +marker.address+"</div><br/>Rating of "+marker.review+"/5<br/><br/>"
            +"<a id=\"visted\" href = \"../visits/new/?name="+escapeChars(marker.title)+"&latitude="+marker.latitude
            +"&longitude="+marker.longitude+"\"  >Mark As Visited</a><br/><br/>"+"<a id=\"visted\" href = \"../locations/show/?name="
            +escapeChars(marker.title)+"&latitude="+marker.latitude+"&longitude="+marker.longitude+"\"  >View Location</a><br/><br/>"
            +"<a id=\"visted\" href = \"../reviews/new/?name="+escapeChars(marker.title)+"&latitude="+marker.latitude+"&longitude="
            +marker.longitude+"\"  >Write a Review</a><br/><br/>"+"<a onclick = \"yelpSearch()\"href = \"#\" >Yelp details</a>"
            );
          infoWindow.open(map,marker);
        });
        markerCount++;
      });
      
      
      if (places[i].geometry.viewport) 
      {
        // Only geocodes have viewport.
        bounds.union(places[i].geometry.viewport);
      } 
      else 
      {
        bounds.extend(places[i].geometry.location);
      }
    };
    map.fitBounds(bounds);
  });
      
  // [END region_getplaces]
}

function handleLocationError(browserHasGeolocation, infoWindow, pos) {
  infoWindow.setPosition(pos);
  infoWindow.setContent(browserHasGeolocation ?
                        'Error: The Geolocation service failed.' :
                        'Error: Your browser doesn\'t support geolocation.');
}

//adds escape characters to location names containing chars like '&'
function escapeChars(str) {
    alert(str);
    str = str.replace(/&/g, '%26');
    str = str.replace(/\?/g, '%3F');
    str = str.replace(/\\/g, '%5C');
    str = str.replace(/\"/g, '%22');
    str = str.replace(/\=/g, '%3D');
    str = str.replace(/\//g, '%2F');
    alert(str);
    return str;                
}

//clicking on vendor link - Reused code

function yelpSearch()
{
  $.ajax({
    type: "GET",
    url: "/users/_yelp_results?name="+title+"&longitude="+longitude+"&latitude="+latitude+"&term="+searchTerm,
    success: function(result) {
      //alert("got success condition");
      var oneFourth = Math.ceil($(window).width()/4);
      $("#individual").html(result).
      css({'left': "100px", 'top': "100px", 'width': oneFourth, 'position': 'absolute'}).
      show();
      $('#close_individual').click(function() {
        $("#individual").hide();
      })
    }
  }); 
}
$(document).mouseup(function (e)
{
    var container = $("#individual");
    if (!container.is(e.target) // if the target of the click isn't the container...
        && container.has(e.target).length === 0) // ... nor a descendant of the container
    {
        container.hide();
    }
});