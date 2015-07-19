angular.module('twitcherinoApp').factory('mvAuth', ['$http', 'mvUser', 'mvIdentity', '$q', ($http, mvUser, mvIdentity, $q) ->
	authenticateUser: (username, password) ->

		dfd = $q.defer()

		$http.post("#{window.urls.httpBaseUrl}/login", {username: username, password: password}).then( (response) ->
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
		$http.post("#{window.urls.httpBaseUrl}/logout", {logout: true}).then( -> 
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