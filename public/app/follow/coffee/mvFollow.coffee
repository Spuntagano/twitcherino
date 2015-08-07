angular.module('twitcherinoApp').factory('mvFollow', ['$http', ($http) ->
	twitchFollows: (twitchChannels, offset) ->
		$http({
			method: 'JSONP'
			url: "https://api.twitch.tv/kraken/streams"
			params : {
				channel: twitchChannels
				callback: 'JSON_CALLBACK'
				limit: OPTIONS.channelsInitial
				offset: offset
			}
			headers: {
				Accept: 'application/vnd.twitchtv.v3+json'
			}
		})

	hitboxFollows: (hitboxChannels, offset) ->
		$http({
			method: 'GET'
			url: "https://api.hitbox.tv/media/live/#{hitboxChannels}"
			params: {
				limit: OPTIONS.channelsInitial
				offset: offset
			}
		})

	azubuFollows: (azubuChannels, offset) ->
		$http({
			method: 'GET'
			url: "https://api.azubu.tv/public/channel/list"
			params: {
				limit: OPTIONS.channelsInitial
				offset: offset
				channels: azubuChannels
			}
		})
])