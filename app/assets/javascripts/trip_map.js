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
var paststate;
var pastmarkers;
var datahash_id;
var visitId;
var datahash;
var directionsDisplayArray = [];
var directionsService;
var route_markers = [];
var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var labelIndex = 0;

function initAutocomplete() 
{
  paststate = 0;
  directionsDisplay = new google.maps.DirectionsRenderer();
  directionsService = new google.maps.DirectionsService();
  
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
  var input = document.getElementById('pac-input2');
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
          searchTerm = document.getElementById("pac-input2").value;
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

function setMapPos(lat,lang) {
   var pos = {
      lat: lat,
      lng: lang
    };
    
    map.setCenter(pos);
    map.setZoom(14);
}
//function to populate form
function form_function()
{
    $('#addvisitform').show();
    document.getElementById("visit_header").innerHTML = current_marker.title; 
    document.getElementById("location_name").value = current_marker.title;
    document.getElementById("location_lat").value = current_marker.latitude;
    document.getElementById("location_long").value = current_marker.longitude;
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

function showEditDialogue(tripId, visitId) {
  $('#'+visitId).hide();
  $('#'+visitId+'_edit').show();
}

function cancelChange(tripId, visitId) {
  $('#'+visitId).show();
  $('#'+visitId+'_edit').hide();
}

$(document).ready(function(){
    $('#edit_menu').hide();
    $('#addvisitform').hide();
    
    $('.leg_edit_button').click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      e.stopImmediatePropagation();
      //console.log('click');
      $('#edit_menu').toggle();
    });
    
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


function calcRoute(latStart,langStart,latEnd,langEnd,last,markerNumber) {
  var directionsDisplay = new google.maps.DirectionsRenderer();
  directionsDisplayArray.push(directionsDisplay);
  var start = new google.maps.LatLng(latStart, langStart);
  //var end = new google.maps.LatLng(38.334818, -181.884886);
  var end = new google.maps.LatLng(latEnd, langEnd);
  var bounds = new google.maps.LatLngBounds();
  bounds.extend(start);
  bounds.extend(end);
  map.fitBounds(bounds);
  var request = {
      origin: start,
      destination: end,
      travelMode: google.maps.TravelMode.WALKING
  };
  directionsService.route(request, function (response, status) {
      if (status == google.maps.DirectionsStatus.OK) {
          directionsDisplay.setDirections(response);
          directionsDisplay.setMap(map);
          directionsDisplay.setOptions( { suppressMarkers: true } );
          
          var pos = new google.maps.LatLng(latStart, langStart);
          var marker = new google.maps.Marker({
            position: pos,
            label: labels[labelIndex++ % labels.length],
            latitude: latStart,
            longitude: langStart,
            map: map
          });
          route_markers.push(marker);
          
          var pos = new google.maps.LatLng(latEnd, langEnd);
          if(last) {
            var marker = new google.maps.Marker({
              position: pos,
              label: labels[labelIndex++ % labels.length],
              latitude: latEnd,
              longitude: langEnd,
              map: map
            });
            route_markers.push(marker);
          }
          
      } else {
          var request = {
            origin: start,
            destination: end,
            travelMode: google.maps.TravelMode.DRIVING
          };
          
          directionsService.route(request, function (response, status) {
             if (status == google.maps.DirectionsStatus.OK) {
               directionsDisplay.setDirections(response);
               directionsDisplay.setMap(map);
               
               var pos = new google.maps.LatLng(latStart, langStart);
               var marker = new google.maps.Marker({
                position: pos,
                label: labels[labelIndex++ % labels.length],
                latitude: latStart,
                longitude: langStart,
                map: map
              });
              
              route_markers.push(marker);
              var pos = new google.maps.LatLng(latEnd, langEnd);
              if(last) {
                var marker = new google.maps.Marker({
                  position: pos,
                  label: labels[labelIndex++ % labels.length],
                  latitude: latEnd,
                  longitude: langEnd,
                  map: map
                });
                
                route_markers.push(marker);
              }
             } else {
               console.log("Directions Request from " + start.toUrlValue(6) + " to " + end.toUrlValue(6) + " failed: " + status);
             }
          });
      }
  });
}

function setMapOnAll(map) {
  for (var i = 0; i < route_markers.length; i++) {
    route_markers[i].setMap(map);
  }
}

function hideRouteMarkers() {
  if(document.getElementById('hide_show_btn').innerHTML == "Hide Route Markers") {
    setMapOnAll(null);
    document.getElementById('hide_show_btn').innerHTML = "Show Route Markers";
  } else {
    setMapOnAll(map);
    document.getElementById('hide_show_btn').innerHTML = "Hide Route Markers";
  }
}
//toggel for past map locations button

function togglePastmap(locations) 
{
  setMapOnAll(null);
  route_markers = [];
  labelIndex = 0;
  datahash = locations;
  for(var i = 0; i < directionsDisplayArray.length; i++) {
    directionsDisplayArray[i].setMap(null);
  }
  putRoutes();
}

//getting past map points
function putRoutes()
{
  pastmarkers = [];
  for(var i=0;i<datahash.length;i++)
  {
    if(i != datahash.length - 1) {
      if(i == datahash.length - 2) {
        calcRoute(datahash[i][0], datahash[i][1], datahash[i+1][0], datahash[i+1][1],true,i+1);
      } else {
        calcRoute(datahash[i][0], datahash[i][1], datahash[i+1][0], datahash[i+1][1],false,i+1);
      }
    }
  }
}

//These two functions with AJAX requests were done in an effort to potentially allow the page to operate without refreshing.
//TODO: rather than just reloading the page on AJAX Success, make sure that the UI is updated appropriately. The challenge here lies in the google maps routing. View will have to be changed to accomodate as well.
function removeVisit(legId,visitId)
{
  $.ajax({
    type: "POST",
    url: "/legs/deleteLegVisit?leg_id="+legId+"&visit_id="+visitId,
    success: function(result) {
      //alert("got success condition");
      window.location.reload(true);
    }, failure: function(error) {
      alert("Was not able to update visit: " + error);
    }
  }); 
}

function changeVisitTime(legId,visitId)
{
  document.getElementById(visitId+'_confirm').disabled = true;
  var date = $('#'+visitId+'_start_date').val();
  var time = $('#'+visitId+'_visit_time').val();
  
  $.ajax({
    type: "POST",
    url: "/legs/updateLegVisit?leg_id="+legId+"&visit_id="+visitId+"&start_date="+date+"&visit_time="+time,
    success: function(result) {
      //alert("got success condition");
      window.location.reload(true);
    }, failure: function(error) {
      document.getElementById(visitId+'_confirm').disabled = false;
      alert("Was not able to update visit " + error);
    }
  }); 
}

function removeLeg(legId)
{
  document.getElementById(legId+'_remove').disabled = true;
  $.ajax({
    type: "DELETE",
    url: "/legs/"+legId+"?ajaxCall=true",
    success: function(result) {
      //alert("got success condition");
      window.location.reload(true);
    }, failure: function(error) {
      document.getElementById(legId+'_remove').disabled = false;
      alert("Was not able to delete Leg " + error);
    }
  }); 
}
