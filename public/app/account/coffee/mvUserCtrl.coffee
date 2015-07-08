angular.module('twitcherinoControllers').controller('UserListCtrl', ['$scope', 'mvUser', ($scope, mvUser) ->
	$scope.users = mvUser.query()
])

#binded on the main app because its called in the base model
angular.module('twitcherinoApp').controller('SignupCtrl', ['$scope', '$location', 'mvNotifier', 'mvAuth', 'mvUser'
	($scope, $location, mvNotifier, mvAuth, mvUser) ->

		$scope.signup = ->
			newUserData =
				username: $scope.email
				password: $scope.password
				firstName: $scope.fname
				lastName: $scope.lname

			mvAuth.createUser(newUserData).then( ->
				mvNotifier.notify('User account created!')
				$location.path('/')
			(reason) ->
				mvNotifier.error(reason)
			)

])

#binded on the main app because its called in the base model
angular.module('twitcherinoApp').controller('ProfileCtrl', ['$http', '$scope', 'mvAuth', 'mvIdentity', 'mvNotifier', 'mvFollow', ($http, $scope, mvAuth, mvIdentity, mvNotifier, mvFollow) ->
	$scope.email = mvIdentity.currentUser.username
	$scope.fname = mvIdentity.currentUser.firstName
	$scope.lname = mvIdentity.currentUser.lastName

	$scope.isTwitchConnected = mvIdentity.isTwitchConnected()

	#call the server to see if its been connected after first login
	if (!$scope.isTwitchConnected)
		$http({
			method: 'GET'
			url: '/api/user'
		}).success( (data, status, headers, config) ->
			if (data[0])
				if (data[0].twitchtvId)
					mvIdentity.currentUser.twitchtvId = data[0].twitchtvId
					$scope.isTwitchConnected = true
		)

	$scope.update = ->
		newUserData =
			username: $scope.email
			firstName: $scope.fname
			lastName: $scope.lname

		if ($scope.password && $scope.password.length > 0)
			newUserData.password = $scope.password

		mvAuth.updateCurrentUser(newUserData).then( ->
			mvNotifier.notify('Your profile has been updated')
		(reason) ->
			mvNotifier.error(reason)
		)

	$scope.importTwitchFollows = ->

		channels = [];

		if (mvIdentity.currentUser.twitchtvId)
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
				for i in [0...data.follows.length]
					channels.push(data.follows[i].channel.name)

				mvFollow.importTwitchFollows(channels).then( ->
					mvNotifier.notify('Channels imported')
				(reason) ->
					mvNotifier.error(reason)
				)

			)

])

#binded on the main app because its called in the base model
angular.module('twitcherinoApp').controller('NavigationCtrl', ['$scope', '$location', '$http', 'mvIdentity', 'mvNotifier', 'mvAuth', 'mvUser'
	($scope, $location, $http, mvIdentity, mvNotifier, mvAuth, mvUser) ->

		$scope.identity = mvIdentity

		$scope.isActive = (viewLocation) ->
			$location.path().startsWith(viewLocation)

		$scope.signin = (username, password) ->
			mvAuth.authenticateUser(username, password).then( (success) ->
				if (success)
					mvNotifier.notify('Welcome')
				else
					mvNotifier.notify('Invalid login')
			)

		$scope.signout = ->
			mvAuth.logoutUser().then( ->
				$scope.username = ""
				$scope.password = ""
				mvNotifier.notify('Bye')
				$location.path('/')
			)

		$scope.isAuthenticated = mvIdentity.isAuthenticated()

])