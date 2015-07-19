angular.module('twitcherinoApp').controller('FollowCtrl', ['$http', '$scope', '$routeParams', 'mvIdentity'
	($http, $scope, $routeParams, mvIdentity) ->

		$scope.offset = 0
		$scope.channels = {}
		$scope.channels.streams = []
		hitboxChannels = ""
		twitchChannels = ""
		azubuChannels = ""

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
						limit: OPTIONS.channelsInitial
						offset: $scope.offset
					}
					headers: {
						Accept: 'application/vnd.twitchtv.v3+json'
					}
				}).success( (data, status, headers, config) ->
					if (mvIdentity.currentUser.twitchFollows.length > 0)
						for i in [0...data.streams.length]
							channel =
								username: data.streams[i].channel.name
								title: data.streams[i].channel.status
								display_name: data.streams[i].channel.display_name
								viewers_number: parseInt(data.streams[i].viewers, 10)
								thumbnail_url: data.streams[i].preview.large
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
						limit: OPTIONS.channelsInitial
						offset: $scope.offset
					}
				}).success( (data, status, headers, config) ->
					if (mvIdentity.currentUser.hitboxFollows.length > 0)
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



				for i in [0...mvIdentity.currentUser.azubuFollows.length]
					azubuChannels += "#{mvIdentity.currentUser.azubuFollows[i]},"

				azubucall = $http({
					method: 'GET'
					url: "https://api.azubu.tv/public/channel/list"
					params: {
						limit: OPTIONS.channelsInitial
						offset: $scope.offset
						channels: azubuChannels
					}
				}).success( (data, status, headers, config) ->
					if (mvIdentity.currentUser.azubuFollows.length > 0)
						for i in [0...data.data.length]
							channel =
								username: data.data[i].user.username
								display_name: data.data[i].user.display_name
								title: data.data[i].title
								viewers_number: parseInt(data.data[i].view_count, 10)
								thumbnail_url: data.data[i].url_thumbnail
								game_thumbnail_url: '/img/azubu_game.png'
								game_link: "/games/#{data.data[i].category.title}"
								game_name: data.data[i].category.title
								link: "/azubu/#{data.data[i].user.username}"
								platform_logo: '/img/azubu_logo.png'
								profile_url: '/img/azubu_profile.png'
							$scope.channels.streams.push(channel)
				)

				$scope.offset += OPTIONS.channelsIncrement

		$scope.isNotAuthenticated = !mvIdentity.isAuthenticated()

		
])
