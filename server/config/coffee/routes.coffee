auth = require('./auth')
follow = require('./follow')
users = require('../controllers/users')
mongoose = require('mongoose')
passport = require('passport')
User = mongoose.model('User')

module.exports = (app, config) ->

	app.get('/api/users', auth.requiresRole('admin'), users.getUsers)

	app.post('/api/user', users.createUser)
	app.put('/api/user', users.updateUser)
	app.delete('/api/user/:username', users.deleteUser)
	app.get('/api/user', users.getUser)

	app.delete('/api/user/twitch/:username', users.disconnectTwitch)

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
		passport.authenticate('twitchtv', { failureRedirect: '/login', failureFlash: true }),
		(req, res) ->
			res.redirect('/profile')
	)

	app.get('/login', (req, res) ->
		errorMessage = req.flash('error')
		res.render('index', {
			errorMessage: errorMessage,
			env: config.ENV
			bootstrappedUser: bootstrappedUserFunc(req)
		})
	)

	app.get('/profile', (req, res) ->
		res.render('index', {
			env: config.ENV
			bootstrappedUser: bootstrappedUserFunc(req)
		})
	)

	app.post('/follow', follow.addFollow)
	app.post('/unfollow', follow.removeFollow)

	app.post('/importtwitchfollows', follow.importTwitchFollows)
	app.post('/importhitboxfollows', follow.importHitboxFollows)

	app.all('/api/*', (req, res) ->
		res.send(404)
	)

	app.get('*', (req, res) ->
		res.render('index', {
			env: config.ENV
			bootstrappedUser: bootstrappedUserFunc(req)
		})
	)

bootstrappedUserFunc = (req) ->
	bootstrappedUser = false
	has_pw = false
	if (req.user && req.user.hashed_pwd)
		has_pw = true
	if (req.user)
		bootstrappedUser =
			username: req.user.username
			firstname: req.user.firstName
			lastName: req.user.lastName
			twitchtvUsername: req.user.twitchtvUsername
			hitboxFollows: req.user.hitboxFollows
			twitchFollows: req.user.twitchFollows
			azubuFollows: req.user.azubuFollows
			roles: req.user.roles
			has_pw: has_pw

