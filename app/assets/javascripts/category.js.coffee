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

	icon: ->
		name = @get("name")
		name = name.toLowerCase()
		if name.indexOf("bane") > -1
			console.log "fuck"
			return "baner"	
		else if name.indexOf("NAF motorsport") > -1
			return "motorsport"	
		else if name.indexOf("Trafikksenter") > -1
			return "naf-senter"
		else if name.indexOf("NAF MC") > -1
			return "mc"
		else if name.indexOf("avdeling") > -1
			return "lokalavdeling"
		else					
			return null
		
class window.Categories extends Backbone.Collection
	model: window.Category
	
	render: ->
		_.each @models, (model) ->
			model.view.render()