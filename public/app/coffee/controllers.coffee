angular.module('twitcherinoControllers', [])

.controller('TwitchChannelCtrl', ['$scope', '$routeParams', '$sce', '$http', 'mvFollow', 'mvIdentity', 'mvNotifier'
	($scope, $routeParams, $sce, $http, mvFollow, mvIdentity, mvNotifier) ->

		$scope.videoUrl = () ->
			 $sce.trustAsResourceUrl("http://www.twitch.tv/#{$routeParams.channelUser}/embed?auto_play=true")

		$scope.chatUrl = () ->
			 $sce.trustAsResourceUrl("http://www.twitch.tv/#{$routeParams.channelUser}/chat")

		$scope.channel = {}

		twitchcall = $http({
			method: 'JSONP'
			url: "https://api.twitch.tv/kraken/streams/#{$routeParams.channelUser}"
			params: {
				callback: 'JSON_CALLBACK'
			}
			headers: {
				Accept: 'application/vnd.twitchtv.v3+json'
			}
		}).success( (data, status, headers, config) ->
			channel =
				username: data.stream.channel.name
				title: data.stream.channel.status
				display_name: data.stream.channel.display_name
				viewers_number: parseInt(data.stream.viewers, 10)
				profile_url: data.stream.channel.logo
				platform: 'twitch'
			$scope.channel = channel
			$scope.isFollowed = mvFollow.isFollowed(channel.username, channel.platform)

			$scope.addFollow = () ->
				mvFollow.addFollow(channel.username, channel.platform).then( ->
					mvNotifier.notify('Channel followed')
					$scope.isFollowed = true
				(reason) ->
					mvNotifier.error(reason)
				)

			$scope.removeFollow = () ->
				mvFollow.removeFollow(channel.username, channel.platform).then( ->
					mvNotifier.notify('Channel unfollowed')
					$scope.isFollowed = false
				(reason) ->
					mvNotifier.error(reason)
				)
		)

		$scope.isAuthenticated = mvIdentity.isAuthenticated()

])

.controller('HitboxChannelCtrl', ['$scope', '$routeParams', '$sce', '$http', 'mvFollow', 'mvIdentity', 'mvNotifier'
	($scope, $routeParams, $sce, $http, mvFollow, mvIdentity, mvNotifier) ->

		$scope.videoUrl = () ->
			 $sce.trustAsResourceUrl("http://www.hitbox.tv/embed/#{$routeParams.channelUser}?autoplay=true")

		$scope.chatUrl = () ->
			 $sce.trustAsResourceUrl("http://www.hitbox.tv/embedchat/#{$routeParams.channelUser}")

		$scope.channel = {}

		hitboxcall = $http({
			method: 'GET'
			url: "https://api.hitbox.tv/media/live/#{$routeParams.channelUser}"
		}).success( (data, status, headers, config) ->
			channel =
				username: data.livestream[0].media_user_name
				title: data.livestream[0].media_status
				display_name: data.livestream[0].media_user_name
				viewers_number: parseInt(data.livestream[0].media_views, 10)
				profile_url: "https://edge.sf.hitbox.tv#{data.livestream[0].channel.user_logo}"
				platform: 'hitbox'
			$scope.channel = channel
			$scope.isFollowed = mvFollow.isFollowed(channel.username, channel.platform)

			$scope.addFollow = () ->
				mvFollow.addFollow(channel.username, channel.platform).then( ->
					mvNotifier.notify('Channel followed')
					$scope.isFollowed = true
				(reason) ->
					mvNotifier.error(reason)
				)

			$scope.removeFollow = () ->
				mvFollow.removeFollow(channel.username, channel.platform).then( ->
					mvNotifier.notify('Channel unfollowed')
					$scope.isFollowed = false
				(reason) ->
					mvNotifier.error(reason)
				)
		)

		$scope.isAuthenticated = mvIdentity.isAuthenticated()

])

