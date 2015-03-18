var passport;

passport = require('passport');

module.exports = function(app) {
  app.get('/partials/:partialPath', function(req, res) {
    return res.render('partials/' + req.params.partialPath);
  });
  app.post('/login', function(req, res, next) {
    var auth;
    auth = passport.authenticate('local', function(err, user) {
      if (err) {
        next(err);
      }
      if (!user) {
        res.send({
          success: false
        });
      }
      return req.logIn(user, function(err) {
        if (err) {
          next(err);
        }
        return res.send({
          success: true,
          user: user
        });
      });
    });
    console.log(auth);
    return auth(req, res, next);
  });
  return app.get('*', function(req, res) {
    return res.render('index');
  });
};
