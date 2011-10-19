class window.Searcher extends Backbone.View
	initialize: ->
		@template = Handlebars.compile $("#searchbar_tmpl").html()
		@category_criteria = new Array()
		@target_criteria = new Array()
		@region_id = ""
		
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
		options = {text: window.searcher.searchString(), limit:2000, page:1}
		options["category_ids"] = @category_criteria unless window.searcher.category_criteria.length == 0
		options["targets"] = @target_criteria unless window.searcher.target_criteria.length == 0
		options["region_id"] = @region_id unless @region_id == ""
		window.activities.search(options)
	
	searchString: ->
		$(@el).find("#search_field").val()
	
	showLoader: ->
		$(@el).find("#loading_container").show()

	hideLoader: ->
		$(@el).find("#loading_container").hide()
	
	setStatus: (status) ->
		$(@el).find("#status").html(status)
	
	setRegion: (id) ->
		@region_id = id
		@search(true)
		
	toggleCategories: (id) ->
		@category_criteria = new Array()
		that = @
		_.each $(".category_box:checked"), (check_box) ->
			if $(check_box).val() != undefined
				that.category_criteria.push $(check_box).attr("_id")
		@search(true)

	toggleTargets: (name) ->
		@target_criteria = new Array()
		that = @
		_.each $(".target_box:checked"), (check_box) ->
			if $(check_box).val() != undefined
				that.target_criteria.push $(check_box).attr("name")
		@search(true)