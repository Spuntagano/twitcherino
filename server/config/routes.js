var auth;

auth = require('./auth');

module.exports = function(app) {
  app.get('/partials/:partialPath', function(req, res) {
    return res.render('partials/' + req.params.partialPath);
  });
  app.post('/login', auth.authenticate);
  return app.get('*', function(req, res) {
    return res.render('index');
  });
};
