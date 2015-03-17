module.exports = function(app) {
  app.get('/partials/:partialPath', function(req, res) {
    return res.render('partials/' + req.params.partialPath);
  });
  return app.get('*', function(req, res) {
    return res.render('index');
  });
};
