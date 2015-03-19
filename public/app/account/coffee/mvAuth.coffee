angular.module('twitcherinoApp').factory('mvAuth', ($http, mvIdentity, mvNotifier, $q) ->
	authenticateUser: (username, password) ->

		dfd = $q.defer()

		console.log(username)
		$http.post('/login', {username: username, password: password}).then( (response) ->
			if (response.data.success)
				dfd.resolve(true)
				mvIdentity.currentUser = response.data.user;
			else
				dfd.resolve(false)
		)
		dfd.promise
)