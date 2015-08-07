mongoose = require('mongoose')
User = mongoose.model('User')
validator = require('validator')

exports.addFollow = (req, res, next) ->

	valid = true

	if (!req.user)
		valid = false
		res.status(400)
		res.send({'Not logged in'})
	else
		if (!req.body.platform || !req.body.channelTitle || !validator.isValidTitle(req.body.channelTitle))
			valid = false
			res.status(400)
			res.send({'Invalid parameters'})

		follows = getPlatformObject(req.body.platform, req.body.channelTitle)

		if (valid && follows)
			User.update({username: req.user.username}, {$addToSet: follows}, (err, collection) ->
				if (err)
					res.status(500)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)


exports.removeFollow = (req, res, next) ->

	valid = true

	if (!req.user)
		valid = false
		res.status(400)
		res.send({reason: 'Not logged in'})
	else
		if (!req.body.platform || !req.body.channelTitle || !validator.isValidTitle(req.body.channelTitle))
			valid = false
			res.status(400)
			res.send({reason: 'Invalid parameters'})

		follows = getPlatformObject(req.body.platform, req.body.channelTitle)

		if (valid && follows)
			User.update({username: req.user.username}, {$pull: follows}, (err, collection) ->
				if (err)
					res.status(500)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)

exports.importFollows = (req, res, next) ->

	valid = true

	if (!req.user)
		valid = false
		res.status(400)
		res.send({reason: 'Not logged in'})
	else
		if (!req.body.platform)
			valid = false
			res.status(400)
			res.send({reason: 'Invalid parameters'})
		else
			switch req.body.platform
				when 'twitch' then toPlatform = {twitchFollows: { $each: req.body.channels } }
				when 'hitbox' then toPlatform = {hitboxFollows: { $each: req.body.channels } }
				when 'azubu' then toPlatform = {azubuFollows: { $each: req.body.channels } }
				else
					toPlatform = false

		if (!req.body.channels)
			valid = false
			res.status(400)
			res.send({reason: 'Invalid parameters'})
		else
			for i in [0...req.body.channels.length]
				if (!validator.isValidTitle(req.body.channels[i]))
					valid = false
					i = req.body.channels.length
					res.send({reason: 'Invalid channel name'})

		if (valid && toPlatform)
			User.update({username: req.user.username}, {$addToSet: toPlatform }, (err, collection) ->
				if (err)
					res.status(500)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)

getPlatformObject = (platform, channelTitle) ->
	switch platform
		when 'twitch' then follows = {twitchFollows: channelTitle}
		when 'hitbox' then follows = {hitboxFollows: channelTitle}
		when 'azubu' then follows = {azubuFollows: channelTitle}
		else
			follows = false

validator.isValidTitle = (title) ->
	title.match('^[a-zA-Z0-9_-]*$')