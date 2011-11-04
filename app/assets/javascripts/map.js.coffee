class window.Map extends Backbone.View

  mapOptions: ->
    {zoom:1, center: new google.maps.LatLng(59.9, 10.7), mapTypeId: google.maps.MapTypeId.ROADMAP}

  initialize: ->
    @selector = $("#map_canvas")[0]
    @map = new google.maps.Map(@selector, @mapOptions());
    @bounds = new google.maps.LatLngBounds();
    @markers = new Array()
  render: ->

  placeActivity: (activity) ->
    location = activity.get("location")
    summary = activity.get("summary")
    point = new google.maps.LatLng(parseFloat(location.latitude), parseFloat(location.longitude))
    @bounds.extend(point)
    marker = new google.maps.Marker({position: point,map: window.map.map, title: summary})
    icon_name = @iconByCategory(activity.get("category_id"))
    marker.setIcon("assets/icons/#{icon_name}.png") if icon_name
    @markers.push marker
    @map.fitBounds(@bounds)

    google.maps.event.addListener marker, 'click', () ->
      activity.view.render()

  clear: ->
    _.each @markers, (marker) ->
      marker.setMap(null)

  iconByCategory: (category_id) ->
    category = window.categories.get(category_id)
    return category.icon()