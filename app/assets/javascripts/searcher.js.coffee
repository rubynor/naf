class window.Searcher extends Backbone.View
	initialize: ->
		@template = Handlebars.compile $("#searchbar_tmpl").html()
		
	render: ->
		$(@el).html @template()
		$("#searchbar").append($(@el))
		@
	
	events: 
		"keyup #search_field":"keyUp"	
		
	keyUp: (e) ->
		e.preventDefault()
		clearTimeout $.data(@, 'timer')
		if e.keyCode == 13
		 	@search(true)
		else
			$(@).data('timer', setTimeout(@search, 500))
	
	search: (forced) ->
		return if (!forced && window.searcher.searchString().length < 3)
		window.searcher.showLoader()
	
	searchString: ->
		$(@el).find("#search_field").val()
	
	showLoader: ->
		$(@el).find("#loading_container").show()
		
$ ->
	
	window.searcher = new window.Searcher()
	window.searcher.render()