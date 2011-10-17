class window.Map extends Backbone.View
	
	mapOptions: ->
		{zoom:10, center: new google.maps.LatLng(59.9, 10.7), mapTypeId: google.maps.MapTypeId.ROADMAP}

	initialize: ->
		@selector = $("#map_canvas")[0]
		@map = new google.maps.Map(@selector, @mapOptions());
		@bounds = new google.maps.LatLngBounds();
		@markers = new Array()
		
	render: ->
	
	placeActivity: (activity) ->
		location = activity.get("location")
		point = new google.maps.LatLng(parseFloat(location.latitude), parseFloat(location.longitude))
		@bounds.extend(point)
		marker = new google.maps.Marker({position: point,map: window.map.map})
		marker.setIcon("assets/icons/#{@iconByCategory(activity.get("category_id"))}.png")
		@markers.push marker
		@map.fitBounds(@bounds)
		google.maps.event.addListener marker, 'click', () ->
			activity.view.render()
		google.maps.event.addListener marker, 'mouseover', () ->
			activity.view.showInfo()
			
	clear: ->
		_.each @markers, (marker) ->
			marker.setMap(null)
	
	iconByCategory: (category_id) -> 
		category = window.categories.get(category_id)
		return category.icon()