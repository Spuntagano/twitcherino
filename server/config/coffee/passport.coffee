mongoose = require('mongoose')
passport = require('passport')
LocalStrategy = require('passport-local').Strategy
TwitchtvStrategy = require('../../node_modules/passport-twitchtv').Strategy;
User = mongoose.model('User')

module.exports = (config) ->
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
		clientID: config.TWITCHTV_CLIENT_ID
		clientSecret: config.TWITCHTV_CLIENT_SECRET
		callbackURL: config.TWITCHTV_CALLBACK
		scope: "user_read"
		passReqToCallback : true
	}
	(req, accessToken, refreshToken, profile, done) ->

		if (req.user)
			User.findOne({username: req.user.username}).exec( (err, user) -> 
				User.findOne({twitchtvId: profile.id}).exec( (err, user) ->
					if (!user)
						User.update({username: req.user.username}, {twitchtvId: profile.id, twitchtvUsername: profile.username}, (err, user) ->
							done(null, req.user) #connect account // you dont log in a created user here, you just add the twitchid to the existing account
							console.log('g')
						)
					else
						done(null, false, {message: 'Your twitch account is already linked to another account'}) #account linked to another account
						console.log('f')
				)
			)
		else
			User.findOne({twitchtvId: profile.id}).exec( (err, user) ->
				if (user)
					done(null, user) #log in user
					console.log('e')
				else if (!profile.email)
					done(null, false, {message: 'Please validate your twitch email'}) #twitch email not validated
					console.log('d')
				else if (!user)
					User.findOne({username: profile.email}).exec( (err, user) ->
						if (!user)
							User.create({ twitchtvId: profile.id, username: profile.email, twitchtvUsername: profile.username }, (err, user) ->
								done(null, user) #create account and log in
								console.log('c')
							)
						else
							done(null, false, {message: 'A user already exist with this twitch account email'}) #a user already exist with the twitch account email
							console.log('b')
					)
				else
					done(null, false, {message: 'Something went wrong'}) #error
					console.log('a')
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
