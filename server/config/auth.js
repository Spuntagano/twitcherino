var passport;

passport = require('passport');

exports.authenticate = function(req, res, next) {
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
  console.log(req.session.passport.user);
  return auth(req, res, next);
};
