passport = require('passport')

module.exports = (app) ->
	app.get('/partials/:partialPath', (req, res) ->
		res.render('partials/' + req.params.partialPath)
	)

	app.post('/login', (req, res, next) ->
		auth = passport.authenticate('local', (err, user) ->
			if (err)
				next(err)
			if(!user)
				res.send({success: false})
			req.logIn(user, (err) ->
				if (err)
					next(err)
				res.send({success: true, user: user})
			)
		)
		console.log(auth)
		auth(req, res, next)
	)

	app.get('*', (req, res) ->
		res.render('index')
	)