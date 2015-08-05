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
  var mockEncrypt, mockUser, next, req, res;
  req = {};
  req.user = {};
  req.body = {};
  req.params = {};
  req.user.roles = [];
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
  describe('Get', function() {
    beforeEach(function() {
      req = {};
      req.user = {};
      req.body = {};
      req.params = {};
      req.user.roles = [];
      req.user.username = 'bob@bob.bob';
      return req.body.username = 'bob@bob.bob';
    });
    it('Should get a user with valid params', function() {
      var expectation;
      expectation = mockUser.expects('find').once();
      users.getUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to get a user while not logged in', function() {
      var expectation;
      req.user = void 0;
      expectation = mockUser.expects('find').never();
      users.getUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to get a user while no user params', function() {
      var expectation;
      req.body.username = void 0;
      expectation = mockUser.expects('find').never();
      users.getUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to get a user info with valid params while not admin', function() {
      var expectation;
      req.body.username = 'bob@bobb.bob';
      expectation = mockUser.expects('find').never();
      users.getUser(req, res, next);
      return expectation.verify();
    });
    return it('Should get another user info with valid params while admin', function() {
      var expectation;
      req.body.username = 'bob@bobb.bob';
      req.user.roles = ['admin'];
      expectation = mockUser.expects('find').once();
      users.getUser(req, res, next);
      return expectation.verify();
    });
  });
  describe('Create', function() {
    beforeEach(function() {
      req = {};
      req.user = {};
      req.body = {};
      req.params = {};
      req.user.roles = [];
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
  describe('Update', function() {
    beforeEach(function() {
      req = {};
      req.user = {};
      req.body = {};
      req.params = {};
      req.user.roles = [];
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
    it('Should fail to update a user while not logged in', function() {
      var expectation;
      req.user = void 0;
      expectation = mockUser.expects('update').never();
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
  describe('Delete', function() {
    beforeEach(function() {
      req = {};
      req.user = {};
      req.body = {};
      req.params = {};
      req.user.roles = [];
      req.user.username = 'bob@bob.bob';
      return req.params.username = 'bob@bob.bob';
    });
    it('Should delete their info with valid params', function() {
      var expectation;
      expectation = mockUser.expects('remove').once();
      users.deleteUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to delete a user while not logged in', function() {
      var expectation;
      req.user = void 0;
      expectation = mockUser.expects('remove').never();
      users.deleteUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to delete a user with no username in params', function() {
      var expectation;
      req.params.username = void 0;
      expectation = mockUser.expects('remove').never();
      users.deleteUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to delete a user with invalid username', function() {
      var expectation;
      req.params.username = 'bob';
      expectation = mockUser.expects('remove').never();
      users.deleteUser(req, res, next);
      return expectation.verify();
    });
    it('Should fail to delete another user with valid params while not admin', function() {
      var expectation;
      req.params.username = 'bob@bobb.bob';
      expectation = mockUser.expects('remove').never();
      users.deleteUser(req, res, next);
      return expectation.verify();
    });
    return it('Should update another user with valid params while admin', function() {
      var expectation;
      req.params.username = 'bob@bobb.bob';
      req.user.roles = ['admin'];
      expectation = mockUser.expects('remove').once();
      users.deleteUser(req, res, next);
      return expectation.verify();
    });
  });
  return describe('Disconect twitch', function() {
    beforeEach(function() {
      req = {};
      req.user = {};
      req.body = {};
      req.params = {};
      req.user.roles = [];
      req.user.username = 'bob@bob.bob';
      return req.params.username = 'bob@bob.bob';
    });
    it('Should disconect with valid params', function() {
      var expectation;
      expectation = mockUser.expects('update').once();
      users.disconnectTwitch(req, res, next);
      return expectation.verify();
    });
    it('Should fail to delete a user while not logged in', function() {
      var expectation;
      req.user = void 0;
      expectation = mockUser.expects('update').never();
      users.disconnectTwitch(req, res, next);
      return expectation.verify();
    });
    it('Should fail to delete a user with no username in params', function() {
      var expectation;
      req.params.username = void 0;
      expectation = mockUser.expects('update').never();
      users.disconnectTwitch(req, res, next);
      return expectation.verify();
    });
    it('Should fail to delete a user with invalid username', function() {
      var expectation;
      req.params.username = 'bob';
      expectation = mockUser.expects('update').never();
      users.disconnectTwitch(req, res, next);
      return expectation.verify();
    });
    it('Should fail to delete another user with valid params while not admin', function() {
      var expectation;
      req.params.username = 'bob@bobb.bob';
      expectation = mockUser.expects('update').never();
      users.disconnectTwitch(req, res, next);
      return expectation.verify();
    });
    return it('Should update another user with valid params while admin', function() {
      var expectation;
      req.params.username = 'bob@bobb.bob';
      req.user.roles = ['admin'];
      expectation = mockUser.expects('update').once();
      users.disconnectTwitch(req, res, next);
      return expectation.verify();
    });
  });
});
