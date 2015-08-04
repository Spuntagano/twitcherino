chai = require('chai')
sinon = require('sinon')
userModel = require('../server/models/User')
User = require('mongoose').model('User')
users = require('../server/controllers/users')
expect = chai.expect

chai.should()

describe('Users', ->
	describe('Create users', ->

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

		mockObj = sinon.mock(User)

		beforeEach( ->
			req.body.username = 'bob@bob.bob'
			req.body.password = 'qwertyuiop'
		)

		it('Should create a user with valid params', ->

			expectation = mockObj.expects('create').once()

			users.createUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to create a user with invalid username', ->
			req.body.username = 'bob'

			expectation = mockObj.expects('create').never()

			users.createUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to create a user with too long username', ->
			req.body.username = 'bob@bobbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb.bob'

			expectation = mockObj.expects('create').never()

			users.createUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to create a user with too short password', ->
			req.body.password = 'bob'

			expectation = mockObj.expects('create').never()

			users.createUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to create a user with too long password', ->
			req.body.password = 'bobbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'

			expectation = mockObj.expects('create').never()

			users.createUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to create a user with no username', ->
			req.body.username = undefined

			expectation = mockObj.expects('create').never()

			users.createUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to create a user with no password', ->
			req.body.password = undefined

			expectation = mockObj.expects('create').never()

			users.createUser(req, res, next)
			expectation.verify()
		)
	)

	describe('Create users', ->

		req = {}
		req.user = {}
		req.body = {}

		req.user.hasRole = (role) ->
			if (req.user.roles)
				if (req.user.roles.indexOf(role))
					true

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

		mockObj = sinon.mock(User)

		beforeEach( ->
			req.user.username = 'bob@bob.bob'
			req.user.password = 'qwertyuiop'

			req.body.username = 'bob@bob.bob'
			req.body.password = 'qwertyuiop2'
		)

		it('Should update their info with valid params', ->

			expectation = mockObj.expects('update').once()

			users.updateUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to update another user with valid params while not admin', ->
			req.body.username = 'bob@bobb.bob'

			expectation = mockObj.expects('update').never()

			users.updateUser(req, res, next)
			expectation.verify()
		)
	)
)