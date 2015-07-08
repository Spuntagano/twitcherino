auth = require('./auth')
follow = require('./follow')
users = require('../controllers/users')
mongoose = require('mongoose')
passport = require('passport')
User = mongoose.model('User')

module.exports = (app) ->

	app.get('/api/users', auth.requiresRole('admin'), users.getUsers)
	app.post('/api/users', users.createUser)
	app.put('/api/users', users.updateUser)

	app.get('/api/user', users.getUser)

	app.get('/partials/*', (req, res) ->
		res.render('../../public/app/' + req.params[0])
	)

	app.post('/login', auth.authenticate)

	app.post('/logout', (req, res) ->
		req.logout()
		res.end()
	)

	app.get('/auth/twitchtv', passport.authenticate('twitchtv'))

	app.get('/auth/twitchtv/callback', 
		passport.authenticate('twitchtv', { failureRedirect: '/' }),
		(req, res) ->
			res.redirect('/')
	)

	app.post('/follow', follow.addFollow)
	app.post('/unfollow', follow.removeFollow)

	app.post('/importtwitchfollows', follow.importTwitchFollows)

	app.all('/api/*', (req, res) ->
		console.log(req)
		res.send(404)
	)

	app.get('*', (req, res) ->
		res.render('index', {
			bootstrappedUser: req.user
		})
	)