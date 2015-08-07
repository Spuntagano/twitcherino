chai = require('chai')
sinon = require('sinon')
mongoose = require('mongoose')
userModel = require('../server/models/User')
User = require('mongoose').model('User')
follow = require('../server/controllers/follow')
expect = chai.expect

chai.should()

describe('Follow', ->

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

	describe('Add', ->

		beforeEach( ->

			mockUser = sinon.mock(User)

			req = {}
			req.user = {}
			req.body = {}
			req.params = {}

			req.user.roles = []

			req.user.username = 'bob@bob.bob'

			req.body.platform = 'twitch'
			req.body.channelTitle = 'destiny' #senpaiiii
		)

		afterEach (->
			mockUser.restore()
		)

		it('Should add a follow with valid params', ->

			expectation = mockUser.expects('update').once()

			follow.addFollow(req, res, next)
			expectation.verify()
		)

		it('Should fail to add a follow while not logged in', ->
			req.user = undefined

			expectation = mockUser.expects('update').never()

			follow.addFollow(req, res, next)
			expectation.verify()
		)

		it('Should fail to add a follow with no platform params', ->
			req.body.platform = undefined

			expectation = mockUser.expects('update').never()

			follow.addFollow(req, res, next)
			expectation.verify()
		)

		it('Should fail to add a follow with invalid platform', ->
			req.body.platform = 'swagster'

			expectation = mockUser.expects('update').never()

			follow.addFollow(req, res, next)
			expectation.verify()
		)

		it('Should fail to add a follow with no channel title', ->
			req.body.channelTitle = undefined

			expectation = mockUser.expects('update').never()

			follow.addFollow(req, res, next)
			expectation.verify()
		)

		it('Should fail to add a follow with invalid channel title', ->
			req.body.channelTitle = '^¸432'

			expectation = mockUser.expects('update').never()

			follow.addFollow(req, res, next)
			expectation.verify()
		)
	)

	describe('Remove', ->

		beforeEach( ->

			mockUser = sinon.mock(User)

			req = {}
			req.user = {}
			req.body = {}
			req.params = {}

			req.user.roles = []

			req.user.username = 'bob@bob.bob'

			req.body.platform = 'twitch'
			req.body.channelTitle = 'destiny'
		)

		afterEach (->
			mockUser.restore()
		)

		it('Should remove a follow with valid params', ->

			expectation = mockUser.expects('update').once()

			follow.removeFollow(req, res, next)
			expectation.verify()
		)

		it('Should fail to remove a follow while not logged in', ->
			req.user = undefined

			expectation = mockUser.expects('update').never()

			follow.removeFollow(req, res, next)
			expectation.verify()
		)

		it('Should fail to remove a follow with no platform params', ->
			req.body.platform = undefined

			expectation = mockUser.expects('update').never()

			follow.removeFollow(req, res, next)
			expectation.verify()
		)

		it('Should fail to remove a follow with invalid platform', ->
			req.body.platform = 'swagster'

			expectation = mockUser.expects('update').never()

			follow.removeFollow(req, res, next)
			expectation.verify()
		)

		it('Should fail to remove a follow with no channel title', ->
			req.body.channelTitle = undefined

			expectation = mockUser.expects('update').never()

			follow.removeFollow(req, res, next)
			expectation.verify()
		)

		it('Should fail to remove a follow with invalid channel title', ->
			req.body.channelTitle = '^¸432'

			expectation = mockUser.expects('update').never()

			follow.removeFollow(req, res, next)
			expectation.verify()
		)
	)

	describe('Import', ->

		beforeEach( ->

			mockUser = sinon.mock(User)

			req = {}
			req.user = {}
			req.body = {}
			req.params = {}

			req.user.roles = []

			req.user.username = 'bob@bob.bob'

			req.body.platform = 'twitch'
			req.body.channels = ['destiny', 'kripp', 'alisha12287']
		)

		afterEach (->
			mockUser.restore()
		)

		it('Should import follows with valid params', ->

			expectation = mockUser.expects('update').once()

			follow.importFollows(req, res, next)
			expectation.verify()
		)

		it('Should fail to import follows while not logged in', ->
			req.user = undefined

			expectation = mockUser.expects('update').never()

			follow.importFollows(req, res, next)
			expectation.verify()
		)

		it('Should fail to import follows with no platform', ->
			req.body.platform = undefined

			expectation = mockUser.expects('update').never()

			follow.importFollows(req, res, next)
			expectation.verify()
		)

		it('Should fail to remove a follow with no channel params', ->
			req.body.channels = undefined

			expectation = mockUser.expects('update').never()

			follow.importFollows(req, res, next)
			expectation.verify()
		)

		it('Should fail to remove a follow with invalid channel', ->
			req.body.channels = ['dsad', 'dsad^¸;`;', 'das']

			expectation = mockUser.expects('update').never()

			follow.importFollows(req, res, next)
			expectation.verify()
		)

		it('Should fail to remove a follow with invalid platform', ->
			req.body.platform = 'dsad'

			expectation = mockUser.expects('update').never()

			follow.importFollows(req, res, next)
			expectation.verify()
		)

	)

)