mongoose = require('mongoose')
User = mongoose.model('User')

exports.addFollow = (req, res, next) ->
	if (!req.user)
		res.send({success: false})
	else
		switch req.body.platform
			when 'twitch' then User.update({username: req.user.username}, {$addToSet: {twitchFollows: req.body.channelTitle}}).exec( (err, collection) ->
				if (err)
					res.status(400)
					res.send({reason: err.toString})
				res.send({success: true})
			)
			when 'hitbox' then User.update({username: req.user.username}, {$addToSet: {hitboxFollows: req.body.channelTitle}}).exec( (err, collection) ->
				if (err)
					res.status(400)
					res.send({reason: err.toString})
				res.send({success: true})
			)

exports.removeFollow = (req, res, next) ->
	if (!req.user)
		res.send({success: false})
	else
		switch req.body.platform
			when 'twitch' then User.update({username: req.user.username}, {$pull: {twitchFollows: req.body.channelTitle}}).exec( (err, collection) ->
				if (err)
					res.status(400)
					res.send({reason: err.toString})
				res.send({success: true})
			)
			when 'hitbox' then User.update({username: req.user.username}, {$pull: {hitboxFollows: req.body.channelTitle}}).exec( (err, collection) ->
				if (err)
					res.status(400)
					res.send({reason: err.toString})
				res.send({success: true})
			)

exports.importTwitchFollows = (req, res, next) ->
	if (!req.user)
		res.send({success: false})
	else
		User.update({username: req.user.username}, {$addToSet: {twitchFollows: req.body.channels}}).exec( (err, collection) ->
			if (err)
				res.status(400)
				res.send({reason: err.toString})
			res.send({success: true})
		)