var LocalStrategy, User, app, config, env, express, mongoose, passport;

express = require('express');

mongoose = require('mongoose');

passport = require('passport');

LocalStrategy = require('passport-local').Strategy;

env = process.env.MODE_ENV = process.env.MODE_ENV || 'development';

app = express();

config = require('./server/config/config')[env];

require('./server/config/express')(app, config);

require('./server/config/mongoose')(config);

User = mongoose.model('User');

passport.use(new LocalStrategy(function(username, password, done) {
  console.log(username);
  console.log('aa');
  return User.findOne({
    username: username
  }).exec(function(err, user) {
    if (user) {
      return done(null, user);
    } else {
      return done(null, false);
    }
  });
}));

passport.serializeUser(function(user, done) {
  console.log(user);
  if (user) {
    return done(null, user._id);
  }
});

passport.deserializeUser(function(id, done) {
  console.log('cc');
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

require('./server/config/routes')(app);

app.listen(config.port);

console.log('Listening on port ' + config.port + '...');
