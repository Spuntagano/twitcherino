angular.module('twitcherinoControllers', [])

.controller('TwitchChannelCtrl', ['$scope', '$routeParams', '$sce', '$http'
	($scope, $routeParams, $sce, $http) ->

		$scope.videoUrl = () ->
			 $sce.trustAsResourceUrl("https://www.twitch.tv/#{$routeParams.channelUser}/embed?auto_play=true")

		$scope.chatUrl = () ->
			 $sce.trustAsResourceUrl("https://www.twitch.tv/#{$routeParams.channelUser}/chat")

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
				title: data.stream.channel.status
				display_name: data.stream.channel.display_name
				viewers_number: parseInt(data.stream.viewers, 10)
				profile_url: data.stream.channel.logo
				platform: 'twitch'
			$scope.channel = channel
		)

])

.controller('HitboxChannelCtrl', ['$scope', '$routeParams', '$sce', '$http'
	($scope, $routeParams, $sce, $http) ->

		$scope.videoUrl = () ->
			 $sce.trustAsResourceUrl("https://www.hitbox.tv/embed/#{$routeParams.channelUser}?autoplay=true")

		$scope.chatUrl = () ->
			 $sce.trustAsResourceUrl("https://www.hitbox.tv/embedchat/#{$routeParams.channelUser}")

		$scope.channel = {}

		hitboxcall = $http({
			method: 'GET'
			url: "http://api.hitbox.tv/media/live/#{$routeParams.channelUser}"
		}).success( (data, status, headers, config) ->
			channel =
				title: data.livestream[0].media_status
				display_name: data.livestream[0].media_user_name
				viewers_number: parseInt(data.livestream[0].media_views, 10)
				profile_url: "http://edge.sf.hitbox.tv#{data.livestream[0].channel.user_logo}"
				platform: 'hitbox'
			$scope.channel = channel
		)

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
						game_thumbnail_url: "http://static-cdn.jtvnw.net/ttv-boxart/#{data.streams[i].channel.game}-73x100.jpg"
						game_link: "/games/#{data.streams[i].channel.game}"
						game_name: data.streams[i].channel.game
						link: "/twitch/#{data.streams[i].channel.name}"
						platform_logo: '/img/twitch_logo.png'
						profile_url: data.streams[i].channel.logo
					$scope.channels.streams.push(channel)
			)

			hitboxcall = $http({
				method: 'GET'
				url: "http://api.hitbox.tv/media"
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
						thumbnail_url: "http://edge.sf.hitbox.tv#{data.livestream[i].media_thumbnail}"
						game_thumbnail_url: "http://edge.sf.hitbox.tv#{data.livestream[i].category_logo_large}"
						game_link: "/games/#{data.livestream[i].category_name}"
						game_name: data.livestream[i].category_name
						link: "/hitbox/#{data.livestream[i].media_user_name}"
						platform_logo: '/img/hitbox_logo.png'
						profile_url: "http://edge.sf.hitbox.tv#{data.livestream[i].channel.user_logo}"
					$scope.channels.streams.push(channel)
			)

			$scope.offset += channelsIncrement

		
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
							$scope.cats.categories[j].thumbnail_url == "http://static-cdn.jtvnw.net/ttv-boxart/#{data.top[i].game.name}-327x457.jpg"
							skip = true
					if (!skip)
						category =
							category_name: data.top[i].game.name
							viewers_number: parseInt(data.top[i].viewers, 10)
							thumbnail_url: "http://static-cdn.jtvnw.net/ttv-boxart/#{data.top[i].game.name}-327x457.jpg"
							link: "/twitch/#{data.top[i].game.name}"
						$scope.cats.categories.push(category)
			)

			setTimeout( -> #hack to get twitch images
				hitboxcall = $http({
					method: 'GET'
					url: "http://api.hitbox.tv/games"
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
						game_thumbnail_url: "http://static-cdn.jtvnw.net/ttv-boxart/#{data.streams[i].channel.game}-73x100.jpg"
						game_link: "/games/#{data.streams[i].channel.game}"
						game_name: data.streams[i].channel.game
						link: "/twitch/#{data.streams[i].channel.name}"
						platform_logo: '/img/twitch_logo.png'
						profile_url: data.streams[i].channel.logo
					$scope.channels.streams.push(channel)
			)

			hitboxcall = $http({
				method: 'GET'
				url: "http://api.hitbox.tv/media"
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
						thumbnail_url: "http://edge.sf.hitbox.tv#{data.livestream[i].media_thumbnail}"
						game_thumbnail_url: "http://edge.sf.hitbox.tv#{data.livestream[i].category_logo_large}"
						game_link: "/games/#{data.livestream[i].category_name}"
						game_name: data.livestream[i].category_name
						link: "/hitbox/#{data.livestream[i].media_user_name}"
						platform_logo: '/img/hitbox_logo.png'
						profile_url: "http://edge.sf.hitbox.tv#{data.livestream[i].channel.user_logo}"
					$scope.channels.streams.push(channel)
			)

			$scope.offset += gamesIncrement

])

.controller('navigationCtrl', ['$scope', '$location'
	($scope, $location) ->
		$scope.isActive = (viewLocation) ->
			$location.path().startsWith(viewLocation)

])