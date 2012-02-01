class window.Map extends Backbone.View

  mapOptions: ->
    {zoom: 5, minzoom: 2, maxZoom: 18, center: new google.maps.LatLng(65.0, 13.0), mapTypeId: google.maps.MapTypeId.ROADMAP} #ROADMAP, TERRAIN}

  initialize: ->
    @selector = $("#map_canvas")[0]
    @map = new google.maps.Map(@selector, @mapOptions());
    @bounds = new google.maps.LatLngBounds();
    @markers = new Array()

  render: ->

  placeActivity: (activity) ->
#    console.log "placeActivity"
    location = activity.get("location")
    return unless location
    summary = activity.get("summary")

    point = new google.maps.LatLng(parseFloat(location.latitude), parseFloat(location.longitude))
    @bounds.extend(point)
    markershape = {type: 'circle', coords: [location.latitude, location.longitude, 500]}
    #shape: markershape
    marker = new google.maps.Marker({activity_id: activity.get("_id"), position: point,  map: window.map.map, title: summary})
    icon_name = @iconByCategory(activity.get("category_id"))
    marker.setIcon("assets/icons/#{icon_name}.png") if icon_name
    @markers.push marker
    #@map.fitBounds(@bounds)

    google.maps.event.addListener marker, 'click', () ->
      activity.view.render()

  clear: ->
    _.each @markers, (marker) ->
      marker.setMap(null)
#    console.log "clearing markers and map"
    @markers.length = 0
    @markerCluster.clearMarkers()

  clusterActivities: () ->
    mcOptions = {gridSize: 25, maxZoom: 50} #maxZoom is the zoom level where the MarkerClusterer disappear.
#    console.log "creating clusters"
    @markerCluster = new MarkerClusterer(@map, @markers, mcOptions) #, @markers
    listZoom = 10
    google.maps.event.addListener @markerCluster, 'clusterclick', (cluster) ->
      #console.log("cluster onclick event on cluster, markers: #{cluster.getMarkers().length}, zoom: #{cluster.getMap().zoom}, listZoom: #{listZoom}")
#      console.log "cluster zoom on click #{cluster.getMap().zoom}"
      #console.log("is zoom on click #{cluster.getMarkerClusterer().isZoomOnClick()}")
      if (cluster.getMap().zoom >= listZoom && cluster.getMarkers().length > 1)
        new window.ActivityClusterView(cluster).render()

  iconByCategory: (category_id) ->
    category = window.categories.get(category_id)
    return category.icon()