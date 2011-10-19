class window.TargetView extends Backbone.View
	initialize: (model) ->
		@model = model
		@template = Handlebars.compile $("#target_tmpl").html()
	render: ->
		$(@el).html @template(@model.toJSON())
		$("#target_list").append $(@el)
		@
	events: 
		"click":"toggle"	

	toggle: (e) ->
		target_name = $(e.currentTarget).attr("name")
		window.searcher.toggleTargets()
			
class window.Target extends Backbone.Model
	initialize: (name) ->
		@view = new window.TargetView(@)

class window.Targets extends Backbone.Collection
	model: window.Target
	render: ->
		_.each @models, (model) ->
			model.view.render()