mongoose = require('mongoose')
passport = require('passport')
LocalStrategy = require('passport-local').Strategy
User = mongoose.model('User')

module.exports = ->
	passport.use(new LocalStrategy(
		{
			usernameField: 'username',
			passwordField: 'password'
		}
		(username, password, done) ->
			User.findOne({username: username}).exec( (err, user) ->
				if (user && user.authenticate(password))
					done(null, user)
				else
					done(null, false)
			)
		)
	)

	passport.serializeUser( (user, done) ->
		if (user)
			done(null, user._id)

	)

	passport.deserializeUser( (id, done) ->
		User.findOne({_id: id}).exec( (err, user) ->
			if (user)
				done(null, user)
			else
				done(null, false)
		)
	)