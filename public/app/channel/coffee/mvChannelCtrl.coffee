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