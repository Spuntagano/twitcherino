mongoose = require('mongoose')
User = mongoose.model('User')

exports.addFollow = (req, res, next) ->

	valid = true

	if (!req.user)
		valid = false
		res.status(400)
		res.send({'Not logged in'})
	else
		if (!req.body.platform !! !req.body.channelTitle)
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
		if (!req.body.platform !! !req.body.channelTitle)
			valid = false
			res.status(400)
			res.send({'Invalid parameters'})

		follows = getPlatformObject(req.body.platform, req.body.channelTitle)

		if (valid && follows)
			User.update({username: req.user.username}, {$pull: follows}, (err, collection) ->
				if (err)
					res.status(500)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)

exports.importTwitchFollows = (req, res, next) ->

	valid = true

	if (!req.user)
		valid = false
		res.status(400)
		res.send({reason: 'Not logged in'})
	else
		if (!req.body.channels)
			valid = false
			res.status(400)
			res.send({'Invalid parameters'})

		User.update({username: req.user.username}, {$addToSet: {twitchFollows: { $each: req.body.channels } }}).exec( (err, collection) ->
			if (err)
				res.status(500)
				res.send({reason: 'Database error'})
			res.send({success: true})
		)

exports.importHitboxFollows = (req, res, next) ->
	if (!req.user)
		res.status(400)
		res.send({reason: 'Not logged in'})
	else
		if (!req.body.channels)
			valid = false
			res.status(400)
			res.send({'Invalid parameters'})

		User.update({username: req.user.username}, {$addToSet: {hitboxFollows: { $each: req.body.channels } }}).exec( (err, collection) ->
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

