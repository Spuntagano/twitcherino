chai = require('chai')
sinon = require('sinon')
expect = chai.expect

chai.should()

describe('sinon tests', ->

	student = {}
	schedule = {}

	beforeEach( ->
		student =
			dropClass: (classId, cb) ->
				if (!!cb.dropClass)
					cb.dropClass()
				else
					cb()

			addClass: (schedule) ->
				if (!schedule.classIsFull())
					true
				else
					false

		schedule =
			dropClass: ->
				console.log('class dropped')
			classIsFull: ->
				true

	)

	describe('student.dropClass', ->
		it('should call the callback', ->
			spy = sinon.spy()

			student.dropClass(1, spy)
			spy.called.should.be.true
		)

		it('should call the callback', ->
			onClassDropped = ->
				console.log('onClassDropped was called')

			spy = sinon.spy(onClassDropped)

			student.dropClass(1, spy)
			spy.called.should.be.true
		)

		it('should call the callback even if it\'s a method of an object', ->
			sinon.spy(schedule, 'dropClass')
			student.dropClass(1, schedule)
			schedule.dropClass.called.should.be.true
		)
	)

	describe('sinon with stubs', ->
		it('should call a stubbed method', ->
			stub = sinon.stub(schedule)
			student.dropClass(1, stub.dropClass)
		)

		it('should return true when the class is not full', ->
			stub = sinon.stub(schedule)
			stub.classIsFull.returns(false)

			returnVal = student.addClass(schedule)
			returnVal.should.be.true
		)
	)

	describe('sinon with mocks', ->
		it('mocks schedule', ->
			mockObj = sinon.mock(schedule)
			expectation = mockObj.expects('classIsFull').once()

			student.addClass(schedule)
			expectation.verify()
		)
	)
)