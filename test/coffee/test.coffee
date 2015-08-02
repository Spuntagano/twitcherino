chai = require('chai')
expect = chai.expect

chai.should()

isEven = (num) ->
	num % 2 == 0

describe('isEven', ->
	it('should return true when number is even', ->
		isEven(4).should.be.true
	)

	it('should return false when number is odd', ->
		expect(isEven(5)).to.be.false
	)
)