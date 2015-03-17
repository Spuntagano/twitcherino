var express = require('express'),
	logger = require('morgan'),
	bodyParser = require('body-parser');

module.exports = function(app, config){
	app.set('views', config.rootPath + '/server/views');
	app.engine('html', require('ejs').renderFile);
	app.set('view engine', 'html');

	app.use(logger('dev'));
	app.use(bodyParser());

	app.use(express.static(config.rootPath + '/public'));
}