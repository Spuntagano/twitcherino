chai = require('chai')
sinon = require('sinon')
auth = require('../server/config/auth')
passport = require('passport')

expect = chai.expect

chai.should()

describe('Auth', ->

	req = {}
	req.user = {}
	req.body = {}
	req.params = {}

	req.user.roles = []

	res = {
		status: ->
			true

		send: ->
			true

		end: ->
			true
	}
	
	next = ->
		true

	mockPassport = sinon.mock(passport)

	describe('Authenticate', ->

		beforeEach( ->
			req = {}
			req.user = {}
			req.body = {}
			req.params = {}

			req.user.roles = []

			req.body.username = 'bob@bob.bob'
			req.body.password = 'qwertyuiop'
		)

		it('Should fail to get a user with no username params', ->
			req.body.username = undefined

			expectation = mockPassport.expects('authenticate').never()

			auth.authenticate(req, res, next)
			expectation.verify()
		)

		it('Should fail to get a user with no password params', ->
			req.body.password = undefined

			expectation = mockPassport.expects('authenticate').never()

			auth.authenticate(req, res, next)
			expectation.verify()
		)

	)
)