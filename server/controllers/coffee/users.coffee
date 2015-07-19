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

	validateInput(res, userData)

	userData.username = sanitizeHtml(userData.username.toLowerCase())
	userData.password = sanitizeHtml(userData.password)

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

	userUpdates = req.body

	validateInput(res, userUpdates)

	if(parseInt(req.user._id, 10) != parseInt(userUpdates._id, 10) && !req.user.hasRole('admin'))
		res.status(403)
		return res.send(reason: Unauthaurized)

	oldUsername = req.user.username

	req.user.username = sanitizeHtml(userUpdates.username)

	if (userUpdates.password && userUpdates.password.length > 0)
		req.user.password = sanitizeHtml(req.user.password)
		req.user.salt = encrypt.createSalt()
		req.user.hashed_pwd = encrypt.hashPwd(req.user.salt, userUpdates.password)

	User.update({username: oldUsername}, req.user).exec( (err, collection) ->
		if (err)
			res.status(400)
			res.send({reason: err.toString})
		res.send(req.user)
	)


validateInput = (res, userData) ->
	if (!userData.username || !userData.password)
		res.status(400)
		res.send({reason: 'validation error'})
		res.end()

	if (!validator.isEmail(userData.username))
		res.status(400)
		res.send({reason: 'validation error'})
		res.end()

	if (!validator.isLength(userData.username, 1, 50) || !validator.isLength(userData.password, 6, 20))
		res.status(400)
		res.send({reason: 'validation error'})
		res.end()