var auth, chai, expect, passport, sinon;

chai = require('chai');

sinon = require('sinon');

auth = require('../server/config/auth');

passport = require('passport');

expect = chai.expect;

chai.should();

describe('Auth', function() {
  var mockPassport, next, req, res;
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
  mockPassport = sinon.mock(passport);
  return describe('Authenticate', function() {
    beforeEach(function() {
      req = {};
      req.user = {};
      req.body = {};
      req.params = {};
      req.user.roles = [];
      req.body.username = 'bob@bob.bob';
      return req.body.password = 'qwertyuiop';
    });
    it('Should fail to get a user with no username params', function() {
      var expectation;
      req.body.username = void 0;
      expectation = mockPassport.expects('authenticate').never();
      auth.authenticate(req, res, next);
      return expectation.verify();
    });
    return it('Should fail to get a user with no password params', function() {
      var expectation;
      req.body.password = void 0;
      expectation = mockPassport.expects('authenticate').never();
      auth.authenticate(req, res, next);
      return expectation.verify();
    });
  });
});
