angular.module('twitcherinoServices', ['ngResource'])

.factory('HitboxChannel', ['$resource',
	($resource) ->
		$resource('http://api.hitbox.tv/user/:channelUser', {}, {
			query: {method:'GET', isArray:false}
		})
])


.factory('TwitchChannel', ['$resource',
	($resource) ->
		$resource('https://api.twitch.tv/kraken/streams/:channelUser', {}, {
			query: {method:'JSONP', params: {callback : 'JSON_CALLBACK'}, isArray:false, headers: "-H 'Accept: application/vnd.twitchtv.v3+json'"}
		})
])
