angular.module('twitcherinoApp').controller('FollowCtrl', ['$http', '$scope', '$routeParams', 'mvIdentity', 'mvFollow', 'mvAuth', 'mvNotifier',
	($http, $scope, $routeParams, mvIdentity, mvFollow, mvAuth, mvNotifier) ->

		$scope.offset = 0
		$scope.channels = {}
		$scope.channels.streams = []
		hitboxChannels = ""
		twitchChannels = ""
		azubuChannels = ""

		$scope.isNotAuthenticated = !mvIdentity.isAuthenticated()

		if (mvIdentity.isAuthenticated())

			mvAuth.getUser(mvIdentity.currentUser).then( (data) ->

				###
				if (!mvIdentity.currentUser.follows)
					mvIdentity.currentUser.follows = {}

				if (!mvIdentity.currentUser.follows['twitch'])
					mvIdentity.currentUser.follows['twitch'] = []

				if (!mvIdentity.currentUser.follows['hitbox'])
					mvIdentity.currentUser.follows['hitbox'] = []

				if (!mvIdentity.currentUser.follows['azubu'])
					mvIdentity.currentUser.follows['azubu'] = []


				for i in [0...mvIdentity.currentUser.follows['twitch'].length]
					twitchChannels += "#{mvIdentity.currentUser.follows['twitch'][i]},"

				for i in [0...mvIdentity.currentUser.follows['hitbox'].length]
					hitboxChannels += "#{mvIdentity.currentUser.follows['hitbox'][i]},"

				for i in [0...mvIdentity.currentUser.follows['azubu'].length]
					azubuChannels += "#{mvIdentity.currentUser.follows['azubu'][i]},"
				###
				
				$scope.loadMore= ->

					if (mvIdentity.isTwitchConnected())
						mvFollow.twitchFollows($scope.offset).then( (data) ->
							streams = data.data.streams
							if (streams.length > 0)
								for i in [0...streams.length]
									channel =
										username: streams[i].channel.name
										title: streams[i].channel.status
										display_name: streams[i].channel.display_name
										viewers_number: parseInt(streams[i].viewers, 10)
										thumbnail_url: streams[i].preview.large
										game_thumbnail_url: "https://static-cdn.jtvnw.net/ttv-boxart/#{streams[i].channel.game}-73x100.jpg"
										game_link: "/games/#{streams[i].channel.game}"
										game_name: streams[i].channel.game
										link: "/twitch/#{streams[i].channel.name}"
										platform_logo: '/img/twitch_logo.png'
										profile_url: streams[i].channel.logo
									$scope.channels.streams.push(channel)
						(data) ->
							if (data.status == 401)
									window.location.replace('/auth/twitchtv')
						)
					if (mvIdentity.isHitboxConnected())	
						mvFollow.hitboxFollows($scope.offset).then( (data) ->
							streams = data.data.livestream
							if (streams.length > 0)
								for i in [0...streams.length]
									channel =
										username: streams[i].media_user_name
										title: streams[i].media_status
										display_name: streams[i].media_user_name
										viewers_number: parseInt(streams[i].media_views, 10)
										thumbnail_url: "https://edge.sf.hitbox.tv#{streams[i].media_thumbnail}"
										game_thumbnail_url: "https://edge.sf.hitbox.tv#{streams[i].category_logo_large}"
										game_link: "/games/#{streams[i].category_name}"
										game_name: streams[i].category_name
										link: "/hitbox/#{streams[i].media_user_name}"
										platform_logo: '/img/hitbox_logo.png'
										profile_url: "https://edge.sf.hitbox.tv#{streams[i].channel.user_logo}"
									$scope.channels.streams.push(channel)
					)
					###
					mvFollow.azubuFollows($scope.offset).success( (data, status, headers, config) ->
						if (data.data.length > 0)
							streams = data.data
							for i in [0...streams.length]
								channel =
									username: streams[i].user.username
									display_name: streams[i].user.display_name
									title: streams[i].title
									viewers_number: parseInt(streams[i].view_count, 10)
									thumbnail_url: streams[i].url_thumbnail
									game_thumbnail_url: '/img/azubu_game.png'
									game_link: "/games/#{streams[i].category.title}"
									game_name: streams[i].category.title
									link: "/azubu/#{streams[i].user.username}"
									platform_logo: '/img/azubu_logo.png'
									profile_url: '/img/azubu_profile.png'
								$scope.channels.streams.push(channel)
					)
					###

					$scope.offset += OPTIONS.channelsIncrement
				$scope.loadMore()
			)
		
])