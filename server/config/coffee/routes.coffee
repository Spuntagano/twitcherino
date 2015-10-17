auth = require('./auth')
follow = require('../controllers/follow')
users = require('../controllers/users')
mongoose = require('mongoose')
passport = require('passport')
User = mongoose.model('User')
bootstrappedUser = require('../utilities/bootstrappedUser')

module.exports = (app, config) ->

	#app.get('/api/users', auth.requiresRole('admin'), users.getUsers)

	#app.post('/api/user', users.createUser)
	app.put('/api/user', users.updateUser)
	app.delete('/api/user/:username', users.deleteUser)
	app.get('/api/user/:username', users.getUser)

	app.delete('/api/user/twitch/:username', users.disconnectTwitch)
	app.delete('/api/user/hitbox/:username', users.disconnectHitbox)

	app.get('/partials/*', (req, res) ->
		res.render('../../public/app/' + req.params[0])
	)

	#app.post('/login', auth.authenticate)

	app.post('/hitbox-auth', auth.hitboxAuth)

	app.post('/logout', (req, res) ->
		req.logout()
		res.send({success: true})
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
			errorMessage: errorMessage
			#env: config.ENV
			bootstrappedUser: bootstrappedUser.bootstrappedUser(req.user)
		})
	)

	app.get('/profile', (req, res) ->
		res.render('index', {
			#env: config.ENV
			bootstrappedUser: bootstrappedUser.bootstrappedUser(req.user)
		})
	)

	#app.post('/follow', follow.addFollow)
	#app.post('/unfollow', follow.removeFollow)

	#app.post('/importfollows', follow.importFollows)

	app.all('/api/*', (req, res) ->
		res.send(404)
	)

	app.get('*', (req, res) ->
		res.render('index', {
			#env: config.ENV
			bootstrappedUser: bootstrappedUser.bootstrappedUser(req.user)
		})
	)

