angular.module('twitcherinoApp').controller('GamesChannelsCtrl', ['$http', '$scope', '$routeParams',
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
					limit: OPTIONS.gamesInitial
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
						thumbnail_url: data.streams[i].preview.large
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
					limit: OPTIONS.gamesInitial
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
						game_link: "/games/#{data.livestream[i].category_name}"
						game_name: data.livestream[i].category_name
						link: "/hitbox/#{data.livestream[i].media_user_name}"
						platform_logo: '/img/hitbox_logo.png'
						profile_url: "https://edge.sf.hitbox.tv#{data.livestream[i].channel.user_logo}"
					$scope.channels.streams.push(channel)
			)

			azubucall = $http({
				method: 'GET'
				url: "http://api.azubu.tv/public/channel/live/list/game/#{$routeParams.gameName.replace(/\s+/g, '-').toLowerCase()}"
				params: {
					limit: OPTIONS.gamesInitial
					offset: $scope.offset
				}
			}).success( (data, status, headers, config) ->
				for i in [0...data.data.length]
					channel =
						username: data.data[i].user.username
						display_name: data.data[i].user.display_name
						title: data.data[i].title
						viewers_number: parseInt(data.data[i].view_count, 10)
						thumbnail_url: data.data[i].url_thumbnail
						game_link: "/games/#{data.data[i].category.title}"
						game_name: data.data[i].category.title
						link: "/azubu/#{data.data[i].user.username}"
						platform_logo: '/img/azubu_logo.png'
						profile_url: '/img/azubu_profile.png'
					$scope.channels.streams.push(channel)
			)

			$scope.offset += OPTIONS.gamesIncrement

])