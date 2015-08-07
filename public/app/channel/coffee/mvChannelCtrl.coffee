angular.module('twitcherinoControllers', [])

.controller('TwitchChannelCtrl', ['$scope', '$routeParams', '$sce', '$http', 'mvFollow', 'mvIdentity', 'mvNotifier', 'mvChannel', '$location', 'mvRedirect'
	($scope, $routeParams, $sce, $http, mvFollow, mvIdentity, mvNotifier, mvChannel, $location, mvRedirect) ->

		mvRedirect.toHTTP()

		$scope.isAuthenticated = mvIdentity.isAuthenticated()
		$scope.channel = {}

		$scope.videoUrl = () ->
			 $sce.trustAsResourceUrl("http://www.twitch.tv/#{$routeParams.channelUser}/embed")
			 #$sce.trustAsResourceUrl("http://player.twitch.tv/?channel=#{$routeParams.channelUser}")

		$scope.chatUrl = () ->
			 $sce.trustAsResourceUrl("http://www.twitch.tv/#{$routeParams.channelUser}/chat")

		mvChannel.twitchFollow($routeParams.channelUser).then( (data, status, headers, config) ->

			channelName = data.data.stream.channel.name
			channelPlatform = 'twitch'

			$scope.channel = channelName
			$scope.isFollowed = mvFollow.isFollowed(channelName, channelPlatform)

			$scope.addFollow = ->
				mvFollow.addFollow(channelName, channelPlatform).then( ->
					mvNotifier.notify('Channel followed')
					$scope.isFollowed = true
				(reason) ->
					mvNotifier.error(reason)
				)

			$scope.removeFollow = ->
				mvFollow.removeFollow(channelName, channelPlatform).then( ->
					mvNotifier.notify('Channel unfollowed')
					$scope.isFollowed = false
				(reason) ->
					mvNotifier.error(reason)
				)
		(reason) ->
			mvNotifier.error(reason)
		)

])

.controller('HitboxChannelCtrl', ['$scope', '$routeParams', '$sce', '$http', 'mvFollow', 'mvIdentity', 'mvNotifier', 'mvChannel', '$location', 'mvRedirect'
	($scope, $routeParams, $sce, $http, mvFollow, mvIdentity, mvNotifier, mvChannel, $location, mvRedirect) ->

		mvRedirect.toHTTP()

		$scope.isAuthenticated = mvIdentity.isAuthenticated()
		$scope.channel = {}

		$scope.videoUrl = () ->
			 $sce.trustAsResourceUrl("http://www.hitbox.tv/embed/#{$routeParams.channelUser}?autoplay=true")

		$scope.chatUrl = () ->
			 $sce.trustAsResourceUrl("http://www.hitbox.tv/embedchat/#{$routeParams.channelUser}")

		mvChannel.hitboxFollow($routeParams.channelUser).then( (data, status, headers, config) ->

			channelName: data.livestream[0].media_user_name
			platformName: 'hitbox'

			$scope.channel = channelName
			$scope.isFollowed = mvFollow.isFollowed(channelName, channelPlatform)

			$scope.addFollow = () ->
				mvFollow.addFollow(channelName, channelPlatform).then( ->
					mvNotifier.notify('Channel followed')
					$scope.isFollowed = true
				(reason) ->
					mvNotifier.error(reason)
				)

			$scope.removeFollow = () ->
				mvFollow.removeFollow(channelName, channelPlatform).then( ->
					mvNotifier.notify('Channel unfollowed')
					$scope.isFollowed = false
				(reason) ->
					mvNotifier.error(reason)
				)
			(reason) ->
				mvNotifier.error(reason)
		)
		

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