.controller('ChannelsCtrl', ['$http', '$scope', '$routeParams',
	($http, $scope, $routeParams) ->

		$scope.offset = 0
		$scope.channels = {}
		$scope.channels.streams = []

		$scope.loadMore= ->

			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/streams"
				params : {
					callback: 'JSON_CALLBACK'
					limit: channelsInitial
					offset: $scope.offset
				}
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			}).success( (data, status, headers, config) ->
				for i in [0...data.streams.length]
					channel =
						username: data.streams[i].channel.name
						title: data.streams[i].channel.status
						display_name: data.streams[i].channel.display_name
						viewers_number: parseInt(data.streams[i].viewers, 10)
						thumbnail_url: data.streams[i].preview.medium
						game_thumbnail_url: "https://static-cdn.jtvnw.net/ttv-boxart/#{data.streams[i].channel.game}-73x100.jpg"
						game_link: "/games/#{data.streams[i].channel.game}"
						game_name: data.streams[i].channel.game
						link: "/twitch/#{data.streams[i].channel.name}"
						platform_logo: '/img/twitch_logo.png'
						profile_url: data.streams[i].channel.logo
					$scope.channels.streams.push(channel)
			)

			hitboxcall = $http({
				method: 'GET'
				url: "https://api.hitbox.tv/media"
				params: {
					limit: channelsInitial
					offset: $scope.offset
				}
			}).success( (data, status, headers, config) ->
				for i in [0...data.livestream.length]
					channel =
						username: data.livestream[i].media_user_name
						title: data.livestream[i].media_status
						display_name: data.livestream[i].media_user_name
						viewers_number: parseInt(data.livestream[i].media_views, 10)
						thumbnail_url: "https://edge.sf.hitbox.tv#{data.livestream[i].media_thumbnail}"
						game_thumbnail_url: "https://edge.sf.hitbox.tv#{data.livestream[i].category_logo_large}"
						game_link: "/games/#{data.livestream[i].category_name}"
						game_name: data.livestream[i].category_name
						link: "/hitbox/#{data.livestream[i].media_user_name}"
						platform_logo: '/img/hitbox_logo.png'
						profile_url: "https://edge.sf.hitbox.tv#{data.livestream[i].channel.user_logo}"
					$scope.channels.streams.push(channel)
			)

			$scope.offset += channelsIncrement

		
])


.controller('FollowingCtrl', ['$http', '$scope', '$routeParams', 'mvIdentity'
	($http, $scope, $routeParams, mvIdentity) ->

		$scope.offset = 0
		$scope.channels = {}
		$scope.channels.streams = []
		hitboxChannels = ""
		twitchChannels = ""

		if (mvIdentity.isAuthenticated())
			for i in [0...mvIdentity.currentUser.twitchFollows.length]
				twitchChannels += "#{mvIdentity.currentUser.twitchFollows[i]},"

			$scope.loadMore= ->

				twitchcall = $http({
					method: 'JSONP'
					url: "https://api.twitch.tv/kraken/streams"
					params : {
						channel: twitchChannels
						callback: 'JSON_CALLBACK'
						limit: channelsInitial
						offset: $scope.offset
					}
					headers: {
						Accept: 'application/vnd.twitchtv.v3+json'
					}
				}).success( (data, status, headers, config) ->
					for i in [0...data.streams.length]
						channel =
							username: data.streams[i].channel.name
							title: data.streams[i].channel.status
							display_name: data.streams[i].channel.display_name
							viewers_number: parseInt(data.streams[i].viewers, 10)
							thumbnail_url: data.streams[i].preview.medium
							game_thumbnail_url: "https://static-cdn.jtvnw.net/ttv-boxart/#{data.streams[i].channel.game}-73x100.jpg"
							game_link: "/games/#{data.streams[i].channel.game}"
							game_name: data.streams[i].channel.game
							link: "/twitch/#{data.streams[i].channel.name}"
							platform_logo: '/img/twitch_logo.png'
							profile_url: data.streams[i].channel.logo
						$scope.channels.streams.push(channel)
				)

				for i in [0...mvIdentity.currentUser.hitboxFollows.length]
					hitboxChannels += "#{mvIdentity.currentUser.hitboxFollows[i]},"

				hitboxcall = $http({
					method: 'GET'
					url: "https://api.hitbox.tv/media/live/#{hitboxChannels}"
					params: {
						limit: channelsInitial
						offset: $scope.offset
					}
				}).success( (data, status, headers, config) ->
					for i in [0...data.livestream.length]
						channel =
							username: data.livestream[i].media_user_name
							title: data.livestream[i].media_status
							display_name: data.livestream[i].media_user_name
							viewers_number: parseInt(data.livestream[i].media_views, 10)
							thumbnail_url: "https://edge.sf.hitbox.tv#{data.livestream[i].media_thumbnail}"
							game_thumbnail_url: "https://edge.sf.hitbox.tv#{data.livestream[i].category_logo_large}"
							game_link: "/games/#{data.livestream[i].category_name}"
							game_name: data.livestream[i].category_name
							link: "/hitbox/#{data.livestream[i].media_user_name}"
							platform_logo: '/img/hitbox_logo.png'
							profile_url: "https://edge.sf.hitbox.tv#{data.livestream[i].channel.user_logo}"
						$scope.channels.streams.push(channel)
				)

				$scope.offset += channelsIncrement

		$scope.isNotAuthenticated = !mvIdentity.isAuthenticated()

		
])


