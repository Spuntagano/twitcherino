var User, createDefaultUsers, encrypt, mongoose, userSchema;

mongoose = require('mongoose');

encrypt = require('../utilities/encryption');

userSchema = mongoose.Schema({
  firstName: {
    type: String,
    required: '{PATH} is required!'
  },
  lastName: {
    type: String,
    required: '{PATH} is required!'
  },
  username: {
    type: String,
    required: '{PATH} is required!',
    unique: true
  },
  salt: {
    type: String,
    required: '{PATH} is required!'
  },
  hashed_pwd: {
    type: String,
    required: '{PATH} is required!'
  },
  roles: [String]
});

userSchema.methods = {
  authenticate: function(passwordToMatch) {
    return encrypt.hashPwd(this.salt, passwordToMatch) === this.hashed_pwd;
  },
  hasRole: function(role) {
    return this.roles.indexOf(role) > -1;
  }
};

User = mongoose.model('User', userSchema);

createDefaultUsers = function() {
  return User.find({}).exec(function(err, collection) {
    var hash, salt;
    if (collection.length === 0) {
      salt = encrypt.createSalt();
      hash = encrypt.hashPwd(salt, 'joeblo');
      User.create({
        firstName: 'Joe',
        lastName: 'Blo',
        username: 'joeblo',
        salt: salt,
        hashed_pwd: hash,
        roles: ['admin']
      });
      salt = encrypt.createSalt();
      hash = encrypt.hashPwd(salt, 'joeblo2');
      User.create({
        firstName: 'Joe2',
        lastName: 'Blo2',
        username: 'joeblo2',
        salt: salt,
        hashed_pwd: hash,
        roles: []
      });
      salt = encrypt.createSalt();
      hash = encrypt.hashPwd(salt, 'joeblo3');
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

exports.createDefaultUsers = createDefaultUsers;
