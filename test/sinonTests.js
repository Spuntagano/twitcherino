var chai, expect, sinon;

chai = require('chai');

sinon = require('sinon');

expect = chai.expect;

chai.should();

describe('sinon tests', function() {
  var schedule, student;
  student = {};
  schedule = {};
  beforeEach(function() {
    student = {
      dropClass: function(classId, cb) {
        if (!!cb.dropClass) {
          return cb.dropClass();
        } else {
          return cb();
        }
      },
      addClass: function(schedule) {
        if (!schedule.classIsFull()) {
          return true;
        } else {
          return false;
        }
      }
    };
    return schedule = {
      dropClass: function() {
        return console.log('class dropped');
      },
      classIsFull: function() {
        return true;
      }
    };
  });
  describe('student.dropClass', function() {
    it('should call the callback', function() {
      var spy;
      spy = sinon.spy();
      student.dropClass(1, spy);
      return spy.called.should.be["true"];
    });
    it('should call the callback', function() {
      var onClassDropped, spy;
      onClassDropped = function() {
        return console.log('onClassDropped was called');
      };
      spy = sinon.spy(onClassDropped);
      student.dropClass(1, spy);
      return spy.called.should.be["true"];
    });
    return it('should call the callback even if it\'s a method of an object', function() {
      sinon.spy(schedule, 'dropClass');
      student.dropClass(1, schedule);
      return schedule.dropClass.called.should.be["true"];
    });
  });
  describe('sinon with stubs', function() {
    it('should call a stubbed method', function() {
      var stub;
      stub = sinon.stub(schedule);
      return student.dropClass(1, stub.dropClass);
    });
    return it('should return true when the class is not full', function() {
      var returnVal, stub;
      stub = sinon.stub(schedule);
      stub.classIsFull.returns(false);
      returnVal = student.addClass(schedule);
      return returnVal.should.be["true"];
    });
  });
  return describe('sinon with mocks', function() {
    return it('mocks schedule', function() {
      var expectation, mockObj;
      mockObj = sinon.mock(schedule);
      expectation = mockObj.expects('classIsFull').once();
      student.addClass(schedule);
      return expectation.verify();
    });
  });
});
