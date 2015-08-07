angular.module('twitcherinoApp').factory('mvAuth', ['$http', 'mvUser', 'mvIdentity', '$q', '$location', ($http, mvUser, mvIdentity, $q, $location) ->

	authenticateUser: (username, password) ->

		dfd = $q.defer()

		$http.post("/login", {username: username, password: password}).then( (response) ->
			if (response.data.success)
				user = new mvUser()
				angular.extend(user, response.data.user)
				mvIdentity.currentUser = user
				dfd.resolve()
			else
				dfd.reject(response.data.reason)
		)
		dfd.promise

	getUser: (user) ->
		user = new mvUser(user)

		dfd = $q.defer()
		user.$get({id: user.username}).then( (response) ->
			angular.extend(mvIdentity.currentUser, response)
			mvIdentity.currentUser.twitchFollows = response.twitchFollows
			mvIdentity.currentUser.hitboxFollows = response.hitboxFollows
			mvIdentity.currentUser.azubuFollows = response.azubuFollows
			dfd.resolve()
		(response) ->
			dfd.reject(response.data.reason)
		)

	createUser: (newUserData) ->
		newUser = new mvUser(newUserData)
		dfd = $q.defer()

		newUser.$save().then( ->
			mvIdentity.currentUser = newUserData
			dfd.resolve()
		(response) ->
			dfd.reject(response.data.reason)
		)

		dfd.promise

	deleteUser: (user) ->
		dfd = $q.defer()
		user.$remove({id: user.username}).then( ->
			mvIdentity.currentUser = undefined
			dfd.resolve()
			$location.path('/')
		(response) ->
			dfd.reject(response.data.reason)
		)

	disconectTwitch: (username) ->
		dfd = $q.defer()
		$http.delete("/api/user/twitch/#{username}").then( -> 
			mvIdentity.currentUser.twitchtvUsername = undefined
			mvIdentity.currentUser.twitchtvAccessToken = undefined
			mvIdentity.currentUser.twitchtvRefreshToken = undefined
			dfd.resolve()
		)

	updateCurrentUser: (newUserData) ->
		dfd = $q.defer()
		clone = angular.copy(mvIdentity.currentUser)
		angular.extend(clone, newUserData)
		newClone = new mvUser(clone)
		newClone.$update().then( ->
			mvIdentity.currentUser = newClone
			dfd.resolve()
		(response) ->
			dfd.reject(response.data.reason)
		)
		dfd.promise

	logoutUser: ->
		dfd = $q.defer()
		$http.post("/logout", {logout: true}).then( -> 
			mvIdentity.currentUser = undefined
			dfd.resolve()
		)
		dfd.promise

	authorizedCurrentUserForRoute: (role) ->
		if (mvIdentity.isAuthorized(role))
			true
		else
			$q.reject('Not authorized')

	authorizedCurrentUserForRoute: ->
		if (mvIdentity.isAuthenticated())
			true
		else
			$q.reject('Not authorized')
])