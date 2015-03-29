var User, encrypt;

User = require('mongoose').model('User');

encrypt = require('../utilities/encryption');

exports.getUsers = function(req, res) {
  return User.find({}).exec(function(err, collection) {
    return res.send(collection);
  });
};

exports.createUser = function(req, res, next) {
  var userData;
  userData = req.body;
  userData.username = userData.username.toLowerCase();
  userData.salt = encrypt.createSalt();
  userData.hashed_pwd = encrypt.hashPwd(userData.salt, userData.password);
  return User.create(userData, function(err, user) {
    if (err) {
      if (err.toString().indexOf('E11000') > -1) {
        err = new Error('Duplicate Username');
      }
      res.status(400);
      res.send({
        reason: err.toString()
      });
    }
    return req.logIn(user, function(err) {
      if (err) {
        next(err);
      }
      return res.send(user);
    });
  });
};

exports.updateUser = function(req, res) {
  var userUpdates;
  userUpdates = req.body;
  if (parseInt(req.user._id, 10) !== parseInt(userUpdates._id, 10) && !req.user.hasRole('admin')) {
    res.status(403);
    res.end();
  }
  req.user.firstName = userUpdates.firstName;
  req.user.lastName = userUpdates.lastName;
  req.user.username = userUpdates.username;
  if (userUpdates.password && userUpdates.password.length > 0) {
    req.user.salt = encrypt.createSalt;
    req.user.hashed_pwd = encrypt.hashPwd(req.user.salt, userUpdates.password);
  }
  return req.user.save(function(err) {
    if (err) {
      res.status(400);
      res.send({
        reason: err.toString
      });
    }
    return res.send(req.user);
  });
};
