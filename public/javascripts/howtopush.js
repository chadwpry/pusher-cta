var map = null;
var socket = null;
var timer_id = null;
var interval = 15;
var marker_list = [];
var marker_count = null;

function attach_message(marker, data) {
  var message_data = '<li style="display:none;" class="new">'+
                      '<p class="time">'+data.vehicle.timestamp+'</p>'+
                      '<div class="close"></div>'+
                      '<p class="title">Vehicle: '+data.vehicle.vid+'</p>'+
                      '<p class="location"><a href="http://maps.google.com/maps?hl=en&amp;q='+data.vehicle.lat+','+data.vehicle.lon+'" target="_blank">'+data.vehicle.lat+','+data.vehicle.lon+'</a></p>'+
                      '<p class="content">'+data.vehicle.destination+'</p>'+
                    '</li>';
  var infowindow = new google.maps.InfoWindow({
    content: message_data
  });
  google.maps.event.addListener(marker, 'click', function() {
    infowindow.open(map, marker);
  });
}

function stop_timer() {
  socket = null;
  if (timer_id != null) {
    clearTimeout(timer_id);
    $('#vehicle_route').attr('selectedIndex', 0);
    $('#refresh_ticker').text('Stopped');
    $('#stop_button').attr('style', 'display: none');
    marker_list = [];
  }
}

function setup_socket(api_key, channel) {
  // Instantiate the socket
  socket = new Pusher(api_key, channel);

  // Set the vehicle marker count
  marker_count = 0;
  $('#vehicle_count').text(marker_count);

  // Bind to our event
  socket.bind('location_move', function(data) {
    var elm = '<li style="display:none;" class="new"><p class="time">'+data.vehicle.timestamp+'</p><div class="close"></div><p class="title">Vehicle: '+data.vehicle.vid+'</p><p class="location"><a href="http://maps.google.com/maps?hl=en&amp;q='+data.vehicle.lat+','+data.vehicle.lon+'" target="_blank">'+data.vehicle.lat+','+data.vehicle.lon+'</a></p><p class="content">'+data.vehicle.destination+'</p></li>';

    if (marker_list[data.vehicle.vid] != null) {
      marker_list[data.vehicle.vid].marker.setMap(null);
      marker_list[data.vehicle.vid] = null;
      $('#vehicle_count').text(--marker_count);
    }

    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(data.vehicle.lat, data.vehicle.lon),
      map: map,
      title:"Vehicle: " + data.vehicle.vid
    });
    attach_message(marker, data);
    marker_list[data.vehicle.vid] = { 'lat': data.vehicle.lat, 'lon': data.vehicle.lon, 'marker': marker };
    $('#vehicle_count').text(++marker_count);

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

function update_ticker(vehicle_route) {
  decrement = -1;
  ticker = parseInt($('#refresh_ticker').text());

  if (isNaN(ticker)) {
    $('#refresh_ticker').text(interval);
    ping_routes(vehicle_route);
  } else {
    ticker = ticker + decrement;
    $('#refresh_ticker').text(ticker);
    if (ticker == 0) {
      $('#refresh_ticker').text(interval);
      ping_routes(vehicle_route);
    }
  }

  timer_id = setTimeout('update_ticker(\''+vehicle_route+'\')', Math.abs(decrement) * 1000);
}

$(document).ready(function() {
  map = define_map(41.8379815299556,-87.6218794336859);
  $('#vehicle_count').text(0);
  $('#refresh_ticker').text('Stopped');

  $('#stop_button').click(function() {
    stop_timer();
  })

  // Close bus box event handler
	$('.close').live('click',function() {
	  $(this).parent('li').slideUp();
		setTimeout("$(this).parent('li').remove();",300);
	});

  // Updating drop down event handler
  $('#vehicle_route').change(function() {
    $('.pushes ul').children().each(function() {
      $(this).remove();
    });

    map = define_map(41.8379815299556,-87.6218794336859);
    vehicle_route = $('#vehicle_route').val();
    socket = setup_socket( $('#key').val(), 'vehicle_route_' + vehicle_route );

    update_ticker(vehicle_route);
    $('#stop_button').attr('style', 'display: block');
  });
});
