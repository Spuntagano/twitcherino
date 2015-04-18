var LocalStrategy, TWITCHTV_CLIENT_ID, TWITCHTV_CLIENT_SECRET, TwitchtvStrategy, User, mongoose, passport;

mongoose = require('mongoose');

passport = require('passport');

LocalStrategy = require('passport-local').Strategy;

TwitchtvStrategy = require('../../node_modules/passport-twitchtv').Strategy;

User = mongoose.model('User');

TWITCHTV_CLIENT_ID = '3453206b4coczmz7878sejh31g7221j';

TWITCHTV_CLIENT_SECRET = '1cst8e1swycb981xzh0hy589yqikmk2';

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
  passport.use(new TwitchtvStrategy({
    clientID: TWITCHTV_CLIENT_ID,
    clientSecret: TWITCHTV_CLIENT_SECRET,
    callbackURL: "/auth/twitchtv/callback",
    scope: "user_read",
    passReqToCallback: true
  }, function(req, accessToken, refreshToken, profile, done) {
    console.log(profile);
    if (req.user) {
      return User.findOne({
        username: req.user.username
      }).exec(function(err, user) {
        return User.findOne({
          twitchtvId: profile.id
        }).exec(function(err, user) {
          if (!user) {
            return User.update({
              username: req.user.username
            }, {
              twitchtvId: profile.id
            }, function(err, user) {
              return done(null, false);
            });
          } else {
            return done(null, false);
          }
        });
      });
    } else {
      return User.findOne({
        twitchtvId: profile.id
      }).exec(function(err, user) {
        if (user) {
          return done(null, user);
        } else if (!profile.email) {
          return done(null, false);
        } else if (!user) {
          return User.findOne({
            username: profile.email
          }).exec(function(err, user) {
            if (!user) {
              console.log(profile.username);
              return User.create({
                twitchtvId: profile.id,
                username: profile.email,
                twitchtvUsername: profile.username
              }, function(err, user) {
                return done(null, user);
              });
            } else {
              return done(null, false);
            }
          });
        } else {
          return done(null, false);
        }
      });
    }
  }));
  passport.serializeUser(function(user, done) {
    if (user) {
      return done(null, user);
    }
  });
  return passport.deserializeUser(function(obj, done) {
    if (obj) {
      return done(null, obj);
    } else {
      return done(null, false);
    }
  });
};
