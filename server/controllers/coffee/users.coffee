User = require('mongoose').model('User')
encrypt = require('../utilities/encryption')
validator = require('validator')

exports.getUser = (req, res) ->
	if (!req.user)
		res.status(400)
		res.send(reason: 'Not logged in')
		res.end()

	User.find(username: req.user.username).exec( (err, collection) ->
		res.send(collection)
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
				res.send()
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

	if (!userUpdates.username || !validator.isEmail(userUpdates.username) || !validator.isLength(userUpdates.username, 1, 50))
		valid = false
		res.status(400)
		res.send({reason: 'Invalid username'})

	if(user.username != userUpdates.oldUsername && !user.hasRole('admin'))
		valid = false
		res.status(403)
		res.send(reason: 'Unauthaurized')

	if (userUpdates.password && !validator.isLength(userUpdates.password, 6, 20))
		valid = false
		res.status(400)
		res.send({reason: 'Invalid Password'})

	if (userUpdates.password)
		user.salt = encrypt.createSalt()
		user.hashed_pwd = encrypt.hashPwd(user.salt, userUpdates.password)

	if (valid)
		User.update({username: userUpdates.oldUsername}, user, (err, collection) ->
			if (err)
				res.status(500)
				res.send({reason: 'Database error'})
			res.send()
		)

exports.deleteUser = (req, res) ->

	if (!req.user)
		res.status(400)
		res.send(reason: 'Not logged in')
		res.end()

	if (!validator.isEmail(req.params.username))
		res.status(400)
		res.send(reason: 'Validation error')
		res.end()

	if(req.user.username != req.params.username && !req.user.hasRole('admin'))
		res.status(403)
		res.send(reason: Unauthaurized)
		res.end()

	User.remove({username: req.params.username}).exec( (err, collection) ->
		if (err)
			res.status(500)
			res.send({reason: 'Database error'})
			res.end()
		res.send()
	)

exports.disconnectTwitch = (req, res) ->

	if (!req.user)
		res.status(400)
		res.send(reason: 'Not logged in')
		res.end()

	if (!validator.isEmail(req.params.username))
		res.status(400)
		res.send(reason: 'Validation error')
		res.end()

	if(req.user.username != req.params.username && !req.user.hasRole('admin'))
		res.status(403)
		res.send(reason: Unauthaurized)
		res.end()

	User.update({username: req.params.username}, {$unset: {twitchtvUsername: '', twitchtvAccessToken: '', twitchtvRefreshToken: ''}}).exec( (err, collection) ->
		if (err)
			res.status(500)
			res.send({reason: 'Database error'})
			res.end()
		res.send()
	)
	