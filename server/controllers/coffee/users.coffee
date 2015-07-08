User = require('mongoose').model('User')
encrypt = require('../utilities/encryption')

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

	if (!userData.username || !userData.firstName || !userData.lastName || !userData.password)
		res.status(400)
		return res.send(reason: 'Missing field')

	userData.username = userData.username.toLowerCase()
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

	if (!userUpdates.username || !userUpdates.firstName || !userUpdates.lastName || !userUpdates.password)
		res.status(400)
		return res.send(reason: 'Missing field')

	if(parseInt(req.user._id, 10) != parseInt(userUpdates._id, 10) && !req.user.hasRole('admin'))
		res.status(403)
		return res.send(reason: Unauthaurized)

	oldUsername = req.user.username

	req.user.firstName = userUpdates.firstName
	req.user.lastName = userUpdates.lastName
	req.user.username = userUpdates.username

	if (userUpdates.password && userUpdates.password.length > 0)
		req.user.salt = encrypt.createSalt()
		req.user.hashed_pwd = encrypt.hashPwd(req.user.salt, userUpdates.password)

	User.update({username: oldUsername}, req.user).exec( (err, collection) ->
		if (err)
			res.status(400)
			res.send({reason: err.toString})
		res.send(req.user)
	)
