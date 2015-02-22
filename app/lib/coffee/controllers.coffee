twitcherinoControllers = angular.module('twitcherinoControllers', [])

twitcherinoControllers.controller('ChannelCtrl', ['$scope', '$routeParams', 'HitboxChannel', 'TwitchChannel',
  	($scope, $routeParams, HitboxChannel, TwitchChannel) ->

    	$scope.hitboxchannels = HitboxChannel.query()
    	$scope.twitchchannels = TwitchChannel.query()

    	$scope.layoutDone = ->
    		setTimeout( ->
    			tinysort('.channel-container', {data: 'viewers', order:'desc'})
    			$('.channel-container').show();
    		, 0)
])
