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
		window.searcher.toggleCategories()
		
class window.Category extends Backbone.Model
	initialize: ->
		@view = new window.CategoryView(@)

	icon: ->
		name = @get("name")
		name = name.toLowerCase()
		if name.indexOf("kurs") > -1
			return "skole_25"	
		if name.indexOf("konkurranser") > -1
			return "aksjoner2_25"
		else if name.indexOf("motorsport") > -1
			return "motorsport"	
		else if name.indexOf("trafikksenter") > -1
			return "naf-senter"
		else if name.indexOf("NAF MC") > -1
			return "mc"
		else if name.indexOf("politisk") > -1
			return "politisk1_25"	
		else if name.indexOf("foredrag") > -1
			return "seminar_25"
		else					
			return null
		
class window.Categories extends Backbone.Collection
	model: window.Category
	
	render: ->
		_.each @models, (model) ->
			model.view.render()