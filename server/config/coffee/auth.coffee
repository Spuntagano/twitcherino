passport = require('passport')

exports.authenticate = (req, res, next) ->

	valid = true

	if(!req.body.username || !req.body.username)
		valid = false
		res.status(400)
		res.send({'Invalid parameters'})

	if (valid)
		req.body.username = req.body.username.toLowerCase()
		auth = passport.authenticate('local', (err, user) ->
			if (err)
				next(err)
			if(!user)
				res.send({success: false})
			req.logIn(user, (err) ->
				if (err)
					next(err)
				res.send({success: true, user: user})
			)
		)
		auth(req, res, next)

exports.requireApiLogin = (req, res, next) ->
	if (!req.isAuthenticated())
		res.status(403)
		res.end()
	else
		next()

exports.requiresRole = (role) ->
	(req, res, next) ->
		if (!req.isAuthenticated() || req.user.roles.indexOf(role) == -1)
			res.status(403)
			res.end()
		else
			next()