angular.module('twitcherinoApp').controller('LoginCtrl', ['$scope', '$location', '$http', 'mvNotifier', 'mvIdentity', 'mvAuth'
	($scope, $location, $http, mvNotifier, mvIdentity, mvAuth) ->

		if (mvIdentity.isAuthenticated())
			$location.path('/profile')

		# local registration
		###
		$scope.signin = (username, password) ->
			mvAuth.authenticateUser(username, password).then( (success) ->
				if (success)
					mvNotifier.notify('Welcome')
					$location.path('/profile')
				else
					mvNotifier.error('Invalid login')
			)
		###

])