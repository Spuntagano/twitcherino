angular.module('twitcherinoControllers', [])

.controller('ChannelCtrl', ['$scope', '$routeParams', '$sce', '$http', 'mvIdentity', 'mvNotifier', 'mvChannel', '$location', 'mvRedirect'
	($scope, $routeParams, $sce, $http, mvIdentity, mvNotifier, mvChannel, $location, mvRedirect) ->

		mvRedirect.toHTTP()

		channelName = $routeParams.channelUser
		channelPlatform = $routeParams.platform

		$scope.isAuthenticated = mvIdentity.isAuthenticated()
		$scope.channel = channelName
		$scope.isFollowed = mvChannel.isFollowed(channelName, channelPlatform)

		$scope.videoUrl = () ->
			switch (channelPlatform)
				when 'twitch' then $sce.trustAsResourceUrl("http://www.twitch.tv/#{channelName}/embed") #$sce.trustAsResourceUrl("http://player.twitch.tv/?channel=#{$routeParams.channelUser}")
				when 'hitbox' then $sce.trustAsResourceUrl("http://www.hitbox.tv/embed/#{channelName}?autoplay=true")
				when 'azubu' then $sce.trustAsResourceUrl("http://www.azubu.tv/azubulink/embed=#{$routeParams.channelUser}")
				else
					undefined

		$scope.chatUrl = () ->
			switch (channelPlatform)
				when 'twitch' then $sce.trustAsResourceUrl("http://www.twitch.tv/#{channelName}/chat")
				when 'hitbox' then $sce.trustAsResourceUrl("http://www.hitbox.tv/embedchat/#{channelName}")
				when 'azubu' then $sce.trustAsResourceUrl("http://www.azubu.tv/#{$routeParams.channelUser}/chatpopup")
				else
					undefined

		$scope.addFollow = ->
			mvChannel.addFollow(channelName, channelPlatform).then( ->
				mvNotifier.notify('Channel followed')
				$scope.isFollowed = true
			(reason) ->
				mvNotifier.error(reason)
			)

		$scope.removeFollow = ->
			mvChannel.removeFollow(channelName, channelPlatform).then( ->
				mvNotifier.notify('Channel unfollowed')
				$scope.isFollowed = false
			(reason) ->
				mvNotifier.error(reason)
			)

])