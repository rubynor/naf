class window.Modal extends Backbone.View


class window.ActivityView extends Backbone.View

  initialize: (model) ->
    @model = model
    @template = Handlebars.compile $("#activity_tmpl").html()
    @viewCount = 0 #used for making tabs show everytime

  render: ->
    $(@el).html @template({activity: @model.toJSON(), uniq_id: "#{@model.get("_id")}_#{Math.floor(Math.random()*1001)}"})
    $(@el).find(".modal").modal({backdrop: true}) #used when clicking on a marker
    $(@el).find(".tabs").tabs()
    @showModal()
    @

  showModal: ->
    $(@el).find(".modal").modal('show')

class window.ActivityClusterView extends Backbone.View
  initialize: (cluster) ->
    @cluster = cluster
    @template = Handlebars.compile $("#activity_list_tmpl").html()

  render: ->
    $(@el).html @template()
    that = @
    table = $(@el).find("table")
    _.each that.cluster.getMarkers(), (marker) ->
      table.append "<tr><td><a href='#' class='cluster_list_item' id='#{marker.activity_id}'>#{marker.title}</a></td></tr>"

    $(@el).find(".modal").modal({backdrop: true})

    #we need to hook into the show-event of the modal in order to create new event-listeners inside it
    $(@el).find(".modal").bind 'show', ->
      _.each $(@).find("a.cluster_list_item"), (link) ->
        $(link).bind 'click', (e) ->
          e.preventDefault()
          that.triggerActivity($(e.currentTarget).attr("id"))

    $(@el).find(".modal").modal('show')
    @

  triggerActivity: (id) ->
    $(@el).remove()
    activity = window.activities.get(id)
    activity.view.render()

class window.Activity extends Backbone.Model
  url: "/activities"
  initialize: ->
    @view = new window.ActivityView(@)

class window.Activities extends Backbone.Collection
  model: window.Activity

  showInMap: ->
    gmap = window.map
    _.each @models, (activity) ->
      gmap.placeActivity(activity)
    gmap.clusterActivities()

  search: (params) ->
    window.searcher.showLoader()
    $.ajax({
      url: "/activities/search",
      type: "GET",
      data: params,
      success: (data) ->
        window.searcher.hideLoader()
        window.searcher.setStatus("#{data.activities.length} treff")
        #should flash when 0 treff
        window.activities = new window.Activities()
        window.map.clear()
        _.each data.activities, (activity) ->
           activity = new window.Activity(activity)
           window.activities.add(activity)
        window.activities.showInMap()
    })

