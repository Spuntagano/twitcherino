var mongoose, userModel;

mongoose = require('mongoose');

userModel = require('../models/User');

module.exports = function(config) {
  var callback, db;
  mongoose.connect(config.db);
  db = mongoose.connection;
  db.on('error', console.error.bind(console, 'connection error...'));
  return db.once('open', callback = function() {
    return console.log('twitcherino db opened');
  });
};
