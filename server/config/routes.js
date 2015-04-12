var User, auth, follow, mongoose, passport, users;

auth = require('./auth');

follow = require('./follow');

users = require('../controllers/users');

mongoose = require('mongoose');

passport = require('passport');

User = mongoose.model('User');

module.exports = function(app) {
  app.get('/api/users', auth.requiresRole('admin'), users.getUsers);
  app.post('/api/users', users.createUser);
  app.put('/api/users', users.updateUser);
  app.get('/partials/:partialPath', function(req, res) {
    return res.render('partials/' + req.params.partialPath);
  });
  app.post('/login', auth.authenticate);
  app.post('/logout', function(req, res) {
    req.logout();
    return res.end();
  });
  app.get('/auth/twitchtv', passport.authenticate('twitchtv'));
  app.get('/auth/twitchtv/callback', passport.authenticate('twitchtv', {
    failureRedirect: '/'
  }), function(req, res) {
    return res.redirect('/');
  });
  app.post('/follow', follow.addFollow);
  app.post('/unfollow', follow.removeFollow);
  app.all('/api/*', function() {
    return res.send(404);
  });
  return app.get('*', function(req, res) {
    return res.render('index', {
      bootstrappedUser: req.user
    });
  });
};
