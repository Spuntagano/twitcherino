angular.module('twitcherinoControllers', [])

.controller('ChannelCtrl', ['$scope', '$routeParams', '$sce', '$http', 'mvIdentity', 'mvNotifier', 'mvChannel', '$location', 'mvRedirect', 'mvAuth'
	($scope, $routeParams, $sce, $http, mvIdentity, mvNotifier, mvChannel, $location, mvRedirect, mvAuth) ->

		#mvRedirect.toHTTP()

		channelName = $routeParams.channelUser
		channelPlatform = $routeParams.platform

		$scope.channel = channelName

		$scope.showFollowBtn = false
		$scope.isFollowed = false

		if (mvIdentity.isAuthenticated())
			mvAuth.getUser(mvIdentity.currentUser).then( ->

				if (channelPlatform == 'twitch' && mvIdentity.isTwitchConnected())
					$scope.showFollowBtn = true
				else if (channelPlatform == 'hitbox' && mvIdentity.isHitboxConnected())
					$scope.showFollowBtn = true

				mvChannel.isFollowed(channelName, channelPlatform).then( (data) ->
					$scope.isFollowed = true
				)	

				$scope.addFollow = ->
					mvChannel.addFollow(channelName, channelPlatform).then( ->
						mvNotifier.notify('Channel followed')
						$scope.isFollowed = true
					(data) ->
						if (data.status == 401 || data.status == 403)
							if (channelPlatform == 'twitch')			
								window.location.replace('/auth/twitchtv')
							else if (channelPlatform == 'hitbox')
								mvAuth.disconectHitbox(mvIdentity.channelUser.username)
								mvNotifier.error('Your Hitbox account has been deactivated, please reactivate it to continue')
						else
							mvNotifier.error('Follow failed')
					)

				$scope.removeFollow = ->
					mvChannel.removeFollow(channelName, channelPlatform).then( ->
						mvNotifier.notify('Channel unfollowed')
						$scope.isFollowed = false
					(data) ->
						if (data.status == 401 || data.status == 403)
							if (channelPlatform == 'twitch')			
								window.location.replace('/auth/twitchtv')
							else if (channelPlatform == 'hitbox')
								mvAuth.disconectHitbox(mvIdentity.currentUser.username)
								mvNotifier.error('Your Hitbox account has been deactivated, please reactivate it to continue')
						else
							mvNotifier.error('Follow failed')
					)
			)

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
])