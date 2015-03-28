angular.module('twitcherinoApp').factory('mvAuth', ['$http', 'mvUser', 'mvIdentity', '$q', ($http, mvUser, mvIdentity, $q) ->
	authenticateUser: (username, password) ->

		dfd = $q.defer()

		$http.post('/login', {username: username, password: password}).then( (response) ->
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

	logoutUser: ->
		dfd = $q.defer()
		$http.post('/logout', {logout: true}).then( -> 
			mvIdentity.currentUser = undefined
			dfd.resolve()
		)
		dfd.promise

	authorizedCurrentUserForRoute: (role) ->
		if (mvIdentity.isAuthorized(role))
			true
		else
			$q.reject('Not authorized')
])