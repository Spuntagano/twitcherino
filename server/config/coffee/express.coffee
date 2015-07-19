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

	app.use(permitCrossDomainRequests)

	app.use(flash())

	app.use(session({secret: config.SESSION_SECRET, saveUninitialized: true, resave: true}))
	app.use(passport.initialize())
	app.use(passport.session())

	app.use(express.static(config.rootPath + '/public'))

permitCrossDomainRequests = (req, res, next) ->
	res.header('Access-Control-Allow-Origin', '*')
	res.header('Access-Control-Allow-Methods', 'http://warm-mountain-7865.herokuapp.com, https://warm-mountain-7865.herokuapp.com')
	res.header('Access-Control-Allow-Headers', 'Content-Type')

	if ('OPTIONS' == req.method)
	  res.send(200)
	else
	  next()


