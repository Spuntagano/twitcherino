twitcherinoControllers = angular.module('twitcherinoControllers', [])

twitcherinoControllers.controller('ChannelCtrl', ['$q', '$http', '$scope', '$routeParams',
  	($q, $http, $scope, $routeParams) ->

    	twitchcall = $http({
    	  method: 'GET'
    	  url: 'http://api.hitbox.tv/media?limit=50'
    	})
    	hitboxcall = $http({
    	  method: 'JSONP'
    	  url: 'https://api.twitch.tv/kraken/streams?callback=JSON_CALLBACK&limit=50'
    	  headers: {
    	  	Accept: 'application/vnd.twitchtv.v3+json'
    	  }
    	})

    	$q.all([twitchcall, hitboxcall]).then( 
    		(result) ->
    			channels = {}
    			channels.streams = []
    			for i in [0...result.length]
    				if (result[i].data._links != undefined)
    					for j in [0...result[i].data.streams.length]
	    					channel =
	    						username: result[i].data.streams[j].channel.name
	    						viewers_number: parseInt(result[i].data.streams[j].viewers, 10)
	    						thumbnail_url: result[i].data.streams[j].preview.medium
	    						link: "#/twitch/#{result[i].data.streams[j].channel.name}"
	    						platform: 'Twitch'
	    					channels.streams.push(channel)
    				else if (result[i].data.request != undefined)
    					for j in [0...result[i].data.livestream.length]
	    					channel =
	    						username: result[i].data.livestream[j].media_user_name
	    						viewers_number: parseInt(result[i].data.livestream[j].media_views, 10)
	    						thumbnail_url: "http://edge.sf.hitbox.tv#{result[i].data.livestream[j].media_thumbnail}"
	    						link: "#/hitbox/#{result[i].data.livestream[j].media_views}"
	    						platform: 'Hitbox'
	    					channels.streams.push(channel)

							$scope.channels = channels

    	)

    	$scope.limit = 30
    	
    	$scope.loadMore = ->
    		$scope.limit += 10
    	
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

	    hitboxcall = $http({
	      method: 'GET'
	      url: 'http://api.hitbox.tv/games?limit=10'
	    })
	    twitchcall = $http({
	      method: 'JSONP'
	      url: 'https://api.twitch.tv/kraken/games/top?callback=JSON_CALLBACK'
	      headers: {
	      	Accept: 'application/vnd.twitchtv.v3+json'
	      }
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


