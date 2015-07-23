mongoose = require('mongoose')
User = mongoose.model('User')

exports.addFollow = (req, res, next) ->
	if (!req.user)
		res.status(400)
		res.send({'Not logged in'})
	else
		switch req.body.platform
			when 'twitch' then User.update({username: req.user.username}, {$addToSet: {twitchFollows: req.body.channelTitle}}).exec( (err, collection) ->
				if (err)
					res.status(500)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)
			when 'hitbox' then User.update({username: req.user.username}, {$addToSet: {hitboxFollows: req.body.channelTitle}}).exec( (err, collection) ->
				if (err)
					res.status(500)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)
			when 'azubu' then User.update({username: req.user.username}, {$addToSet: {azubuFollows: req.body.channelTitle}}).exec( (err, collection) ->
				if (err)
					res.status(500)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)

exports.removeFollow = (req, res, next) ->
	if (!req.user)
		res.status(400)
		res.send({reason: 'Not logged in'})
	else
		switch req.body.platform
			when 'twitch' then User.update({username: req.user.username}, {$pull: {twitchFollows: req.body.channelTitle}}).exec( (err, collection) ->
				if (err)
					res.status(500)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)
			when 'hitbox' then User.update({username: req.user.username}, {$pull: {hitboxFollows: req.body.channelTitle}}).exec( (err, collection) ->
				if (err)
					res.status(500)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)
			when 'azubu' then User.update({username: req.user.username}, {$pull: {azubuFollows: req.body.channelTitle}}).exec( (err, collection) ->
				if (err)
					res.status(500)
					res.send({reason: 'Database error'})
				res.send({success: true})
			)

exports.importTwitchFollows = (req, res, next) ->
	if (!req.user || !req.body.channels)
		res.status(400)
		res.send({reason: 'Missing arguments'})
		res.end()
	else
		User.update({username: req.user.username}, {$addToSet: {twitchFollows: { $each: req.body.channels } }}).exec( (err, collection) ->
			if (err)
				res.status(500)
				res.send({reason: 'Database error'})
				res.end()
			res.send({success: true})
		)

exports.importHitboxFollows = (req, res, next) ->
	console.log(req.body.channels)
	console.log(req.user)
	if (!req.user || !req.body.channels)
		res.status(400)
		res.send({reason: 'Missing arguments'})
		res.end()
	else
		User.update({username: req.user.username}, {$addToSet: {hitboxFollows: { $each: req.body.channels } }}).exec( (err, collection) ->
			if (err)
				res.status(500)
				res.send({reason: 'Database error'})
				res.end()
			res.send({success: true})
		)