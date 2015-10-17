angular.module('twitcherinoApp').factory('mvFollow', ['$http', 'mvIdentity', ($http, mvIdentity) ->
	twitchFollows: (offset) ->
		$http({
			method: 'GET'
			url: "https://api.twitch.tv/kraken/streams/followed"
			params : {
				#channel: twitchChannels
				limit: OPTIONS.channelsInitial
				offset: offset
			}
			headers: {
				Accept: 'application/vnd.twitchtv.v3+json'
				Authorization: "OAuth #{mvIdentity.currentUser.twitchtvAccessToken}"
			}
		})

	
	hitboxFollows: (offset) ->
		$http({
			method: 'GET'
			url: "https://api.hitbox.tv/media/live/list"
			params: {
				limit: OPTIONS.channelsInitial
				offset: offset
				follower_id: mvIdentity.currentUser.hitboxtvId
			}
		})
	###
	azubuFollows: (offset) ->
		$http({
			method: 'GET'
			url: "https://api.azubu.tv/public/channel/list"
			params: {
				limit: OPTIONS.channelsInitial
				offset: offset
				channels: azubuChannels
			}
		})
	###
])