path = require('path')
rootPath = path.normalize(__dirname + '/../../')
module.exports =
	development: {
		db: 'mongodb://localhost/twitcherino',
		rootPath: rootPath,
		port: process.env.PORT || 3030
	},
	production: {
		db: 'mongo db creds',
		rootPath: rootPath,
		port: process.env.PORT || 80
	},
	TWITCHTV_CLIENT_ID: 'XXXXXXXXXXXXXXXXXXXXXXXXXX',
	TWITCHTV_CLIENT_SECRET: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
