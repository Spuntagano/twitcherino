chai = require('chai')
sinon = require('sinon')
encrypt = require('../server/utilities/encryption')
userModel = require('../server/models/User')
User = require('mongoose').model('User')
users = require('../server/controllers/users')
expect = chai.expect

chai.should()

describe('Users', ->

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

	mockUser = sinon.mock(User)
	mockEncrypt = sinon.mock(encrypt)

	describe('Get', ->

		beforeEach( ->
			req = {}
			req.user = {}
			req.body = {}
			req.params = {}

			req.user.roles = []

			req.user.username = 'bob@bob.bob'
			req.body.username = 'bob@bob.bob'
		)

		it('Should get a user with valid params', ->

			expectation = mockUser.expects('find').once()

			users.getUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to get a user while not logged in', ->
			req.user = undefined

			expectation = mockUser.expects('find').never()

			users.getUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to get a user while no user params', ->
			req.body.username = undefined

			expectation = mockUser.expects('find').never()

			users.getUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to get a user info with valid params while not admin', ->
			req.body.username = 'bob@bobb.bob'

			expectation = mockUser.expects('find').never()

			users.getUser(req, res, next)
			expectation.verify()
		)

		it('Should get another user info with valid params while admin', ->
			req.body.username = 'bob@bobb.bob'
			req.user.roles = ['admin']

			expectation = mockUser.expects('find').once()

			users.getUser(req, res, next)
			expectation.verify()
		)
	)

	describe('Create', ->

		beforeEach( ->

			req = {}
			req.user = {}
			req.body = {}
			req.params = {}

			req.user.roles = []

			req.body.username = 'bob@bob.bob'
			req.body.password = 'qwertyuiop'
		)

		it('Should create a user with valid params', ->

			expectation = mockUser.expects('create').once()

			users.createUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to create a user with invalid username', ->
			req.body.username = 'bob'

			expectation = mockUser.expects('create').never()

			users.createUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to create a user with too long username', ->
			req.body.username = 'bob@bobbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb.bob'

			expectation = mockUser.expects('create').never()

			users.createUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to create a user with too short password', ->
			req.body.password = 'bob'

			expectation = mockUser.expects('create').never()

			users.createUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to create a user with too long password', ->
			req.body.password = 'bobbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'

			expectation = mockUser.expects('create').never()

			users.createUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to create a user with no username', ->
			req.body.username = undefined

			expectation = mockUser.expects('create').never()

			users.createUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to create a user with no password', ->
			req.body.password = undefined

			expectation = mockUser.expects('create').never()

			users.createUser(req, res, next)
			expectation.verify()
		)
	)

	describe('Update', ->

		beforeEach( ->

			req = {}
			req.user = {}
			req.body = {}
			req.params = {}

			req.user.roles = []

			req.user.username = 'bob@bob.bob'
			req.user.password = 'qwertyuiop'

			req.body.oldUsername = 'bob@bob.bob'
			req.body.username = 'bob@bobb.bob'
			req.body.password = 'qwertyuiop2'
		)

		it('Should update their info with valid params', ->

			expectation = mockUser.expects('update').once()

			users.updateUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to update a user while not logged in', ->
			req.user = undefined

			expectation = mockUser.expects('update').never()

			users.updateUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to update a user with no username', ->
			req.body.username = undefined

			expectation = mockUser.expects('update').never()

			users.updateUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to update a user with invalid username', ->
			req.body.username = 'bob'

			expectation = mockUser.expects('update').never()

			users.updateUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to update another user with valid params while not admin', ->
			req.body.oldUsername = 'bob@bobb.bob'

			expectation = mockUser.expects('update').never()

			users.updateUser(req, res, next)
			expectation.verify()
		)

		it('Should update another user with valid params while admin', ->
			req.body.oldUsername = 'bob@bobb.bob'
			req.user.roles = ['admin']

			expectation = mockUser.expects('update').once()

			users.updateUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to update a user with too long username', ->
			req.body.username = 'bob@bobbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb.bob'

			expectation = mockUser.expects('update').never()

			users.updateUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to update a user with too short password', ->
			req.body.password = 'bob'

			expectation = mockUser.expects('update').never()

			users.updateUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to update a user with too long password', ->
			req.body.password = 'bobbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'

			expectation = mockUser.expects('update').never()

			users.updateUser(req, res, next)
			expectation.verify()
		)

		it('Should create an hashed if the password was updated', ->
			expectation = mockEncrypt.expects('hashPwd').once()
			mockUser.expects('update')

			users.updateUser(req, res, next)
			expectation.verify()

		)

		it('Should not create an hashed if the password was not updated', ->
			req.body.password = undefined

			expectation = mockEncrypt.expects('hashPwd').never()
			mockUser.expects('update')

			users.updateUser(req, res, next)
			expectation.verify()
		)
	)

	describe('Delete', ->

		beforeEach( ->

			req = {}
			req.user = {}
			req.body = {}
			req.params = {}

			req.user.roles = []

			req.user.username = 'bob@bob.bob'

			req.params.username = 'bob@bob.bob'
		)

		it('Should delete their info with valid params', ->

			expectation = mockUser.expects('remove').once()

			users.deleteUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to delete a user while not logged in', ->
			req.user = undefined

			expectation = mockUser.expects('remove').never()

			users.deleteUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to delete a user with no username in params', ->
			req.params.username = undefined

			expectation = mockUser.expects('remove').never()

			users.deleteUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to delete a user with invalid username', ->
			req.params.username = 'bob'

			expectation = mockUser.expects('remove').never()

			users.deleteUser(req, res, next)
			expectation.verify()
		)

		it('Should fail to delete another user with valid params while not admin', ->
			req.params.username = 'bob@bobb.bob'

			expectation = mockUser.expects('remove').never()

			users.deleteUser(req, res, next)
			expectation.verify()
		)

		it('Should update another user with valid params while admin', ->
			req.params.username = 'bob@bobb.bob'
			req.user.roles = ['admin']

			expectation = mockUser.expects('remove').once()

			users.deleteUser(req, res, next)
			expectation.verify()
		)
	)

	describe('Disconect twitch', ->

		beforeEach( ->

			req = {}
			req.user = {}
			req.body = {}
			req.params = {}

			req.user.roles = []

			req.user.username = 'bob@bob.bob'

			req.params.username = 'bob@bob.bob'
		)

		it('Should disconect with valid params', ->

			expectation = mockUser.expects('update').once()

			users.disconnectTwitch(req, res, next)
			expectation.verify()
		)

		it('Should fail to delete a user while not logged in', ->
			req.user = undefined

			expectation = mockUser.expects('update').never()

			users.disconnectTwitch(req, res, next)
			expectation.verify()
		)

		it('Should fail to delete a user with no username in params', ->
			req.params.username = undefined

			expectation = mockUser.expects('update').never()

			users.disconnectTwitch(req, res, next)
			expectation.verify()
		)

		it('Should fail to delete a user with invalid username', ->
			req.params.username = 'bob'

			expectation = mockUser.expects('update').never()

			users.disconnectTwitch(req, res, next)
			expectation.verify()
		)

		it('Should fail to delete another user with valid params while not admin', ->
			req.params.username = 'bob@bobb.bob'

			expectation = mockUser.expects('update').never()

			users.disconnectTwitch(req, res, next)
			expectation.verify()
		)

		it('Should update another user with valid params while admin', ->
			req.params.username = 'bob@bobb.bob'
			req.user.roles = ['admin']

			expectation = mockUser.expects('update').once()

			users.disconnectTwitch(req, res, next)
			expectation.verify()
		)
	)
)