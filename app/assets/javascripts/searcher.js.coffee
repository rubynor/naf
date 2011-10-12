window.Searcher =
	initialize: ->
		$("#search_field").bind("keyup", @keyUp)

	keyUp: (e) ->
		e.preventDefault()
		clearTimeout $.data(@, 'timer')
		if e.keyCode == 13
		  @search(true)
		else
			$(@).data('timer', setTimeout(@search, 500))
	
	search: (forced=false) ->
		console.log "search performed..."
		
$ ->
	window.Searcher.initialize()