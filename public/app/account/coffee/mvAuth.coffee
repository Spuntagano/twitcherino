angular.module('twitcherinoApp').factory('mvAuth', ['$http', 'mvUser', 'mvIdentity', '$q', '$location', ($http, mvUser, mvIdentity, $q, $location) ->

	authenticateUser: (username, password) ->

		dfd = $q.defer()

		$http.post("/login", {username: username, password: password}).then( (response) ->
			if (response.data.success)
				user = new mvUser()
				angular.extend(user, response.data.user)
				mvIdentity.currentUser = user
				dfd.resolve(true)
				mvIdentity.currentUser = response.data.user;
			else
				dfd.resolve(false)
		)
		dfd.promise

	createUser: (newUserData) ->
		newUser = new mvUser(newUserData)
		dfd = $q.defer()

		newUser.$save().then( ->
			mvIdentity.currentUser = newUser
			dfd.resolve()
		(response) ->
			dfd.reject(response.data.reason)
		)

		dfd.promise

	deleteUser: (username) ->
		dfd = $q.defer()
		$http.delete("/api/user/#{username}").then( -> 
			mvIdentity.currentUser = undefined
			dfd.resolve()
			$location.path('/')
		)

	disconectTwitch: (username) ->
		dfd = $q.defer()
		$http.delete("/api/user/twitch/#{username}").then( -> 
			if (mvIdentity.currentUser.twitchtvUsername)
				mvIdentity.currentUser.twitchtvUsername = undefined

			if (mvIdentity.currentUser.twitchtvAccessToken)
				mvIdentity.currentUser.twitchtvAccessToken = undefined

			if (mvIdentity.currentUser.twitchtvRefreshToken)
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
			if (mvIdentity.currentUser.hashed_pwd)
				mvIdentity.currentUser.has_pw = true
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