mongoose = require('mongoose')
User = mongoose.model('User')
validator = require('validator')

exports.addFollow = (req, res, next) ->

	valid = true

	if (!req.user)
		valid = false
		res.send({reason: 'Not logged in'})
	else
		if (!req.body.platform || !req.body.channelTitle || !validator.isValidTitle(req.body.channelTitle))
			valid = false
			res.send({reason: 'Invalid parameters'})

		if (req.body.platform != 'twitch' && req.body.platform != 'hitbox' && req.body.platform != 'azubu')
			valid = false
			res.send({reason: 'Invalid parameters'})

		if (valid)
			User.update({username: req.user.username}, {$addToSet: {'follows["platform"]': req.body.channelTitle}}, (err, collection) ->
				if (err)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)


exports.removeFollow = (req, res, next) ->

	valid = true

	if (!req.user)
		valid = false
		res.send({reason: 'Not logged in'})
	else
		if (!req.body.platform || !req.body.channelTitle || !validator.isValidTitle(req.body.channelTitle))
			valid = false
			res.send({reason: 'Invalid parameters'})

		if (req.body.platform != 'twitch' && req.body.platform != 'hitbox' && req.body.platform != 'azubu')
			valid = false
			res.send({reason: 'Invalid parameters'})

		if (valid)
			User.update({username: req.user.username}, {$pull: {'follows["platform"]': req.body.channelTitle}}, (err, collection) ->
				if (err)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)

exports.importFollows = (req, res, next) ->

	valid = true

	if (!req.user)
		valid = false
		res.send({reason: 'Not logged in'})
	else
		if (!req.body.platform)
			valid = false
			res.send({reason: 'Invalid parameters'})

		if (req.body.platform != 'twitch' && req.body.platform != 'hitbox' && req.body.platform != 'azubu')
			valid = false
			res.send({reason: 'Invalid parameters'})

		if (!req.body.channels)
			valid = false
			res.send({reason: 'Invalid parameters'})
		else
			for i in [0...req.body.channels.length]
				if (!validator.isValidTitle(req.body.channels[i]))
					valid = false
					i = req.body.channels.length
					res.send({reason: 'Invalid channel name'})

		if (valid)
			User.update({username: req.user.username}, {$addToSet: {'follows["platform"]': { $each: req.body.channels }}}, (err, collection) ->
				if (err)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)

validator.isValidTitle = (title) ->
	title.match('^[a-zA-Z0-9_-]*$')