class window.ActivityView extends Backbone.View
	initialize: (model) ->
		@model = model
		@template = Handlebars.compile $("#activity_tmpl").html()
		@info_template = Handlebars.compile $("#activity_info_tmpl").html()
		
	render: ->
		$(@el).html @template(@model.toJSON())
		$(@el).find("#modal").modal({show: true, backdrop: true})
		@
	
	showInfo: ->
		$("#popover").html @info_template(@model.toJSON())
		$("#popover").popover({show: true})
		console.log "Pung"
			
class window.Activity extends Backbone.Model
	url: "/activities"
	initialize: ->
		@view = new window.ActivityView(@)
		
class window.Activities extends Backbone.Collection
	model: window.Activity
	
	showInMap: ->
		_.each @models, (activity) ->
			window.map.placeActivity(activity)
			
	search: (params) ->
		window.searcher.showLoader()
		$.ajax({
			url: "/activities/search",
			type: "GET",
			data: params,
			success: (data) ->
				window.searcher.hideLoader()
				if data.activities.length == 0
					window.searcher.setStatus("0 treff")
				else
					window.searcher.setStatus("#{data.activities.length} treff")
					window.activities = new window.Activities()
					window.map.clear()
					_.each data.activities, (activity) ->
						activity = new window.Activity(activity)
						window.activities.add(activity)
					window.activities.showInMap()	
		});