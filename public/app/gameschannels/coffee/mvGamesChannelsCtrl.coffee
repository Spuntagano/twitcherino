angular.module('twitcherinoApp').controller('GamesChannelsCtrl', ['$http', '$scope', '$routeParams', 'mvGamesChannels',
	($http, $scope, $routeParams, mvGamesChannels) ->

		$scope.offset = 0
		$scope.channels = {}
		$scope.channels.streams = []
		$scope.game_search = true
		$scope.game_name = $routeParams.gameName

		$scope.loadMore= ->

			mvGamesChannels.twitchGamesChannels($scope.game_name, $scope.offset).success( (data, status, headers, config) ->
				streams = data.streams
				for i in [0...data.streams.length]
					channel =
						username: streams[i].channel.name
						display_name: streams[i].channel.display_name
						title: streams[i].channel.status
						viewers_number: parseInt(streams[i].viewers, 10)
						thumbnail_url: streams[i].preview.large
						game_link: "/games/#{streams[i].channel.game}"
						game_name: streams[i].channel.game
						link: "/twitch/#{streams[i].channel.name}"
						platform_logo: '/img/twitch_logo.png'
						profile_url: streams[i].channel.logo
					$scope.channels.streams.push(channel)
			)

			mvGamesChannels.hitboxGamesChannels($scope.game_name, $scope.offset).success( (data, status, headers, config) ->
				streams = data.livestream
				console.log(data)
				for i in [0...streams.length]
					channel =
						username: streams[i].media_user_name
						display_name: streams[i].media_user_name
						title: streams[i].media_status
						viewers_number: parseInt(streams[i].media_views, 10)
						thumbnail_url: "https://edge.sf.hitbox.tv#{streams[i].media_thumbnail}"
						game_link: "/games/#{streams[i].category_name}"
						game_name: data.livestream[i].category_name
						link: "/hitbox/#{streams[i].media_user_name}"
						platform_logo: '/img/hitbox_logo.png'
						profile_url: "https://edge.sf.hitbox.tv#{streams[i].channel.user_logo}"
					$scope.channels.streams.push(channel)
			)

			mvGamesChannels.azubuGamesChannels($scope.game_name, $scope.offset).success( (data, status, headers, config) ->
				streams = data.data
				for i in [0...streams.length]
					channel =
						username: streams[i].user.username
						display_name: streams[i].user.display_name
						title: streams[i].title
						viewers_number: parseInt(streams[i].view_count, 10)
						thumbnail_url: streams[i].url_thumbnail
						game_link: "/games/#{streams[i].category.title}"
						game_name: streams[i].category.title
						link: "/azubu/#{streams[i].user.username}"
						platform_logo: '/img/azubu_logo.png'
						profile_url: '/img/azubu_profile.png'
					$scope.channels.streams.push(channel)
			)

			$scope.offset += OPTIONS.gamesIncrement

])