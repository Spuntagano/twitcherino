angular.module('twitcherinoControllers').controller('ChannelsCtrl', ['$http', '$scope', '$routeParams',
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
					limit: OPTIONS.channelsInitial
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
					limit: OPTIONS.channelsInitial
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

			$scope.offset += OPTIONS.channelsIncrement

		
])