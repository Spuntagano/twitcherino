passport = require('passport')

exports.authenticate = (req, res, next) ->
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
	console.log(req.session.passport.user)
	auth(req, res, next)