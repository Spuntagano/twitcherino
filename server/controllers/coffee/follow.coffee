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

		###
		if (req.body.platform != 'twitch' && req.body.platform != 'hitbox' && req.body.platform != 'azubu')
			valid = false
			res.send({reason: 'Invalid parameters'})
		###

		followObj = getFollowObj(req.body.platform, req.body.channelTitle)

		if (valid && followObj)
			User.update({username: req.user.username}, {$addToSet: followObj}, (err, collection) ->
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

		###
		if (req.body.platform != 'twitch' && req.body.platform != 'hitbox' && req.body.platform != 'azubu')
			valid = false
			res.send({reason: 'Invalid parameters'})
		###

		followObj = getFollowObj(req.body.platform, req.body.channelTitle)

		if (valid && followObj)
			User.update({username: req.user.username}, {$pull: followObj}, (err, collection) ->
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

		###
		if (req.body.platform != 'twitch' && req.body.platform != 'hitbox' && req.body.platform != 'azubu')
			valid = false
			res.send({reason: 'Invalid parameters'})
		###

		importObj = getImportObj(req.body.platform, req.body.channels)

		if (!req.body.channels)
			valid = false
			res.send({reason: 'Invalid parameters'})
		else
			for i in [0...req.body.channels.length]
				if (!validator.isValidTitle(req.body.channels[i]))
					valid = false
					i = req.body.channels.length
					res.send({reason: 'Invalid channel name'})

		if (valid && importObj)
			User.update({username: req.user.username}, {$addToSet: importObj}, (err, collection) ->
				if (err)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)

validator.isValidTitle = (title) ->
	title.match('^[a-zA-Z0-9_-]*$')

getFollowObj = (platform, channelTitle) ->
	switch (platform)
		when 'twitch' then followObj = {'follows.twitch': channelTitle}
		when 'hitbox' then followObj = {'follows.hitbox': channelTitle}
		when 'azubu' then followObj = {'follows.azubu': channelTitle}
		else
			undefined

getImportObj = (platform, channels) ->
	switch (platform)
		when 'twitch' then importObj = {'follows.twitch': { $each: channels }}
		when 'hitbox' then importObj = {'follows.hitbox': { $each: channels }}
		when 'azubu' then importObj = {'follows.azubu': { $each: channels }}
		else
			undefined