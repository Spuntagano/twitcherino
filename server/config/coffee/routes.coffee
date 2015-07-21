auth = require('./auth')
follow = require('./follow')
users = require('../controllers/users')
mongoose = require('mongoose')
passport = require('passport')
User = mongoose.model('User')

module.exports = (app, config) ->

	app.get('/api/users', auth.requiresRole('admin'), users.getUsers)
	#app.post('/api/users', users.createUser) local registration
	app.put('/api/users', users.updateUser)

	#app.get('/api/user', users.getUser)

	app.get('/partials/*', (req, res) ->
		res.render('../../public/app/' + req.params[0])
	)

	#app.post('/login', auth.authenticate) local registration

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
			#urls: urlFunc(config)
			bootstrappedUser: bootstrappedUserFunc(req)
		})
	)

	app.get('/profile', (req, res) ->
		res.render('index', {
			#urls: urlFunc(config)
			bootstrappedUser: bootstrappedUserFunc(req)
		})
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
			#urls: urlFunc(config)
			bootstrappedUser: bootstrappedUserFunc(req)
		})
	)

###
urlFunc = (config) ->
	urls =
		httpBaseUrl: config.HTTP_BASE_URL
		httpsBaseUrl: config.HTTPS_BASE_URL
###

bootstrappedUserFunc = (req) ->
	bootstrappedUser = false
	if (req.user)
		bootstrappedUser =
			_id: req.user._id
			username: req.user.username
			firstname: req.user.firstName
			lastName: req.user.lastName
			twitchtvId: req.user.twitchtvId
			twitchtvUsername: req.user.twitchtvUsername
			hitboxFollows: req.user.hitboxFollows
			twitchFollows: req.user.twitchFollows
			azubuFollows: req.user.azubuFollows
			roles: req.user.roles

