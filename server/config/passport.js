var LocalStrategy, User, mongoose, passport;

mongoose = require('mongoose');

passport = require('passport');

LocalStrategy = require('passport-local').Strategy;

User = mongoose.model('User');

module.exports = function() {
  passport.use(new LocalStrategy({
    usernameField: 'username',
    passwordField: 'password'
  }, function(username, password, done) {
    return User.findOne({
      username: username
    }).exec(function(err, user) {
      if (user && user.authenticate(password)) {
        return done(null, user);
      } else {
        return done(null, false);
      }
    });
  }));
  passport.serializeUser(function(user, done) {
    if (user) {
      return done(null, user._id);
    }
  });
  return passport.deserializeUser(function(id, done) {
    return User.findOne({
      _id: id
    }).exec(function(err, user) {
      if (user) {
        return done(null, user);
      } else {
        return done(null, false);
      }
    });
  });
};
