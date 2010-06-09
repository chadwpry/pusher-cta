var map = null;
var socket = null;

function setup_socket(api_key, channel) {
  socket = new Pusher(api_key, channel);

  socket.bind('location_move', function(data) {
		// Create a new item
    var elm = '<li style="display:none;" class="new"><p class="time">'+data.vehicle.timestamp+'</p><div class="close"></div><p class="title">Vehicle: '+data.vehicle.id+'</p><p class="location"><a href="http://maps.google.com/maps?hl=en&amp;q='+data.vehicle.lat+','+data.vehicle.lon+'" target="_blank">'+data.vehicle.lat+','+data.vehicle.lon+'</a></p><p class="content">'+data.vehicle.destination+'</p></li>';

    var marker = new google.maps.Marker({
      position: new google.maps.LatLng(data.vehicle.lat, data.vehicle.lon),
      map: map,
      title:"Hello World!"
    }); 
    
    // Add the item to the list
    $('.pushes ul').prepend(elm);
    
    // Slide the item in
    $('.new').slideDown();
    $('.new').removeClass('new');
  });
}

function request(url) {
  $.get(url, { }, function(data) {
    if (data == 0) {
      
    } else {
      alert('There was an error pushing your event!');
    }
  });
}

function define_map() {
  var latlng = new google.maps.LatLng(41.8379815299556,-87.6218794336859);
  var myOptions = {
    zoom: 10,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  return new google.maps.Map(document.getElementById("map_canvas"), myOptions);
}

$(document).ready(function() {
  map = define_map();

  $('#eventButton').click(function() {
    request('/vehicle_routes/' + $('#vehicle_route').val() + '/ping.js')
  })

  $('#vehicle_route').change(function() {
    $('#eventButton').attr('style', 'display:block');

    $('.pushes ul').children().each(function() {
      $(this).remove();
    })

    var key = $('#key').val();
    var vehicle_route = $('#vehicle_route').val();

    socket = setup_socket(key, 'vehicle_route_' + vehicle_route);
    map = define_map();
		
		if(vehicle_route == '') {
			alert('Please enter a vehicle route!');
		} else {
			// Send a GET request to the file /vehicle_routes/ping carrying the vehicle route
      request('/vehicle_routes/' + vehicle_route + '/ping.js')
		}
	});
	
	$('.close').live('click',function() {
	  $(this).parent('li').slideUp();
		setTimeout("$(this).parent('li').remove();",300);
	});

});
