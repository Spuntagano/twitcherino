var User, chai, expect, follow, mongoose, sinon, userModel;

chai = require('chai');

sinon = require('sinon');

mongoose = require('mongoose');

userModel = require('../server/models/User');

User = require('mongoose').model('User');

follow = require('../server/controllers/follow');

expect = chai.expect;

chai.should();

describe('Follow', function() {
  var mockUser, next, req, res;
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
  describe('Add', function() {
    beforeEach(function() {
      mockUser = sinon.mock(User);
      req = {};
      req.user = {};
      req.body = {};
      req.params = {};
      req.user.roles = [];
      req.user.username = 'bob@bob.bob';
      req.body.platform = 'twitch';
      return req.body.channelTitle = 'destiny';
    });
    afterEach((function() {
      return mockUser.restore();
    }));
    it('Should add a follow with valid params', function() {
      var expectation;
      expectation = mockUser.expects('update').once();
      follow.addFollow(req, res, next);
      return expectation.verify();
    });
    it('Should fail to add a follow while not logged in', function() {
      var expectation;
      req.user = void 0;
      expectation = mockUser.expects('update').never();
      follow.addFollow(req, res, next);
      return expectation.verify();
    });
    it('Should fail to add a follow with no platform params', function() {
      var expectation;
      req.body.platform = void 0;
      expectation = mockUser.expects('update').never();
      follow.addFollow(req, res, next);
      return expectation.verify();
    });
    it('Should fail to add a follow with invalid platform', function() {
      var expectation;
      req.body.platform = 'swagster';
      expectation = mockUser.expects('update').never();
      follow.addFollow(req, res, next);
      return expectation.verify();
    });
    it('Should fail to add a follow with no channel title', function() {
      var expectation;
      req.body.channelTitle = void 0;
      expectation = mockUser.expects('update').never();
      follow.addFollow(req, res, next);
      return expectation.verify();
    });
    return it('Should fail to add a follow with invalid channel title', function() {
      var expectation;
      req.body.channelTitle = '^¸432';
      expectation = mockUser.expects('update').never();
      follow.addFollow(req, res, next);
      return expectation.verify();
    });
  });
  describe('Remove', function() {
    beforeEach(function() {
      mockUser = sinon.mock(User);
      req = {};
      req.user = {};
      req.body = {};
      req.params = {};
      req.user.roles = [];
      req.user.username = 'bob@bob.bob';
      req.body.platform = 'twitch';
      return req.body.channelTitle = 'destiny';
    });
    afterEach((function() {
      return mockUser.restore();
    }));
    it('Should remove a follow with valid params', function() {
      var expectation;
      expectation = mockUser.expects('update').once();
      follow.removeFollow(req, res, next);
      return expectation.verify();
    });
    it('Should fail to remove a follow while not logged in', function() {
      var expectation;
      req.user = void 0;
      expectation = mockUser.expects('update').never();
      follow.removeFollow(req, res, next);
      return expectation.verify();
    });
    it('Should fail to remove a follow with no platform params', function() {
      var expectation;
      req.body.platform = void 0;
      expectation = mockUser.expects('update').never();
      follow.removeFollow(req, res, next);
      return expectation.verify();
    });
    it('Should fail to remove a follow with invalid platform', function() {
      var expectation;
      req.body.platform = 'swagster';
      expectation = mockUser.expects('update').never();
      follow.removeFollow(req, res, next);
      return expectation.verify();
    });
    it('Should fail to remove a follow with no channel title', function() {
      var expectation;
      req.body.channelTitle = void 0;
      expectation = mockUser.expects('update').never();
      follow.removeFollow(req, res, next);
      return expectation.verify();
    });
    return it('Should fail to remove a follow with invalid channel title', function() {
      var expectation;
      req.body.channelTitle = '^¸432';
      expectation = mockUser.expects('update').never();
      follow.removeFollow(req, res, next);
      return expectation.verify();
    });
  });
  describe('Twitch import', function() {
    beforeEach(function() {
      mockUser = sinon.mock(User);
      req = {};
      req.user = {};
      req.body = {};
      req.params = {};
      req.user.roles = [];
      req.user.username = 'bob@bob.bob';
      return req.body.channels = ['destiny', 'kripp', 'alisha12287'];
    });
    afterEach((function() {
      return mockUser.restore();
    }));
    it('Should import follows with valid params', function() {
      var expectation;
      expectation = mockUser.expects('update').once();
      follow.importTwitchFollows(req, res, next);
      return expectation.verify();
    });
    it('Should fail to import follows while not logged in', function() {
      var expectation;
      req.user = void 0;
      expectation = mockUser.expects('update').never();
      follow.importTwitchFollows(req, res, next);
      return expectation.verify();
    });
    it('Should fail to remove a follow with no channel params', function() {
      var expectation;
      req.body.channels = void 0;
      expectation = mockUser.expects('update').never();
      follow.importTwitchFollows(req, res, next);
      return expectation.verify();
    });
    return it('Should fail to remove a follow with invalid platform', function() {
      var expectation;
      req.body.channels = ['dsad', 'dsad^¸;`;', 'das'];
      expectation = mockUser.expects('update').never();
      follow.importTwitchFollows(req, res, next);
      return expectation.verify();
    });
  });
  return describe('Hitbox import', function() {
    beforeEach(function() {
      mockUser = sinon.mock(User);
      req = {};
      req.user = {};
      req.body = {};
      req.params = {};
      req.user.roles = [];
      req.user.username = 'bob@bob.bob';
      return req.body.channels = ['destiny', 'kripp', 'alisha12287'];
    });
    afterEach((function() {
      return mockUser.restore();
    }));
    it('Should import follows with valid params', function() {
      var expectation;
      expectation = mockUser.expects('update').once();
      follow.importHitboxFollows(req, res, next);
      return expectation.verify();
    });
    it('Should fail to import follows while not logged in', function() {
      var expectation;
      req.user = void 0;
      expectation = mockUser.expects('update').never();
      follow.importHitboxFollows(req, res, next);
      return expectation.verify();
    });
    it('Should fail to remove a follow with no channel params', function() {
      var expectation;
      req.body.channels = void 0;
      expectation = mockUser.expects('update').never();
      follow.importHitboxFollows(req, res, next);
      return expectation.verify();
    });
    return it('Should fail to remove a follow with invalid platform', function() {
      var expectation;
      req.body.channels = ['dsad', 'dsad^¸;`;', 'das'];
      expectation = mockUser.expects('update').never();
      follow.importHitboxFollows(req, res, next);
      return expectation.verify();
    });
  });
});
