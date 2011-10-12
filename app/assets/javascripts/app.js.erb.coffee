

class window.App
	initialize: ->
		window.map = new window.Map()
		window.searcher = new window.Searcher()
		window.searcher.render()
		window.activities.showInMap()
