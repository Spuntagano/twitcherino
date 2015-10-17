passport = require('passport')
mongoose = require('mongoose')
User = mongoose.model('User')

###
exports.authenticate = (req, res, next) ->

	valid = true

	if(!req.body.username || !req.body.password)
		valid = false
		res.send({reason: 'Invalid parameters'})

	if (valid)
		req.body.username = req.body.username.toLowerCase()
		passport.authenticate('local', (err, user) ->
			if (err)
				next(err)
			if(!user)
				res.send({reason: 'Invalid login'})
			req.logIn(user, (err) ->
				if (err)
					next(err)
				res.send({success: true})
			)
		)(req, res, next)
###
exports.hitboxAuth = (req, res, next) ->
	if (req.user)
		User.findOne({username: req.user.username}).exec( (err, user) ->
			if (user)
				User.update({username: user.username}, {hitboxtvUsername: req.body.hitboxtvUsername, hitboxtvAccessToken: req.body.hitboxtvAccessToken, hitboxtvId: req.body.hitboxtvId}, (err) ->
					res.send({success: true})
				)
			else
				res.send({reason: 'Invalid username'})
		)
	else
		res.send({reason: 'Not logged in'})


exports.requireApiLogin = (req, res, next) ->
	if (!req.isAuthenticated())
		res.status(403)
	else
		next()

exports.requiresRole = (role) ->
	(req, res, next) ->
		if (!req.isAuthenticated() || req.user.roles.indexOf(role) == -1)
			res.status(403)
		else
			next()