.controller('GamesCtrl', ['$http', '$scope', '$routeParams',
	($http, $scope, $routeParams) ->

		$scope.offset = 0
		$scope.cats = {}
		$scope.cats.categories = []

		$scope.loadMore= ->

			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/games/top"
				params: {
					callback: 'JSON_CALLBACK'
					limit: gamesInitial
					offset: $scope.offset
				}
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			}).success( (data, status, headers, config) ->
				for i in [0...Object.keys(data.top).length]
					skip = false
					for j in [0...$scope.cats.categories.length]
						if ($scope.cats.categories[j].category_name == data.top[i].game.name)
							$scope.cats.categories[j].viewers_number += parseInt(data.top[i].viewers, 10)
							$scope.cats.categories[j].thumbnail_url == "https://static-cdn.jtvnw.net/ttv-boxart/#{data.top[i].game.name}-327x457.jpg"
							skip = true
					if (!skip)
						category =
							category_name: data.top[i].game.name
							viewers_number: parseInt(data.top[i].viewers, 10)
							thumbnail_url: "https://static-cdn.jtvnw.net/ttv-boxart/#{data.top[i].game.name}-327x457.jpg"
							link: "/twitch/#{data.top[i].game.name}"
						$scope.cats.categories.push(category)
			)

			setTimeout( -> #hack to get twitch images
				hitboxcall = $http({
					method: 'GET'
					url: "https://api.hitbox.tv/games"
					params: {
						limit: gamesInitial
						offset: $scope.offset
					}
				}).success( (data, status, headers, config) ->
					for i in [0...data.categories.length]
						skip = false
						for j in [0...$scope.cats.categories.length]
							if ($scope.cats.categories[j].category_name == data.categories[i].category_name)
								$scope.cats.categories[j].viewers_number += parseInt(data.categories[i].category_viewers, 10)
								skip = true
						if (!skip)
							category =
								category_name: data.categories[i].category_name
								viewers_number: parseInt(data.categories[i].category_viewers, 10)
								thumbnail_url: "http://edge.sf.hitbox.tv#{data.categories[i].category_logo_large}"
								link: "/hitbox/#{data.categories[i].category_name}"
							$scope.cats.categories.push(category)
				)

				$scope.offset += gamesIncrement
			, 100)



])


