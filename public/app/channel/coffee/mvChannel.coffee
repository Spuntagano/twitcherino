angular.module('twitcherinoApp').factory('mvChannel', ['$http', 'mvFollow', 'mvNotifier', ($http, mvFollow, mvNotifier) ->
	{
		twitchFollow: (channelUser) ->
			$http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/streams/#{channelUser}"
				params: {
					callback: 'JSON_CALLBACK'
				}
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			})

		hitboxFollow: (channelUser) ->
			$http({
				method: 'GET'
				url: "https://api.hitbox.tv/media/live/#{channelUser}"
			})
	}
])