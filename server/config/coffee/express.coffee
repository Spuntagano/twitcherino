flash = require('connect-flash')
express = require('express')
logger = require('morgan')
bodyParser = require('body-parser')
cookieParser = require('cookie-parser')
session = require('express-session')
passport = require('passport')

module.exports = (app, config) ->
	app.set('views', config.rootPath + '/server/views')
	app.engine('html', require('ejs').renderFile)
	app.set('view engine', 'html')

	app.use(logger('dev'))
	app.use(cookieParser())
	app.use(bodyParser())

	app.use(flash())

	app.use(session({secret: config.SESSION_SECRET, saveUninitialized: true, resave: true}))
	app.use(passport.initialize())
	app.use(passport.session())

	app.use(express.static(config.rootPath + '/public'))

