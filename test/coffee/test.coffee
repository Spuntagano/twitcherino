chai = require('chai')
sinon = require('sinon')
validator = require('validator')
userModel = require('../server/models/User')
User = require('mongoose').model('User')
users = require('../server/controllers/users')
expect = chai.expect

chai.should()

describe('Users', ->

	user = {}

	req = {}
	req.body = {}

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

	beforeEach( ->
		req.body.username = 'bob'
		req.body.password = 'qwertyuiop'
		req.body.email = 'bob@bob.bob'
	)

	it('Should create a user', ->
		stub = sinon.stub(User)
		stub.Create.returns(true)

		users.createUser(req, res, next)

		sinon.assert.called(user.Create)
	)
)