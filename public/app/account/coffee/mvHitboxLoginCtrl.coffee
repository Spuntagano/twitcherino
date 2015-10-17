angular.module('twitcherinoApp').controller('HitboxLoginCtrl', ['$scope', '$location', '$http', 'mvNotifier', 'mvIdentity', 'mvAuth', 'mvRedirect'
	($scope, $location, $http, mvNotifier, mvIdentity, mvAuth, mvRedirect) ->

		#mvRedirect.toHTTPS()

		$scope.hitboxAuth = (username, password) ->
			mvAuth.hitboxAuth(username, password).then( ->
				mvNotifier.notify('Hitbox account connected')
				$location.path('/profile')
			(reason) ->
				mvNotifier.error(reason)
			)

])