.controller('GamesChannelsCtrl', ['$http', '$scope', '$routeParams',
	($http, $scope, $routeParams) ->

		$scope.offset = 0
		$scope.channels = {}
		$scope.channels.streams = []
		$scope.game_search = true
		$scope.game_name = $routeParams.gameName

		$scope.loadMore= ->

			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/streams"
				params: {
					callback: 'JSON_CALLBACK'
					game: $routeParams.gameName
					limit: gamesInitial
					offset: $scope.offset
				}
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			}).success( (data, status, headers, config) ->
				for i in [0...data.streams.length]
					channel =
						username: data.streams[i].channel.name
						display_name: data.streams[i].channel.display_name
						title: data.streams[i].channel.status
						viewers_number: parseInt(data.streams[i].viewers, 10)
						thumbnail_url: data.streams[i].preview.medium
						game_thumbnail_url: "https://static-cdn.jtvnw.net/ttv-boxart/#{data.streams[i].channel.game}-73x100.jpg"
						game_link: "/games/#{data.streams[i].channel.game}"
						game_name: data.streams[i].channel.game
						link: "/twitch/#{data.streams[i].channel.name}"
						platform_logo: '/img/twitch_logo.png'
						profile_url: data.streams[i].channel.logo
					$scope.channels.streams.push(channel)
			)

			hitboxcall = $http({
				method: 'GET'
				url: "https://api.hitbox.tv/media"
				params: {
					game: $routeParams.gameName
					limit: gamesInitial
					offset: $scope.offset
				}
			}).success( (data, status, headers, config) ->
				for i in [0...data.livestream.length]
					channel =
						username: data.livestream[i].media_user_name
						display_name: data.livestream[i].media_user_name
						title: data.livestream[i].media_status
						viewers_number: parseInt(data.livestream[i].media_views, 10)
						thumbnail_url: "https://edge.sf.hitbox.tv#{data.livestream[i].media_thumbnail}"
						game_thumbnail_url: "https://edge.sf.hitbox.tv#{data.livestream[i].category_logo_large}"
						game_link: "/games/#{data.livestream[i].category_name}"
						game_name: data.livestream[i].category_name
						link: "/hitbox/#{data.livestream[i].media_user_name}"
						platform_logo: '/img/hitbox_logo.png'
						profile_url: "https://edge.sf.hitbox.tv#{data.livestream[i].channel.user_logo}"
					$scope.channels.streams.push(channel)
			)

			$scope.offset += gamesIncrement

])

.controller('NavigationCtrl', ['$scope', '$location', '$http', 'mvIdentity', 'mvNotifier', 'mvAuth', 'mvUser'
	($scope, $location, $http, mvIdentity, mvNotifier, mvAuth, mvUser) ->

		$scope.identity = mvIdentity

		$scope.isActive = (viewLocation) ->
			$location.path().startsWith(viewLocation)

		$scope.signin = (username, password) ->
			mvAuth.authenticateUser(username, password).then( (success) ->
				if (success)
					mvNotifier.notify('mah nigga')
				else
					mvNotifier.notify('fuk uu')
			)

		$scope.signout = ->
			mvAuth.logoutUser().then( ->
				$scope.username = ""
				$scope.password = ""
				mvNotifier.notify('peace out nigga')
				$location.path('/')
			)

		$scope.isAuthenticated = mvIdentity.isAuthenticated()

])

.controller('UserListCtrl', ['$scope', 'mvUser', ($scope, mvUser) ->
	$scope.users = mvUser.query()
])

.controller('SignupCtrl', ['$scope', '$location', 'mvNotifier', 'mvAuth', 'mvUser'
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


.controller('ProfileCtrl', ['$scope', 'mvAuth', 'mvIdentity', 'mvNotifier', ($scope, mvAuth, mvIdentity, mvNotifier) ->
	$scope.email = mvIdentity.currentUser.username
	$scope.fname = mvIdentity.currentUser.firstName
	$scope.lname = mvIdentity.currentUser.lastName

	$scope.isTwitchConnected = mvIdentity.isTwitchConnected()

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

	$scope.twitchCall = ->
		event.preventDefault()
		window.location.replace('http://localhost:3030/auth/twitchtv')
])