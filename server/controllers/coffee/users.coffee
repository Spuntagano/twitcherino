User = require('mongoose').model('User')
encrypt = require('../utilities/encryption')

exports.getUsers = (req, res) ->
	User.find({}).exec( (err, collection) ->
		res.send(collection)
	)

exports.createUser = (req, res, next) ->
	userData = req.body
	userData.username = userData.username.toLowerCase()
	userData.salt = encrypt.createSalt()
	userData.hashed_pwd =  encrypt.hashPwd(userData.salt, userData.password)
	User.create(userData, (err, user) ->
		if (err)
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

	if(parseInt(req.user._id, 10) != parseInt(userUpdates._id, 10) && !req.user.hasRole('admin'))
		res.status(403)
		res.end()

	req.user.firstName = userUpdates.firstName
	req.user.lastName = userUpdates.lastName
	req.user.username = userUpdates.username

	if (userUpdates.password && userUpdates.password.length > 0)
		req.user.salt = encrypt.createSalt
		req.user.hashed_pwd = encrypt.hashPwd(req.user.salt, userUpdates.password)

	req.user.save( (err) ->
		if (err)
			res.status(400)
			res.send({reason: err.toString})
		res.send(req.user)
	)