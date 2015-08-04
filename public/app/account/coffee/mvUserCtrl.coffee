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

angular.module('twitcherinoApp').controller('ProfileCtrl', ['$http', '$scope', 'mvAuth', 'mvIdentity', 'mvNotifier', 'mvFollow', 'mvRedirect', 'mvUser', ($http, $scope, mvAuth, mvIdentity, mvNotifier, mvFollow, mvRedirect, mvUser) ->
	
	mvRedirect.toHTTPS()

	$scope.email = mvIdentity.currentUser.username
	$scope.isTwitchConnected = mvIdentity.isTwitchConnected()
	$scope.notChangePassword = true

	if (!$scope.isTwitchConnected)
		$http({
			method: 'GET'
			url: '/api/user'
		}).success( (data, status, headers, config) ->
			if (data[0])
				if (data[0].twitchtvUsername)
					mvIdentity.currentUser.twitchtvUsername = data[0].twitchtvUsername
					$scope.isTwitchConnected = true
		)

	$scope.update = ->
		if ($scope.password == $scope.passwordConfirm)
			newUserData =
				username: $scope.email
				oldUsername: mvIdentity.currentUser.username

			if ($scope.password && $scope.password.length > 0)
				newUserData.password = $scope.password

			mvAuth.updateCurrentUser(newUserData).then( ->
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
			mvAuth.deleteUser(mvIdentity.currentUser.username).then( ->
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

		channels = []

		if (mvIdentity.currentUser.twitchtvUsername)
			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/users/#{mvIdentity.currentUser.twitchtvUsername}/follows/channels"
				params: {
					callback: 'JSON_CALLBACK'
					limit: 100
				}
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			}).success( (data, status, headers, config) ->
				totalFollows = data._total
				followPageCount = Math.ceil(totalFollows / 100)
				for i in [0...data.follows.length]
					channels.push(data.follows[i].channel.name)

				#twitch api only allow 100 channels to be returned at once
				if (followPageCount > 1)
					for j in [1...followPageCount]
						$http({
							method: 'JSONP'
							url: "https://api.twitch.tv/kraken/users/#{mvIdentity.currentUser.twitchtvUsername}/follows/channels"
							params: {
								callback: 'JSON_CALLBACK'
								limit: 100
								offset: j * 100
							}
							headers: {
								Accept: 'application/vnd.twitchtv.v3+json'
							}
						}).success( (data, status, headers, config) ->
							for k in [0...data.follows.length]
								channels.push(data.follows[k].channel.name)
								
							mvFollow.importTwitchFollows(channels).then( ->
								mvNotifier.notify("#{data.follows.length} Channels imported")
							(reason) ->
								mvNotifier.error(reason)
							)

						)
				mvFollow.importTwitchFollows(channels).then( ->
					mvNotifier.notify("#{data.follows.length} Channels imported")
				(reason) ->
					mvNotifier.error(reason)
				)
			)

	$scope.importHitboxShowFunc = ->
		$scope.importHitboxShow = !$scope.importHitboxShow

	$scope.importHitboxFollows = ->

		channels = []

		hitboxcall = $http({
			method: 'GET'
			url: 'https://api.hitbox.tv/following/user'
			params: {
				user_name: $scope.hitboxUser
			}
		}).success( (data, status, headers, config) ->
			if (data.message == 'user_not_found')
				mvNotifier.error("Invalid username")
			else
				totalFollows = data.max_results
				followPageCount = Math.ceil(totalFollows / 100)
				for i in [0...data.following.length]
					channels.push(data.following[i].user_name)

				#hitbox api only allow 100 channels to be returned at once
				if (followPageCount > 1)
					for j in [1...followPageCount]
						$http({
							method: 'GET'
							url: "https://api.hitbox.tv/following/user"
							params: {
								user_name: $scope.hitboxUser
								offset: j * 100
								limit: 100
							}
						}).success( (data, status, headers, config) ->
							for k in [0...data.following.length]
								channels.push(data.following[k].user_name)

							mvFollow.importHitboxFollows(channels).then( ->
								mvNotifier.notify("#{data.following.length} Channels imported")
								$scope.importHitboxShow = false
							(reason) ->
								mvNotifier.error(reason)
							)
						)

				mvFollow.importHitboxFollows(channels).then( ->
					mvNotifier.notify("#{data.following.length} Channels imported")

				(reason) ->
					mvNotifier.error(reason)
				)
		)
])