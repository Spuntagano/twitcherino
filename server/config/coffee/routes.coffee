module.exports = (app) ->
	app.get('/partials/:partialPath', (req, res) ->
		res.render('partials/' + req.params.partialPath)
	)

	app.get('*', (req, res) ->
		res.render('index')
	)