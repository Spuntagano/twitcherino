var passport;

passport = require('passport');

exports.authenticate = function(req, res, next) {
  var auth;
  auth = passport.authenticate('local', function(err, user) {
    console.log(user);
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
  return auth(req, res, next);
};

exports.requireApiLogin = function(req, res, next) {
  if (!req.isAuthenticated()) {
    res.status(403);
    return res.end();
  } else {
    return next();
  }
};

exports.requiresRole = function(role) {
  return function(req, res, next) {
    console.log(req.user);
    if (!req.isAuthenticated() || req.user.roles.indexOf(role) === -1) {
      res.status(403);
      return res.end();
    } else {
      return next();
    }
  };
};
