angular.module('twitcherinoApp').factory('mvChannels', ['$http', ($http) ->
	twitchChannels: (offset) ->
		$http({
			method: 'JSONP'
			url: "https://api.twitch.tv/kraken/streams"
			params : {
				callback: 'JSON_CALLBACK'
				limit: OPTIONS.channelsInitial
				offset: offset
			}
			headers: {
				Accept: 'application/vnd.twitchtv.v3+json'
			}
		})

	hitboxChannels: (offset) ->
		$http({
			method: 'GET'
			url: "https://api.hitbox.tv/media"
			params: {
				limit: OPTIONS.channelsInitial
				offset: offset
			}
		})

	azubuChannels: (offset) ->
		$http({
			method: 'GET'
			url: "https://api.azubu.tv/public/channel/live/list"
			params: {
				limit: OPTIONS.channelsInitial
				offset: offset
			}
		})
])