User = require('mongoose').model('User')
encrypt = require('../utilities/encryption')
sanitizeHtml = require('sanitize-html')
validator = require('validator')

exports.getUser = (req, res) ->
	if (!req.user)
		res.status(400)
		return res.send(reason: 'Not logged in')

	User.find(username: req.user.username).exec( (err, collection) ->
		res.send(collection)
	)

exports.getUsers = (req, res) ->
	User.find({}).exec( (err, collection) ->
		res.send(collection)
	)
	
exports.createUser = (req, res, next) ->

	userData = req.body

	validateUser(res, userData)

	userData.username = sanitizeHtml(userData.username.toLowerCase())

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
			res.send(user)
		)
	)

exports.updateUser = (req, res) ->

	if (!req.user)
		res.status(400)
		return res.send(reason: 'Not logged in')

	console.log(req.body)

	userUpdates = req.body

	validateUser(res, userUpdates)

	if(req.user.username != userUpdates.username && !req.user.hasRole('admin'))
		res.status(403)
		return res.send(reason: Unauthaurized)

	oldUsername = req.user.username
	req.user.username = sanitizeHtml(userUpdates.username)

	if (userUpdates.password && userUpdates.password.length > 0)
		req.user.salt = encrypt.createSalt()
		req.user.hashed_pwd = encrypt.hashPwd(req.user.salt, userUpdates.password)

	User.update({username: oldUsername}, req.user).exec( (err, collection) ->
		if (err)
			res.status(500)
			res.send({reason: 'Database error'})
		res.send(req.user)
	)

exports.deleteUser = (req, res) ->

	if (!req.user)
		res.status(400)
		return res.send(reason: 'Not logged in')

	validator.isEmail(req.params.username)

	if(req.user.username != req.params.username && !req.user.hasRole('admin'))
		res.status(403)
		return res.send(reason: Unauthaurized)

	User.remove({username: req.params.username}).exec( (err, collection) ->
		if (err)
			res.status(500)
			res.send({reason: 'Database error'})
		res.send(req.user)
	)

exports.disconnectTwitch = (req, res) ->

	if (!req.user)
		res.status(400)
		return res.send(reason: 'Not logged in')

	validator.isEmail(req.params.username)

	if(req.user.username != req.params.username && !req.user.hasRole('admin'))
		res.status(403)
		return res.send(reason: Unauthaurized)

	User.update({username: req.params.username}, {$unset: {twitchtvUsername: '', twitchtvAccessToken: '', twitchtvRefreshToken: ''}}).exec( (err, collection) ->
		if (err)
			res.status(500)
			res.send({reason: 'Database error'})
		res.send(req.user)
	)

validateUser = (res, userData) ->
	###
	if (!userData.username || !userData.password)
		res.status(400)
		res.send({reason: 'Validation error'})
		res.end()

	if (!validator.isEmail(userData.username))
		res.status(400)
		res.send({reason: 'Validation error'})
		res.end()

	if (!validator.isLength(userData.username, 1, 50))
		res.status(400)
		res.send({reason: 'Validation error'})
		res.end()

	if (userData.password && !validator.isLength(userData.password, 6, 20))
		res.status(400)
		res.send({reason: 'Validation error'})
		res.end()
	###