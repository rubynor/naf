class window.Map extends Backbone.View

  mapOptions: ->
    {zoom: 12, center: new google.maps.LatLng(59.9, 10.7), mapTypeId: google.maps.MapTypeId.ROADMAP} #ROADMAP, TERRAIN}

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
    marker = new google.maps.Marker({activity_id: activity.get("_id"), position: point,map: window.map.map, title: summary})
    icon_name = @iconByCategory(activity.get("category_id"))
    marker.setIcon("assets/icons/#{icon_name}.png") if icon_name
    @markers.push marker
    @map.fitBounds(@bounds)

    google.maps.event.addListener marker, 'click', () ->
      activity.view.render()

  clear: ->
    _.each @markers, (marker) ->
      marker.setMap(null)
    @markers.length = 0
    @markerCluster.clearMarkers()

  clusterActivities: () ->
    mcOptions = {gridSize: 8, maxZoom: 10} #maxZoom is the zoom level where the MarkerClusterer disappear.

    @markerCluster = new MarkerClusterer(@map, @markers, mcOptions) #, @markers
    listZoom = 5
    google.maps.event.addListener @markerCluster, 'clusterclick', (cluster) ->
      #console.log("cluster onclick event on cluster, markers: #{cluster.getMarkers().length}, zoom: #{cluster.getMap().zoom}, listZoom: #{listZoom}")
      #console.log("cluster zoom on click #{console.dir(cluster)}")
      #console.log("is zoom on click #{cluster.getMarkerClusterer().isZoomOnClick()}")
      if (cluster.getMap().zoom >= listZoom && cluster.getMarkers().length > 1)
        new window.ActivityClusterView(cluster).render()

  iconByCategory: (category_id) ->
    category = window.categories.get(category_id)
    return category.icon()