mongoose = require('mongoose')

module.exports = (config) ->
	mongoose.connect(config.db)
	db = mongoose.connection
	db.on('error', console.error.bind(console, 'connection error...'))
	db.once('open', callback = () ->
		console.log('twitcherino db opened')
	)

	userSchema = mongoose.Schema({
		firstName: String,
		lastName: String,
		username: String
	})

	User = mongoose.model('User', userSchema)

	User.find({}).exec( (err, collection) ->
		if(collection.length == 0)
			User.create({firstName: 'Joe', lastName: 'Blo', username: 'joeblo'})
			User.create({firstName: 'Joe2', lastName: 'Blo2', username: 'joeblo2'})
			User.create({firstName: 'Joe3', lastName: 'Blo3', username: 'joeblo3'})
	)
