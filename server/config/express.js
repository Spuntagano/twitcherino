var bodyParser, cookieParser, express, logger, passport, session;

express = require('express');

logger = require('morgan');

bodyParser = require('body-parser');

cookieParser = require('cookie-parser');

session = require('express-session');

passport = require('passport');

module.exports = function(app, config) {
  app.set('views', config.rootPath + '/server/views');
  app.engine('html', require('ejs').renderFile);
  app.set('view engine', 'html');
  app.use(logger('dev'));
  app.use(cookieParser());
  app.use(bodyParser());
  app.use(session({
    secret: 'twitch boys'
  }));
  app.use(passport.initialize());
  app.use(passport.session());
  return app.use(express["static"](config.rootPath + '/public'));
};
