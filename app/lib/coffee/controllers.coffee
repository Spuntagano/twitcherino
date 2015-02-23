twitcherinoControllers = angular.module('twitcherinoControllers', [])

twitcherinoControllers.controller('ChannelCtrl', ['$scope', '$routeParams', 'HitboxChannels', 'TwitchChannels',
  	($scope, $routeParams, HitboxChannels, TwitchChannels) ->

    	$scope.hitboxchannels = HitboxChannels.query()
    	$scope.twitchchannels = TwitchChannels.query()

    	$scope.layoutDone = ->
    		setTimeout( ->
    			tinysort('.sort-container', {data: 'viewers', order:'desc'})
    			$('.sort-container').show();
    		, 0)
])

twitcherinoControllers.controller('HitboxCtrl', ['$scope', '$routeParams', '$sce','HitboxChannel'
  	($scope, $routeParams, $sce, HitboxChannel) ->
  		$scope.hitboxchannel = HitboxChannel.query(channelUser: $routeParams.channelUser)

  		$scope.hitboxVideoUrl = (url) ->
  		     $sce.trustAsResourceUrl("http://www.hitbox.tv/embed/#{url}")

  		$scope.hitboxChatUrl = (url) ->
  		     $sce.trustAsResourceUrl("http://www.hitbox.tv/embedchat/#{url}")
])

twitcherinoControllers.controller('TwitchCtrl', ['$scope', '$routeParams', '$sce', 'TwitchChannel',
  	($scope, $routeParams, $sce, TwitchChannel) ->
    	$scope.twitchchannel = TwitchChannel.query(channelUser: $routeParams.channelUser)

	    $scope.twitchVideoUrl = (url) ->
	         $sce.trustAsResourceUrl("http://www.twitch.tv/#{url}/embed");

	    $scope.twitchChatUrl = (url) ->
	         $sce.trustAsResourceUrl("http://www.twitch.tv/#{url}/chat");
])

twitcherinoControllers.controller('GamesCtrl', ['$http', '$q', '$scope', '$routeParams',
  	($http, $q, $scope, $routeParams) ->

	    twitchcall = $http({
	      method: 'GET'
	      url: 'http://api.hitbox.tv/games?limit=10'
	    })
	    hitboxcall = $http({
	      method: 'JSONP'
	      url: 'https://api.twitch.tv/kraken/games/top?callback=JSON_CALLBACK'
	    })

	    $q.all([twitchcall, hitboxcall]).then( 
	    	(result) ->
	    		for i in [0...result.length]
	    			if (result[i].data._links != undefined)
	    				$scope.twitchgames = result[i].data
	    			if (result[i].data.request != undefined)
	    				$scope.hitboxgames = result[i].data

	    )

	    $scope.layoutDone = ->
	    	setTimeout( ->
	    		tinysort('.sort-container', {data: 'viewers', order:'desc'})
	    		$('.sort-container').show();
	    	, 0)
])


