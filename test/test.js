var User, chai, encrypt, expect, sinon, userModel, users;

chai = require('chai');

sinon = require('sinon');

encrypt = require('../server/utilities/encryption');

userModel = require('../server/models/User');

User = require('mongoose').model('User');

users = require('../server/controllers/users');

expect = chai.expect;

chai.should();

describe('Users', function() {
  describe('Create', function() {
    var mockUser, next, req, res;
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
    mockUser = sinon.mock(User);
    beforeEach(function() {
      req.body.username = 'bob@bob.bob';
      return req.body.password = 'qwertyuiop';
    });
    it('Should create a user with valid params', function() {
      var expectation;
      expectation = mockUser.expects('create').once();
      users.createUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to create a user with invalid username', function() {
      var expectation;
      req.body.username = 'bob';
      expectation = mockUser.expects('create').never();
      users.createUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to create a user with too long username', function() {
      var expectation;
      req.body.username = 'bob@bobbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb.bob';
      expectation = mockUser.expects('create').never();
      users.createUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to create a user with too short password', function() {
      var expectation;
      req.body.password = 'bob';
      expectation = mockUser.expects('create').never();
      users.createUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to create a user with too long password', function() {
      var expectation;
      req.body.password = 'bobbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
      expectation = mockUser.expects('create').never();
      users.createUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to create a user with no username', function() {
      var expectation;
      req.body.username = void 0;
      expectation = mockUser.expects('create').never();
      users.createUser(req, res, next);
      return expectation.verify();
    });
    return it('Should fail to create a user with no password', function() {
      var expectation;
      req.body.password = void 0;
      expectation = mockUser.expects('create').never();
      users.createUser(req, res, next);
      return expectation.verify();
    });
  });
  return describe('Update', function() {
    var mockEncrypt, mockUser, next, req, res;
    req = {};
    req.user = {};
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
    mockUser = sinon.mock(User);
    mockEncrypt = sinon.mock(encrypt);
    beforeEach(function() {
      req.user.username = 'bob@bob.bob';
      req.user.password = 'qwertyuiop';
      req.body.oldUsername = 'bob@bob.bob';
      req.body.username = 'bob@bobb.bob';
      return req.body.password = 'qwertyuiop2';
    });
    it('Should update their info with valid params', function() {
      var expectation;
      expectation = mockUser.expects('update').once();
      users.updateUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to update a user with no username', function() {
      var expectation;
      req.body.username = void 0;
      expectation = mockUser.expects('update').never();
      users.updateUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to update a user with invalid username', function() {
      var expectation;
      req.body.username = 'bob';
      expectation = mockUser.expects('update').never();
      users.updateUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to update another user with valid params while not admin', function() {
      var expectation;
      req.body.oldUsername = 'bob@bobb.bob';
      expectation = mockUser.expects('update').never();
      users.updateUser(req, res, next);
      return expectation.verify();
    });
    it('Should update another user with valid params while admin', function() {
      var expectation;
      req.body.oldUsername = 'bob@bobb.bob';
      req.user.roles = ['admin'];
      expectation = mockUser.expects('update').once();
      users.updateUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to update a user with too long username', function() {
      var expectation;
      req.body.username = 'bob@bobbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb.bob';
      expectation = mockUser.expects('update').never();
      users.updateUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to update a user with too short password', function() {
      var expectation;
      req.body.password = 'bob';
      expectation = mockUser.expects('update').never();
      users.updateUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to update a user with too long password', function() {
      var expectation;
      req.body.password = 'bobbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
      expectation = mockUser.expects('update').never();
      users.updateUser(req, res, next);
      return expectation.verify();
    });
    it('Should create an hashed if the password was updated', function() {
      var expectation;
      expectation = mockEncrypt.expects('hashPwd').once();
      mockUser.expects('update');
      users.updateUser(req, res, next);
      return expectation.verify();
    });
    return it('Should not create an hashed if the password was not updated', function() {
      var expectation;
      req.body.password = void 0;
      expectation = mockEncrypt.expects('hashPwd').never();
      mockUser.expects('update');
      users.updateUser(req, res, next);
      return expectation.verify();
    });
  });
});
