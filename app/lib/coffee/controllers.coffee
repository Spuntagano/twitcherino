angular.module('twitcherinoControllers', [])

.controller('HitboxChannelCtrl', ['$scope', '$routeParams', '$sce', 'HitboxChannel'
	($scope, $routeParams, $sce, HitboxChannel) ->

		$scope.videoUrl = () ->
			 $sce.trustAsResourceUrl("http://www.hitbox.tv/embed/#{$routeParams.channelUser}")

		$scope.chatUrl = () ->
			 $sce.trustAsResourceUrl("http://www.hitbox.tv/embedchat/#{$routeParams.channelUser}")

])

.controller('TwitchChannelCtrl', ['$scope', '$routeParams', '$sce', 'HitboxChannel'
	($scope, $routeParams, $sce, HitboxChannel) ->

		$scope.videoUrl = () ->
			 $sce.trustAsResourceUrl("http://www.twitch.tv/#{$routeParams.channelUser}/embed");

		$scope.chatUrl = () ->
			 $sce.trustAsResourceUrl("http://www.twitch.tv/#{$routeParams.channelUser}/chat");
])

.controller('ChannelsCtrl', ['$http', '$scope', '$routeParams',
	($http, $scope, $routeParams) ->

		increment = 30
		initial = 30

		if (!$scope.offset?)
			$scope.offset = 0

		if (!$scope.channels?)
			$scope.channels = {}

		if (!$scope.channels.streams?)
			$scope.channels.streams = []

		$scope.loadMore= ->

			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/streams"
				params : {
					callback: 'JSON_CALLBACK'
					limit: initial
					offset: $scope.offset
				}
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			}).success( (data, status, headers, config) ->
				for i in [0...data.streams.length]
					channel =
						username: data.streams[i].channel.name
						viewers_number: parseInt(data.streams[i].viewers, 10)
						thumbnail_url: data.streams[i].preview.medium
						link: "#/twitch/#{data.streams[i].channel.name}"
						platform: 'Twitch'
					$scope.channels.streams.push(channel)
			)

			hitboxcall = $http({
				method: 'GET'
				url: "http://api.hitbox.tv/media"
				params: {
					limit: initial
					offset: $scope.offset
				}
			}).success( (data, status, headers, config) ->
				for i in [0...data.livestream.length]
					channel =
						username: data.livestream[i].media_user_name
						viewers_number: parseInt(data.livestream[i].media_views, 10)
						thumbnail_url: "http://edge.sf.hitbox.tv#{data.livestream[i].media_thumbnail}"
						link: "#/hitbox/#{data.livestream[i].media_user_name}"
						platform: 'Hitbox'
					$scope.channels.streams.push(channel)
			)

			$scope.offset += increment

		
])

.controller('GamesCtrl', ['$http', '$scope', '$routeParams',
	($http, $scope, $routeParams) ->

		increment = 30
		initial = 30

		if (!$scope.offset?)
			$scope.offset = 0

		if (!$scope.cats?)
			$scope.cats = {}

		if (!$scope.cats.categories?)
			$scope.cats.categories = []

		$scope.loadMore= ->

			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/games/top"
				params: {
					callback: 'JSON_CALLBACK'
					limit: initial
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
							skip = true
					if (!skip)
						category =
							category_name: data.top[i].game.name
							viewers_number: parseInt(data.top[i].viewers, 10)
							thumbnail_url: data.top[i].game.box.medium
							link: "#/twitch/#{data.top[i].game.name}"
						$scope.cats.categories.push(category)
			)

			hitboxcall = $http({
				method: 'GET'
				url: "http://api.hitbox.tv/games"
				params: {
					limit: initial
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
							link: "#/hitbox/#{data.categories[i].category_name}"
						$scope.cats.categories.push(category)
			)

			$scope.offset += increment

])


.controller('GamesChannelsCtrl', ['$http', '$scope', '$routeParams',
	($http, $scope, $routeParams) ->

		increment = 30
		initial = 30

		if (!$scope.offset?)
			$scope.offset = 0

		if (!$scope.channels?)
			$scope.channels = {}

		if (!$scope.channels.streams?)
			$scope.channels.streams = []

		$scope.loadMore= ->

			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/streams"
				params: {
					callback: 'JSON_CALLBACK'
					game: $routeParams.gameName
					limit: initial
					offset: $scope.offset
				}
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			}).success( (data, status, headers, config) ->
				for i in [0...data.streams.length]
					channel =
						username: data.streams[i].channel.name
						viewers_number: parseInt(data.streams[i].viewers, 10)
						thumbnail_url: data.streams[i].preview.medium
						link: "#/twitch/#{data.streams[i].channel.name}"
						platform: 'Twitch'
					$scope.channels.streams.push(channel)
			)

			hitboxcall = $http({
				method: 'GET'
				url: "http://api.hitbox.tv/media"
				params: {
					game: $routeParams.gameName
					limit: initial
					offset: $scope.offset
				}
			}).success( (data, status, headers, config) ->
				for i in [0...data.livestream.length]
					channel =
						username: data.livestream[i].media_user_name
						viewers_number: parseInt(data.livestream[i].media_views, 10)
						thumbnail_url: "http://edge.sf.hitbox.tv#{data.livestream[i].media_thumbnail}"
						link: "#/hitbox/#{data.livestream[i].media_user_name}"
						platform: 'Hitbox'
					$scope.channels.streams.push(channel)
			)

			$scope.offset += increment


])

