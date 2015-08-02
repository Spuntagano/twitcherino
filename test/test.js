var chai, expect, isEven;

chai = require('chai');

expect = chai.expect;

chai.should();

isEven = function(num) {
  return num % 2 === 0;
};

describe('isEven', function() {
  it('should return true when number is even', function() {
    return isEven(4).should.be["true"];
  });
  return it('should return false when number is odd', function() {
    return expect(isEven(5)).to.be["false"];
  });
});
