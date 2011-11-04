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
    gmap.countActivities()

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
    });