angular.module('twitcherinoControllers', [])

.controller('TwitchChannelCtrl', ['$scope', '$routeParams', '$sce', '$http', 'mvFollow', 'mvIdentity', 'mvNotifier', '$location', 'mvRedirect'
	($scope, $routeParams, $sce, $http, mvFollow, mvIdentity, mvNotifier, $location, mvRedirect) ->

		mvRedirect.toHTTP()

		$scope.videoUrl = () ->
			 $sce.trustAsResourceUrl("http://www.twitch.tv/#{$routeParams.channelUser}/embed?auto_play=true")

		$scope.chatUrl = () ->
			 $sce.trustAsResourceUrl("http://www.twitch.tv/#{$routeParams.channelUser}/chat")

		$scope.channel = {}

		twitchcallfunc = ->
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

		twitchcallfunc()
		twitchInterval = setInterval(twitchcallfunc, OPTIONS.refreshInterval)

		$scope.$on('$destroy', (next, current) ->
			clearInterval(twitchInterval);
		)


		$scope.isAuthenticated = mvIdentity.isAuthenticated()

])

.controller('HitboxChannelCtrl', ['$scope', '$routeParams', '$sce', '$http', 'mvFollow', 'mvIdentity', 'mvNotifier', '$location', 'mvRedirect'
	($scope, $routeParams, $sce, $http, mvFollow, mvIdentity, mvNotifier, $location, mvRedirect) ->

		mvRedirect.toHTTP()

		$scope.videoUrl = () ->
			 $sce.trustAsResourceUrl("http://www.hitbox.tv/embed/#{$routeParams.channelUser}?autoplay=true")

		$scope.chatUrl = () ->
			 $sce.trustAsResourceUrl("http://www.hitbox.tv/embedchat/#{$routeParams.channelUser}")

		$scope.channel = {}

		hitboxcallfunc = ->
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
		hitboxcallfunc()
		hitboxInterval = setInterval(hitboxcallfunc, OPTIONS.refreshInterval)

		$scope.$on('$destroy', (next, current) ->
			clearInterval(hitboxInterval);
		)

		$scope.isAuthenticated = mvIdentity.isAuthenticated()

])

.controller('AzubuChannelCtrl', ['$scope', '$routeParams', '$sce', '$http', 'mvFollow', 'mvIdentity', 'mvNotifier', '$location', 'mvRedirect'
	($scope, $routeParams, $sce, $http, mvFollow, mvIdentity, mvNotifier, $location, mvRedirect) ->

		mvRedirect.toHTTP()

		$scope.videoUrl = () ->
			 $sce.trustAsResourceUrl("http://www.azubu.tv/azubulink/embed=#{$routeParams.channelUser}")

		$scope.chatUrl = () ->
			 $sce.trustAsResourceUrl("http://www.azubu.tv/#{$routeParams.channelUser}/chatpopup")

		$scope.channel = {}

		azubucallfunc = ->
			azubucall = $http({
				method: 'GET'
				url: "https://api.azubu.tv/public/channel/#{$routeParams.channelUser}"
			}).success( (data, status, headers, config) ->
				channel =
					username: data.data.user.username
					title: data.data.title
					display_name: data.data.user.display_name
					viewers_number: parseInt(data.data.view_count, 10)
					profile_url: '/img/azubu_profile.png'
					platform: 'azubu'
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
		azubucallfunc()
		azubuInterval = setInterval(azubucallfunc, OPTIONS.refreshInterval)

		$scope.$on('$destroy', (next, current) ->
			clearInterval(azubuInterval);
		)

		$scope.isAuthenticated = mvIdentity.isAuthenticated()

])