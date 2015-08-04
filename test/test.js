var User, chai, expect, sinon, userModel, users;

chai = require('chai');

sinon = require('sinon');

userModel = require('../server/models/User');

User = require('mongoose').model('User');

users = require('../server/controllers/users');

expect = chai.expect;

chai.should();

describe('Users', function() {
  describe('Create users', function() {
    var mockObj, next, req, res;
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
    mockObj = sinon.mock(User);
    beforeEach(function() {
      req.body.username = 'bob@bob.bob';
      return req.body.password = 'qwertyuiop';
    });
    it('Should create a user with valid params', function() {
      var expectation;
      expectation = mockObj.expects('create').once();
      users.createUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to create a user with invalid username', function() {
      var expectation;
      req.body.username = 'bob';
      expectation = mockObj.expects('create').never();
      users.createUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to create a user with too long username', function() {
      var expectation;
      req.body.username = 'bob@bobbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb.bob';
      expectation = mockObj.expects('create').never();
      users.createUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to create a user with too short password', function() {
      var expectation;
      req.body.password = 'bob';
      expectation = mockObj.expects('create').never();
      users.createUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to create a user with too long password', function() {
      var expectation;
      req.body.password = 'bobbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
      expectation = mockObj.expects('create').never();
      users.createUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to create a user with no username', function() {
      var expectation;
      req.body.username = void 0;
      expectation = mockObj.expects('create').never();
      users.createUser(req, res, next);
      return expectation.verify();
    });
    return it('Should fail to create a user with no password', function() {
      var expectation;
      req.body.password = void 0;
      expectation = mockObj.expects('create').never();
      users.createUser(req, res, next);
      return expectation.verify();
    });
  });
  return describe('Create users', function() {
    var mockObj, next, req, res;
    req = {};
    req.user = {};
    req.body = {};
    req.user.hasRole = function(role) {
      if (req.user.roles) {
        if (req.user.roles.indexOf(role)) {
          return true;
        }
      }
    };
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
    mockObj = sinon.mock(User);
    beforeEach(function() {
      req.user.username = 'bob@bob.bob';
      req.user.password = 'qwertyuiop';
      req.body.username = 'bob@bob.bob';
      return req.body.password = 'qwertyuiop2';
    });
    it('Should update their info with valid params', function() {
      var expectation;
      expectation = mockObj.expects('update').once();
      users.updateUser(req, res, next);
      return expectation.verify();
    });
    return it('Should fail to update another user with valid params while not admin', function() {
      var expectation;
      req.body.username = 'bob@bobb.bob';
      expectation = mockObj.expects('update').never();
      users.updateUser(req, res, next);
      return expectation.verify();
    });
  });
});
