path = require('path')
rootPath = path.normalize(__dirname + '/../../')
module.exports =
	development: {
		db: 'mongodb://localhost/twitcherino',
		rootPath: rootPath,
		port: process.env.PORT || 3030,
		TWITCHTV_CLIENT_ID: '3453206b4coczmz7878sejh31g7221j',
		TWITCHTV_CLIENT_SECRET: '1cst8e1swycb981xzh0hy589yqikmk2',
		TWITCHTV_CALLBACK: '/auth/twitchtv/callback'
		SESSION_SECRET: '3PuzB3MJjKCq8axk3Ze6KpZ4yEx5PJ',
		ENV: 'development'
	},
	production: {
		db: 'mongodb://Twitcherino:6159o3092W9BU0t@ds043170.mongolab.com:43170/heroku_app34924980',
		rootPath: rootPath,
		port: process.env.PORT || 80,
		TWITCHTV_CLIENT_ID: 'oao4hsh0hs34qzg6evck4tvfphk5b10',
		TWITCHTV_CLIENT_SECRET: '7v285paa48xlpr4pzrjgcvmkhkzltfx',
		TWITCHTV_CALLBACK: 'https://warm-mountain-7865.herokuapp.com/auth/twitchtv/callback'
		SESSION_SECRET: '3PuzB3MJjKCq8axk3Ze6KpZ4yEx5PJ',
		ENV: 'production'
	}
