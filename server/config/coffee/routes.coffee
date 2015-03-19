auth = require('./auth')

module.exports = (app) ->
	app.get('/partials/:partialPath', (req, res) ->
		res.render('partials/' + req.params.partialPath)
	)

	app.post('/login', auth.authenticate)

	app.get('*', (req, res) ->
		res.render('index')
	)