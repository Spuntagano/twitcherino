mongoose = require('mongoose')
encrypt = require('../utilities/encryption')

userSchema = mongoose.Schema({
	username: {
		type: String
		unique: true
	}
	twitchtvUsername: {
		type: String
		unique: true
		sparse: true
	}
	twitchtvAccessToken: {type: String}
	twitchtvRefreshToken: {type: String}
	salt: {type: String}
	hashed_pwd: {type: String}
	roles: [String]
	twitchFollows: [String]
	hitboxFollows: [String]
	azubuFollows: [String]
})

userSchema.methods = {
	authenticate: (passwordToMatch) ->
		encrypt.hashPwd(this.salt, passwordToMatch) == this.hashed_pwd
	hasRole: (role) ->
		this.roles.indexOf(role) > -1
}

User = mongoose.model('User', userSchema)

createDefaultUsers = ->
	User.find({}).exec( (err, collection) ->
		if(collection.length == 0)
			salt = encrypt.createSalt()
			hash = encrypt.hashPwd(salt, 'joeblo')
			User.create({firstName: 'Joe', lastName: 'Blo', username: 'joeblo', salt: salt, hashed_pwd: hash, roles: ['admin']})
			salt = encrypt.createSalt()
			hash = encrypt.hashPwd(salt, 'joeblo2')
			User.create({firstName: 'Joe2', lastName: 'Blo2', username: 'joeblo2', salt: salt, hashed_pwd: hash, roles: []})
			salt = encrypt.createSalt()
			hash = encrypt.hashPwd(salt, 'joeblo3')
			User.create({firstName: 'Joe3', lastName: 'Blo3', username: 'joeblo3', salt: salt, hashed_pwd: hash})
	)

exports.createDefaultUsers = createDefaultUsers