class window.Searcher extends Backbone.View
	initialize: ->
		@template = Handlebars.compile $("#searchbar_tmpl").html()
		@category_criteria = new Array()
		@target_criteria = new Array()
		@region_id = ""
		@start_date = null
		@end_date = null
		
	render: ->
		$(@el).html @template()
		$("#searchbar_inner").append($(@el))
		@
	
	events: 
		"keyup #search_field":"keyUp"	
		"click #clear_dates":"clearDates"
		"keyup #dtstart":"keyUpStartDate"
		"keyup #dtend":"keyUpEndDate"
		
	keyUp: (e) ->
		e.preventDefault()
		clearTimeout $.data(@, 'timer')
		if e.keyCode == 13
		 	@search(true)
		else
			$(@).data('timer', setTimeout(@search, 500))
	
	search: (forced) ->
		return if (!forced && window.searcher.searchString().length < 3)
		params = {}
		params["text"] = window.searcher.searchString()
		params["limit"] = "2000"
		params["page"] = 1
		params["category_ids"] = window.searcher.category_criteria unless window.searcher.category_criteria.length == 0
		params["targets"] = window.searcher.target_criteria unless window.searcher.target_criteria.length == 0
		params["region_id"] = @region_id unless @region_id == ""
		params["dtstart"] = @start_date if @start_date
		params["dtend"] = @end_date if @end_date
		
		window.activities.search(params)
	
	searchString: ->
		$(@el).find("#search_field").val()
	
	showLoader: ->
		$(@el).find("#loading_container").show()

	hideLoader: ->
		$(@el).find("#loading_container").hide()
	
	setStatus: (status) ->
		$(@el).find("#status").html(status)
	
	isDate: (str) ->
		str.match(/^(\d{1,2}).(\d{1,2}).(\d{4})$/);
		
	keyUpStartDate: (e) ->
		val = $(@el).find("#dtstart").val()
		if val== "" || @isDate(val)
			@setStartDate(val)
	
	keyUpEndDate: (e) ->
		val = $(@el).find("#dtend").val()
		if val=="" || @isDate(val)
			@setEndDate(val)
				
	setStartDate: (date) ->
		@start_date = date
		@search(true)
		
	setEndDate: (date) ->
		@end_date = date
		@search(true)
	
	clearDates: (e) ->
		e.preventDefault()	
		$(@el).find("#dtstart").val("")
		$(@el).find("#dtend").val("")
		@search(true)
		
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