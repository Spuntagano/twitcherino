User = require('mongoose').model('User')
encrypt = require('../utilities/encryption')
validator = require('validator')

exports.getUser = (req, res) ->

	user = new User(req.user)
	userData = req.params
	valid = true

	if (!req.user)
		valid = false
		res.status(400)
		res.send(reason: 'Not logged in')
	else
		if(!userData.username)
			valid = false
			res.status(400)
			res.send(reason: 'Invalid params')

		if(user.username != userData.username && !user.hasRole('admin'))
			valid = false
			res.status(403)
			res.send(reason: 'Unauthaurized')

		if (valid)
			User.find(username: userData.username, (err, collection) ->
				has_pw = false
				if (collection[0].hashed_pwd)
					has_pw = true
				res.send(
					username: collection[0].username
					twitchtvUsername: collection[0].twitchtvUsername
					hitboxFollows: collection[0].hitboxFollows
					twitchFollows: collection[0].twitchFollows
					azubuFollows: collection[0].azubuFollows
					roles: collection[0].roles
					has_pw: has_pw
				)
			)

exports.getUsers = (req, res) ->
	User.find({}).exec( (err, collection) ->
		res.send(collection)
	)
	
exports.createUser = (req, res, next) ->

	userData = req.body
	valid = true

	if (!userData.username || !userData.password || !validator.isEmail(userData.username) || !validator.isLength(userData.username, 1, 50) || !validator.isLength(userData.password, 6, 20))
		valid = false
		res.status(400)
		res.send({reason: 'Invalid parameters'})

	if (valid)
		userData.salt = encrypt.createSalt()
		userData.hashed_pwd =  encrypt.hashPwd(userData.salt, userData.password)
		User.create(userData, (err, user) ->
			if (err)
				console.log(err)
				if (err.toString().indexOf('E11000') > -1)
					err = new Error('Duplicate Username')
				res.status(400)
				res.send({reason: err.toString()})
			req.logIn(user, (err) ->
				if (err)
					next(err)
				res.send({success: true})
			)
		)

exports.updateUser = (req, res) ->

	user = new User(req.user)
	userUpdates = req.body
	valid = true

	if (!req.user)
		valid = false
		res.status(400)
		res.send(reason: 'Not logged in')
	else
		if (!userUpdates.username || !validator.isEmail(userUpdates.username) || !validator.isLength(userUpdates.username, 1, 50))
			valid = false
			res.status(400)
			res.send({reason: 'Invalid username'})

		if (userUpdates.password && !validator.isLength(userUpdates.password, 6, 20))
			valid = false
			res.status(400)
			res.send({reason: 'Invalid Password'})

		if(user.username != userUpdates.oldUsername && !user.hasRole('admin'))
			valid = false
			res.status(403)
			res.send(reason: 'Unauthaurized')

		if (userUpdates.password)
			req.user.salt = encrypt.createSalt()
			req.user.hashed_pwd = encrypt.hashPwd(req.user.salt, userUpdates.password)

		req.user.username = userUpdates.username

		if (valid)
			User.update({username: userUpdates.oldUsername}, req.user, (err, collection) ->
				if (err)
					res.status(500)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)

exports.deleteUser = (req, res) ->

	user = new User(req.user)
	valid = true

	if (!req.user)
		valid = false
		res.status(400)
		res.send(reason: 'Not logged in')
	else
		if (!validator.isEmail(req.params.username))
			valid = false
			res.status(400)
			res.send(reason: 'Validation error')

		if(user.username != req.params.username && !user.hasRole('admin'))
			valid = false
			res.status(403)
			res.send(reason: 'Unauthaurized')

		if (valid)
			User.remove({username: req.params.username}, (err, collection) ->
				if (err)
					res.status(500)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)

exports.disconnectTwitch = (req, res) ->

	user = new User(req.user)
	valid = true

	if (!req.user)
		valid = false
		res.status(400)
		res.send(reason: 'Not logged in')
	else
		if (!validator.isEmail(req.params.username))
			valid = false
			res.status(400)
			res.send(reason: 'Validation error')

		if(user.username != req.params.username && !user.hasRole('admin'))
			valid = false
			res.status(403)
			res.send(reason: 'Unauthaurized')

		if (valid)
			User.update({username: req.params.username}, {$unset: {twitchtvUsername: '', twitchtvAccessToken: '', twitchtvRefreshToken: ''}}, (err, collection) ->
				if (err)
					res.status(500)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)
	