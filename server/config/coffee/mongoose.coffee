mongoose = require('mongoose')

module.exports = (config) ->
	mongoose.connect(config.db)
	db = mongoose.connection
	db.on('error', console.error.bind(console, 'connection error...'))
	db.once('open', callback = () ->
		console.log('twitcherino db opened')
	)
