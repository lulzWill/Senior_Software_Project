
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
var heatmap;
var datamap;
var datahash;
var heatstate;
var paststate;
var pastmarkers;
var datahash_id;
var visitId;
var gradient =[
    'rgba(0, 0, 0, 0)',
    'rgba(55, 55, 55, 1)',
    'rgba(0, 195, 0, 1)',
    'rgba(0, 205, 0, 1)',
    'rgba(0, 215, 0, 1)',
    'rgba(0, 225, 0, 1)',
    'rgba(0, 235, 0, 1)',
    'rgba(0, 245, 0, 1)',
    'rgba(0, 255, 0, 1)',
    'rgba(0, 205, 205, 1)',
    'rgba(0, 215, 215, 1)',
    'rgba(0, 225, 225, 1)',
    'rgba(0, 235, 235, 1)',
    'rgba(0, 245, 245, 1)',
    'rgba(0, 255, 255, 1)',
    'rgba(0, 0, 195, 1)',
    'rgba(0, 0, 205, 1)',
    'rgba(0, 0, 215, 1)',
    'rgba(0, 0, 225, 1)',
    'rgba(0, 0, 235, 1)',
    'rgba(0, 0, 245, 1)',
    'rgba(0, 0, 255, 1)'];


function initAutocomplete() 
{
  heatstate = 0;
  paststate = 0;
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
      loc_me = new google.maps.InfoWindow({map: map});
      loc_me.close(map);
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
      
      var markerCount = 0;
      markers.forEach(function(marker) 
      {
        google.maps.event.addListener(marker, 'click', function() 
        {
          searchTerm = document.getElementById("pac-input").value;
          title = marker.title;
          longitude = marker.longitude;
          latitude = marker.latitude;
          address = marker.address;
          infoWindow.setContent("<div id=\"title\">"+marker.title+"</div><br/><div id=\"address\">"
            +marker.address+"</div><br/>Rating of "+marker.review+"/5 from Google<br/><br/>"
            +"<a id=\"visted\" href = \"../visits/new/?name="+escapeChars(marker.title)+"&latitude="+marker.latitude
            +"&longitude="+marker.longitude+"\"  >Mark As Visited</a><br/><br/>"+"<a id=\"visted\" href = \"../locations/show/?name="
            +escapeChars(marker.title)+"&latitude="+marker.latitude+"&longitude="+marker.longitude+"&from_map=1\"  >View Location</a><br/><br/>"
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

function handleLocationError(browserHasGeolocation, infoWindow, pos) 
{
  loc_me.setPosition(pos);
  loc_me.setContent(browserHasGeolocation ?
                        'Error: The Geolocation service failed.' :
                        'Error: Your browser doesn\'t support geolocation.');
}

//adds escape characters to location names containing chars like '&'
function escapeChars(str) 
{
    str = str.replace(/&/g, '%26');
    str = str.replace(/\?/g, '%3F');
    str = str.replace(/\\/g, '%5C');
    str = str.replace(/\"/g, '%22');
    str = str.replace(/\=/g, '%3D');
    str = str.replace(/\//g, '%2F');
    return str;                
}

//reposition map and so icon for where you currently are
function toggleMe()
{
  map.setCenter(loc_of_me);
}

//toggel for past map locations button

function togglePastmap(locations,locations_id,visits_id) 
{
  datahash = locations;
  datahash_id = locations_id;
  visitId = visits_id;
  if (paststate==0)
  {
    getmarkers();
    paststate = 1;
  }
  else 
  {
    //alert("got here");
    pastmarkers.forEach(function(pastmarker) 
    {
      if(pastmarker.getVisible()) 
      {
        //alert("markers are visible");
        pastmarker.setVisible(false);
      }
      else 
      {
        //alert("markers are hidden");
        pastmarker.setVisible(true);
      }
    });
  }
}

//getting past map points
function getmarkers()
{
  pastmarkers = [];
  for(var i=0;i<datahash.length;i++)
  {
    pastmarkers[i]= new google.maps.Marker({
      position: {lat: datahash[i][0], lng: datahash[i][1]},
      map: map,
      location_id: datahash_id[i],
      visit_id: visitId[i]
    });
  }
  pastmarkers.forEach(function(pastmarker) 
  {
    google.maps.event.addListener(pastmarker, 'click', function() 
    {
      pastbox(pastmarker.location_id,pastmarker.visit_id);
    });
  });
}
//ajax for past location
function pastbox(location_id,visit_id)
{
  //alert(location_id+", "+visit_id);
  $.ajax({
    type: "POST",
    url: "/users/_past_results",
    data: {loc_id: location_id, visit_id: visit_id},
    success: function(results) {
      //alert(results);
      var oneFourth = Math.ceil($(window).width()/4);
      $("#individual2").html(results).
      css({'left': "100px", 'top': "120px", 'width': oneFourth, 'position': 'absolute'}).
      show();
    }
  }); 
}

//toggel for heat map button

function toggleHeatmap(locations) 
{
  datahash=locations;
  if (heatstate==0)
  {
    heatmap = new google.maps.visualization.HeatmapLayer({
    data: getPoints()
    });
    heatmap.setMap(map);
    heatmap.set('gradient', gradient);
    heatmap.set('radius',20);
    heatstate =1;
  }
  else if (heatstate ==1)
  {
    heatmap.setMap(heatmap.getMap() ? null : map);
  }
}

//getting heat map points
function getPoints()
{
  var points =[];
  for(var i=0;i<datahash.length;i++)
  {
    points.push(new google.maps.LatLng(datahash[i][0], datahash[i][1]));
  }
  return points;
}


//clicking on yelp link 

function yelpSearch()
{
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

$(document).mouseup(function (e)
{
    var container = $("#individual");
    if (!container.is(e.target) // if the target of the click isn't the container...
        && container.has(e.target).length === 0) // ... nor a descendant of the container
    {
        container.hide();
    }
});

$(document).mouseup(function (e)
{
    var container = $("#individual2");
    if (!container.is(e.target) // if the target of the click isn't the container...
        && container.has(e.target).length === 0) // ... nor a descendant of the container
    {
        container.hide();
    }
});