class window.CategoryView extends Backbone.View
	tagName: "li"
	
	initialize: (model) ->
		@model = model
		@template = Handlebars.compile $("#category_tmpl").html()
		
	render: ->
		$(@el).html @template(@model.toJSON())
		$("#category_list").append $(@el)
		@
	events: 
		"click":"toggle"	

	toggle: (e) ->
		category_id = $(e.currentTarget).attr("_id")
		window.searcher.toggleCategory(category_id)
		
class window.Category extends Backbone.Model
	initialize: ->
		@view = new window.CategoryView(@)
		
class window.Categories extends Backbone.Collection
	model: window.Category
	
	render: ->
		_.each @models, (model) ->
			model.view.render()