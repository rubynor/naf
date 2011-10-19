class window.RegionView extends Backbone.View
	tagName: "option"
	
	initialize: (model) ->
		@model = model
	
	render: ->
		$(@el).attr('value', @model.get('_id')).html(@model.get('name'))
		$("#region_select").append $(@el)
		@

class window.Region extends Backbone.Model
	initialize: ->
		@view = new window.RegionView(@)
		
class window.Regions extends Backbone.Collection
	model: window.Region
	render: ->
		_.each @models, (model) ->
			model.view.render()
	setRegion: (e) ->
		e.preventDefault()
		target = $(e.currentTarget)


	