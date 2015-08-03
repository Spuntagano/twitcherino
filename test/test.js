var User, chai, expect, sinon, userModel, users, validator;

chai = require('chai');

sinon = require('sinon');

validator = require('validator');

userModel = require('../server/models/User');

User = require('mongoose').model('User');

users = require('../server/controllers/users');

expect = chai.expect;

chai.should();

describe('Users', function() {
  var next, req, res, user;
  user = {};
  req = {};
  req.body = {};
  res = {
    status: function() {
      return true;
    },
    send: function() {
      return true;
    },
    end: function() {
      return true;
    }
  };
  next = function() {
    return true;
  };
  beforeEach(function() {
    req.body.username = 'bob';
    req.body.password = 'qwertyuiop';
    return req.body.email = 'bob@bob.bob';
  });
  return it('Should create a user', function() {
    var stub;
    stub = sinon.stub(User);
    stub.Create.returns(true);
    users.createUser(req, res, next);
    return sinon.assert.called(user.Create);
  });
});
