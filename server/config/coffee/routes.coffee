auth = require('./auth')
mongoose = require('mongoose')
User = mongoose.model('User')

module.exports = (app) ->

	app.get('/api/users', auth.requiresRole('admin')
	(req, res) ->
		User.find({}).exec( (err, collection) ->
			res.send(collection)
		)
	)

	app.get('/partials/:partialPath', (req, res) ->
		res.render('partials/' + req.params.partialPath)
	)

	app.post('/login', auth.authenticate)

	app.post('/logout', (req, res) ->
		req.logout()
		res.end()
	)

	app.get('*', (req, res) ->
		res.render('index', {
			bootstrappedUser: req.user
		})
	)