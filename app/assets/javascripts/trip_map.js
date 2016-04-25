//Include these to elements in the view to use the below code but also 
//you will need to include these below scripts at the top of the page

//Scripts
//%script{:async => "", :defer => "", :src => "https://maps.googleapis.com/maps/api/js?key=AIzaSyBxnXZJRg6NIKFRtVR1YPzArruPdSzImsI&libraries=places,visualization&callback=initAutocomplete"}

//Elements
// %input#pac-input{:placeholder => "Search Box", :type => "text",:style => "width: 35%;height: 4%;"}
// #map{:style => "width: 100%;height: 500px;border-radius: 1%; border: 1px #5cb85c;"}

var map;
var loc_of_me;
var pic_of_me;
var loc_me;
var location;
var title;
var longitude;
var latitude;
var searchTerm;
var address;
var trip_markers = [];
var current_maker;


function initAutocomplete() 
{
  map = new google.maps.Map(document.getElementById('map'), {
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
  infoWindow.close(map);
  // Try HTML5 geolocation.
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var url = document.getElementById("profile_pic").value
      //alert(url);
      var pos = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };
      loc_of_me = pos;
      
      var person_icon = {
        url: url,
        size: new google.maps.Size(80, 80),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(17, 34),
        scaledSize: new google.maps.Size(30, 30)
      };
      
      pic_of_me = new google.maps.Marker({
        position: loc_of_me,
        map: map,
        icon: person_icon
      });
      map.setCenter(pos);
    }, function() {
      handleLocationError(true, loc_me, map.getCenter());
    });
  } 
  else 
  {
    // Browser doesn't support Geolocation
    handleLocationError(false, loc_me, map.getCenter());
    loc_me.setContent('We could not find you!!');
  }

  // Create the search box and link it to the UI element.
  var input = document.getElementById('pac-input');
  var searchBox = new google.maps.places.SearchBox(input);
  map.controls[google.maps.ControlPosition.TOP_CENTER].push(input);
  
  
  
  
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
      //alert(address);
      if(places[i].rating)
      {
        var rating = places[i].rating;
        //alert("rating there");
      }
      else
      {
        var rating = "-";
        //alert("rating undefined");
      }
      markers.push(new google.maps.Marker({
        map: map,
        title: places[i].name,
        id: places[i].name,
        icon: icon,
        address: address,
        review: rating,
        position: places[i].geometry.location,
        latitude: places[i].geometry.location.lat(),
        longitude: places[i].geometry.location.lng()
      }));
      //console.log(markers[0].address);
      var markerCount = 0;
      markers.forEach(function(marker) 
      {
        google.maps.event.addListener(marker, 'click', function() 
        {
          //incase passing marker doesnt work
          current_marker = marker;
          searchTerm = document.getElementById("pac-input").value;
          title = marker.title;
          longitude = marker.longitude;
          latitude = marker.latitude;
          address = marker.address;
          //console.log(marker.address);
          infoWindow.setContent("<div id=\"title\">"+marker.title+"</div><br/><div id=\"address\">"
            +marker.address+"</div><br/>Rating of "+marker.review+"/5 from Google<br/><br/>"
            +"<a onclick =\"form_function()\" id=\"visit\">Add Visit to Trip</a><br/><br/>"+
            "<a onclick = \"yelpSearch()\"href = \"#\" >Yelp details</a>"
            );
          document.getElementById("visit_header").innerHTML = current_marker.title;  
          document.getElementById("location_name").value = current_marker.title;
          document.getElementById("location_lat").value = current_marker.latitude;
          document.getElementById("location_long").value = current_marker.longitude;
          infoWindow.open(map,marker);
        });
        //markerCount++;
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
//function to populate form
function form_function()
{
    //use current_marker if passingmarker doesnt work uncomment 
    //the lines with current marker and change this function 
    //to use that global variable
    
    //create new marker for visit
    //var new_trip_marker = new google.maps.Marker({
    //    map: map,
    //    title: current_marker.name,
    //    id: current_marker.name,
    //    icon: current_marker.icon,
    //    address: current_marker.address,
    //    review: current_marker.rating,
    //    position: current_marker.posistion,
    //    latitude: current_marker.latitude,
    //    longitude: current_marker.longitude
    //  });
      
    //add marker to marker array for visit locations
    trip_markers.push(new_trip_marker);
    
    //click function for that specific marker if you want one
    google.maps.event.addListener(new_trip_marker, 'click', function() 
    {
      //could use infowindow or anything just depends what you want it to do.
    });
    //transfer all marker data to form
}
//handle location error for geolocation
function handleLocationError(browserHasGeolocation, infoWindow, pos) 
{
  loc_me.setPosition(pos);
  loc_me.setContent(browserHasGeolocation ?
                        'Error: The Geolocation service failed.' :
                        'Error: Your browser doesn\'t support geolocation.');
}

//clicking on yelp link 
function yelpSearch()
{
  //console.log(address);
  $.ajax({
    type: "GET",
    url: "/users/_yelp_results?name="+title+"&longitude="+longitude+"&latitude="+latitude+"&term="+searchTerm+"&address="+address,
    success: function(result) {
      //alert("got success condition");
      var oneFourth = Math.ceil($(window).width()/4);
      $("#individual").html(result).
      css({'left': "100px", 'top': "120px", 'width': oneFourth, 'position': 'absolute'}).
      show();
    }
  }); 
}

//closes the yelp partial if clicked out side of it
$(document).mouseup(function (e)
{
    var container = $("#individual");
    if (!container.is(e.target) // if the target of the click isn't the container...
        && container.has(e.target).length === 0) // ... nor a descendant of the container
    {
        container.hide();
    }
});

$(document).ready(function(){
    $('#addLeg').hide();
    if($("#trip_legs option:selected" ).text() == "New Leg") {
      $('#addLeg').show();
    }
    
    $('#trip_legs').change(function(e) {
      if($("#trip_legs option:selected" ).text() == "New Leg") {
        $('#addLeg').show();
      } else {
        $('#addLeg').hide();
        $("#trip_legs option:selected" ).text() == ""
      }
    });
    
    $('#add_to_leg_form').on('submit', function(e){
      
    });
});

$('#leg_edit_button').click(function(e) {
  $('leg_edit').toggle;
});