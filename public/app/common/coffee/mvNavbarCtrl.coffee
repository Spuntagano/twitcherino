angular.module('twitcherinoApp').controller('NavigationCtrl', ['$scope', '$location', '$http', 'mvIdentity', 'mvNotifier', 'mvAuth', 'mvUser'
	($scope, $location, $http, mvIdentity, mvNotifier, mvAuth, mvUser) ->

		$scope.identity = mvIdentity

		$scope.isActive = (viewLocation) ->
			$location.path().startsWith(viewLocation)

		$scope.signin = (username, password) ->
			mvAuth.authenticateUser(username, password).then( (success) ->
				if (success)
					mvNotifier.notify('Welcome')
					$location.path('/profile')
				else
					mvNotifier.error('Invalid login')
			)

		$scope.signout = ->
			mvAuth.logoutUser().then( ->
				$scope.username = ""
				$scope.password = ""
				mvNotifier.notify('Bye')
				$location.path('/')
			)

		$scope.isAuthenticated = mvIdentity.isAuthenticated()

		if (errorMessage? && errorMessage)
			mvNotifier.error(errorMessage)

		if (infoMessage? && infoMessage)
			mvNotifier.notify(infoMessage)

])