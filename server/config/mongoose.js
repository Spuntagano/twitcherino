var mongoose;

mongoose = require('mongoose');

module.exports = function(config) {
  var User, callback, db, userSchema;
  mongoose.connect(config.db);
  db = mongoose.connection;
  db.on('error', console.error.bind(console, 'connection error...'));
  db.once('open', callback = function() {
    return console.log('twitcherino db opened');
  });
  userSchema = mongoose.Schema({
    firstName: String,
    lastName: String,
    username: String
  });
  User = mongoose.model('User', userSchema);
  return User.find({}).exec(function(err, collection) {
    if (collection.length === 0) {
      User.create({
        firstName: 'Joe',
        lastName: 'Blo',
        username: 'joeblo'
      });
      User.create({
        firstName: 'Joe2',
        lastName: 'Blo2',
        username: 'joeblo2'
      });
      return User.create({
        firstName: 'Joe3',
        lastName: 'Blo3',
        username: 'joeblo3'
      });
    }
  });
};
