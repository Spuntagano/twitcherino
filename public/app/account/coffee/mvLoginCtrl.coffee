angular.module('twitcherinoApp').controller('LoginCtrl', ['$scope', '$location', '$http', 'mvNotifier', 'mvIdentity', 'mvAuth', 'mvRedirect'
	($scope, $location, $http, mvNotifier, mvIdentity, mvAuth, mvRedirect) ->

		#mvRedirect.toHTTPS()

		if (mvIdentity.isAuthenticated())
			$location.path('/profile')

		$scope.signin = (username, password) ->
			mvAuth.authenticateUser(username, password).then( ->
				mvNotifier.notify('Welcome')
				$location.path('/profile')
			(reason) ->
				mvNotifier.error(reason)
			)

])