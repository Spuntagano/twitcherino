mongoose = require('mongoose')
passport = require('passport')
LocalStrategy = require('passport-local').Strategy
TwitchtvStrategy = require('../../node_modules/passport-twitchtv').Strategy;
User = mongoose.model('User')

TWITCHTV_CLIENT_ID = '3453206b4coczmz7878sejh31g7221j'
TWITCHTV_CLIENT_SECRET = '1cst8e1swycb981xzh0hy589yqikmk2'

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

	passport.use(new TwitchtvStrategy({
		clientID: TWITCHTV_CLIENT_ID
		clientSecret: TWITCHTV_CLIENT_SECRET
		callbackURL: "/auth/twitchtv/callback"
		scope: "user_read"
		passReqToCallback : true
	}
	(req, accessToken, refreshToken, profile, done) ->

		console.log(profile)

		if (req.user)
			User.findOne({username: req.user.username}).exec( (err, user) -> 
				User.findOne({twitchtvId: profile.id}).exec( (err, user) ->
					if (!user)
						User.update({username: req.user.username}, {twitchtvId: profile.id}, (err, user) ->
							done(null, false) #connect account
						)
					else
						done(null, false) #account linked to another account
				)
			)
		else
			User.findOne({twitchtvId: profile.id}).exec( (err, user) ->
				if (user)
					done(null, user) #log in user
				else if (!profile.email)
					done(null, false) #twitch email not validated
				else if (!user)
					User.findOne({username: profile.email}).exec( (err, user) ->
						if (!user)
							User.create({ twitchtvId: profile.id, username: profile.email }, (err, user) ->
								done(null, user) #create account and log in
							)
						else
							done(null, false) #a user already exist with the twitch account email
					)
				else
					done(null, false) #error
			)
		)
	)

	passport.serializeUser( (user, done) ->
		if (user)
			done(null, user);
	)

	passport.deserializeUser( (obj, done) ->
		if (obj)
			done(null, obj)
		else
			done(null, false)
	)
