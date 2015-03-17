path = require('path')
rootPath = path.normalize(__dirname + '/../../')
module.exports =
	development: {
		db: 'mongodb://localhost/twitcherino',
		rootPath: rootPath,
		port: process.env.PORT || 3030
	},
	production: {
		db: 'mongodb://Spuntagano:bobcat3821@ds043170.mongolab.com:43170/heroku_app34924980',
		rootPath: rootPath,
		port: process.env.PORT || 80
	}
