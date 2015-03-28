var createSalt, crypto, hashPwd, mongoose;

mongoose = require('mongoose');

crypto = require('crypto');

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
    username: String,
    salt: String,
    hashed_pwd: String,
    roles: [String]
  });
  userSchema.methods = {
    authenticate: function(passwordToMatch) {
      return hashPwd(this.salt, passwordToMatch) === this.hashed_pwd;
    }
  };
  User = mongoose.model('User', userSchema);
  return User.find({}).exec(function(err, collection) {
    var hash, salt;
    if (collection.length === 0) {
      salt = createSalt();
      hash = hashPwd(salt, 'joeblo');
      User.create({
        firstName: 'Joe',
        lastName: 'Blo',
        username: 'joeblo',
        salt: salt,
        hashed_pwd: hash,
        roles: ['admin']
      });
      salt = createSalt();
      hash = hashPwd(salt, 'joeblo2');
      User.create({
        firstName: 'Joe2',
        lastName: 'Blo2',
        username: 'joeblo2',
        salt: salt,
        hashed_pwd: hash,
        roles: []
      });
      salt = createSalt();
      hash = hashPwd(salt, 'joeblo3');
      return User.create({
        firstName: 'Joe3',
        lastName: 'Blo3',
        username: 'joeblo3',
        salt: salt,
        hashed_pwd: hash
      });
    }
  });
};

createSalt = function() {
  return crypto.randomBytes(128).toString('base64');
};

hashPwd = function(salt, pwd) {
  var hmac;
  hmac = crypto.createHmac('sha1', salt);
  return hmac.update(pwd).digest('hex');
};
