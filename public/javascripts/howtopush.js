var map = null;
var socket = null;
var marker_list = [];

function setup_socket(api_key, channel) {
  socket = new Pusher(api_key, channel);

  socket.bind('location_move', function(data) {
    var elm = '<li style="display:none;" class="new"><p class="time">'+data.vehicle.timestamp+'</p><div class="close"></div><p class="title">Vehicle: '+data.vehicle.id+'</p><p class="location"><a href="http://maps.google.com/maps?hl=en&amp;q='+data.vehicle.lat+','+data.vehicle.lon+'" target="_blank">'+data.vehicle.lat+','+data.vehicle.lon+'</a></p><p class="content">'+data.vehicle.destination+'</p></li>';

    // Remove existing markers if not a duplicate
    existing = marker_list[data.vehicle.id];
    if (existing != null && (existing.lat != data.vehicle.lat || existing.lon != data.vehicle.lon)) {
      clearMarkers([existing.marker]);
    }

    // Create new marker and stuff into the list
    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(data.vehicle.lat, data.vehicle.lon),
      map: map,
      title:"Hello World!"
    });
    marker_list[data.vehicle.id] = { 'lat': data.vehicle.lat, 'lon': data.vehicle.lon, 'marker': marker };
    
    // Add the item to the list
    $('.pushes ul').prepend(elm);
    
    // Slide the item in
    $('.new').slideDown();
    $('.new').removeClass('new');
  });
}

function define_map(lat, lon) {
  return new google.maps.Map(document.getElementById("map_canvas"), {
    zoom: 10,
    center: new google.maps.LatLng(lat, lon),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });
}

function clearMarkers(list) {
  for (i in list) {
    if (list[i] != null) {
      list[i].setMap(null);
    }
  }
}

function request(url) {
  $.get(url, { }, function(data) {
    if (data != 0) {
      alert('There was an error pushing your event!');
    }
  });
}

function ping_routes(vehicle_route) {
  if(vehicle_route != '') {
    request('/vehicle_routes/' + vehicle_route + '/ping.js')
  }
}

$(document).ready(function() {
  map = define_map(41.8379815299556,-87.6218794336859);

  // Retry button event handler
  $('#retry_button').click(function() {
    ping_routes( $('#vehicle_route').val() );
  })

  // Clear button event handler
  $('#clear_button').click(function() {
    clearMarkers(marker_list);
  });

  // Close bus box event handler
	$('.close').live('click',function() {
	  $(this).parent('li').slideUp();
		setTimeout("$(this).parent('li').remove();",300);
	});

  // Updating drop down event handler
  $('#vehicle_route').change(function() {
    $('.pushes ul').children().each(function() {
      $(this).remove();
    })

    map = define_map(41.8379815299556,-87.6218794336859);
    vehicle_route = $('#vehicle_route').val();
    socket = setup_socket( $('#key').val(), 'vehicle_route_' + vehicle_route );

    ping_routes(vehicle_route);
	});
});
