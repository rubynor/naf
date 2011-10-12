class window.Searcher extends Backbone.View
	initialize: ->
		@template = Handlebars.compile $("#searchbar_tmpl").html()
		@category_criteria = new Array()
		@target_criteria = new Array()
		
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
		options = {text: window.searcher.searchString()}
		options["category_ids"] = @category_criteria unless window.searcher.category_criteria.length == 0
		options["targets"] = @target_criteria unless window.searcher.target_criteria.length == 0
		window.activities.search(options)
	
	searchString: ->
		$(@el).find("#search_field").val()
	
	showLoader: ->
		$(@el).find("#loading_container").show()

	hideLoader: ->
		$(@el).find("#loading_container").hide()
	
	setStatus: (status) ->
		$(@el).find("#status").html(status)
	
	toggleCategory: (id) ->
		if _.indexOf(@category_criteria, id) > -1
			@category_criteria = _.without(@category_criteria, id)
		else
			@category_criteria.push(id)

		@search(true)

	toggleTarget: (name) ->
		if _.indexOf(@target_criteria, name) > -1
			@target_criteria = _.without(@target_criteria, name)
		else
			@target_criteria.push(name)

		@search(true)