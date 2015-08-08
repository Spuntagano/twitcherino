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
		dfd = $q.defer()
		username = user.username
		user = new mvUser(user)
		user.$get({id: username}).then( (response) ->
			if (response.username)
				angular.extend(mvIdentity.currentUser, response)
				mvIdentity.currentUser.follows = response.follows
				mvIdentity.currentUser.twitchtvUsername = response.twitchtvUsername
				dfd.resolve()
			else
				dfd.reject(response.reason)
		)
		dfd.promise

	createUser: (newUserData) ->
		dfd = $q.defer()
		newUser = new mvUser(newUserData)
		newUser.$save().then( (response) ->
			if (response.success)
				mvIdentity.currentUser = newUserData
				dfd.resolve()
			else
				dfd.reject(response.reason)
		)
		dfd.promise

	deleteUser: (user) ->
		dfd = $q.defer()
		user.$remove({id: user.username}).then( (response) ->
			if (response.success)
				mvIdentity.currentUser = undefined
				dfd.resolve()
				$location.path('/')
			else
				dfd.reject(response.reason)
		)
		dfd.promise

	disconectTwitch: (username) ->
		dfd = $q.defer()
		$http.delete("/api/user/twitch/#{username}").then( (response) -> 
			if (response.data.success)
				mvIdentity.currentUser.twitchtvUsername = undefined
				mvIdentity.currentUser.twitchtvAccessToken = undefined
				mvIdentity.currentUser.twitchtvRefreshToken = undefined
				dfd.resolve()
			else
				dfd.reject(response.data.reason)
		)
		dfd.promise

	updateCurrentUser: (newUserData) ->
		dfd = $q.defer()
		clone = angular.copy(mvIdentity.currentUser)
		angular.extend(clone, newUserData)
		newClone = new mvUser(clone)
		newClone.$update().then( (response) ->
			if (response.success)
				mvIdentity.currentUser = clone
				dfd.resolve()
			else
				dfd.reject(response.reason)
		)
		dfd.promise

	logoutUser: ->
		dfd = $q.defer()
		$http.post("/logout", {logout: true}).then( (response) ->
			if (response.data.success)
				mvIdentity.currentUser = undefined
				dfd.resolve()
			else
				dfd.reject('Failed to logout')
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