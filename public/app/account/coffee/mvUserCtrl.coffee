angular.module('twitcherinoControllers').controller('UserListCtrl', ['$scope', 'mvUser', ($scope, mvUser) ->
	$scope.users = mvUser.query()
])

angular.module('twitcherinoApp').controller('SignupCtrl', ['$scope', '$location', 'mvNotifier', 'mvAuth', 'mvUser', 'mvRedirect'
	($scope, $location, mvNotifier, mvAuth, mvUser, mvRedirect) ->

		mvRedirect.toHTTPS()

		$scope.signup = ->
			if ($scope.password == $scope.passwordConfirm)
				newUserData =
					username: $scope.email
					password: $scope.password

				mvAuth.createUser(newUserData).then( ->
					mvNotifier.notify('User account created!')
					$location.path('/')
				(reason) ->
					mvNotifier.error(reason)
				)
			else
				mvNotifier.error('The passwords does not match')
])

angular.module('twitcherinoApp').controller('ProfileCtrl', ['$scope', 'mvAuth', 'mvIdentity', 'mvNotifier', 'mvFollow', 'mvRedirect', 'mvImport', 'mvUser', ($scope, mvAuth, mvIdentity, mvNotifier, mvFollow, mvRedirect, mvImport, mvUser) ->
	
	mvRedirect.toHTTPS()

	$scope.email = mvIdentity.currentUser.username
	$scope.isTwitchConnected = mvIdentity.isTwitchConnected()
	$scope.notChangePassword = true

	if (!$scope.isTwitchConnected)
		mvAuth.getUser(mvIdentity.currentUser).then( ->
			if (mvIdentity.currentUser.twitchtvUsername)
				$scope.isTwitchConnected = true
		(reason) ->
			mvNotifier.error(reason)
		)

	$scope.update = ->
		if ($scope.password == $scope.passwordConfirm)
			newUserData =
				username: $scope.email
				oldUsername: mvIdentity.currentUser.username

			if ($scope.password && $scope.password.length > 0)
				newUserData.password = $scope.password

			mvAuth.updateCurrentUser(newUserData).then( ->
				if (newUserData.password)
					mvIdentity.currentUser.has_pw = true
				mvNotifier.notify('Your profile has been updated')
			(reason) ->
				mvNotifier.error(reason)
			)
		else
			mvNotifier.error('The passwords does not match')

	$scope.changePasswordFunc = ->
		$scope.notChangePassword = !$scope.notChangePassword

	$scope.deleteUser = ->
		if (window.confirm("Are you sure you want to delete your account? There is no turning back"))
			mvAuth.deleteUser(mvIdentity.currentUser).then( ->
				mvNotifier.notify('Your account has been deleted')
			(reason) ->
				mvNotifier.error(reason)
			)

	$scope.disconnectTwitch = ->
		if (!mvIdentity.currentUser.has_pw)
			mvNotifier.error('Please set a password on your account')
		else
			if (window.confirm("Are you sure you want to disconect your twitch account?"))
				mvAuth.disconectTwitch(mvIdentity.currentUser.username).then( ->
					mvNotifier.notify('Your twitch account has been disconnected')
					$scope.isTwitchConnected = false
				(reason) ->
					mvNotifier.error(reason)
				)

	$scope.importTwitchFollows = ->
		mvImport.importTwitch(mvIdentity.currentUser.twitchtvUsername)

	$scope.importHitboxShowFunc = ->
		$scope.importHitboxShow = !$scope.importHitboxShow

	$scope.importHitboxFollows = ->
		mvImport.importHitbox($scope.hitboxUser)
		$scope.importHitboxShow = false
		$scope.hitboxUser = ''
])