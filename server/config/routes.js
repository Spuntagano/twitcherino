var User, auth, mongoose;

auth = require('./auth');

mongoose = require('mongoose');

User = mongoose.model('User');

module.exports = function(app) {
  app.get('/api/users', auth.requiresRole('admin'), function(req, res) {
    return User.find({}).exec(function(err, collection) {
      return res.send(collection);
    });
  });
  app.get('/partials/:partialPath', function(req, res) {
    return res.render('partials/' + req.params.partialPath);
  });
  app.post('/login', auth.authenticate);
  app.post('/logout', function(req, res) {
    req.logout();
    return res.end();
  });
  return app.get('*', function(req, res) {
    return res.render('index', {
      bootstrappedUser: req.user
    });
  });
};
