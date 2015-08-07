angular.module('twitcherinoApp').factory('mvGamesChannels', ['$http', ($http) ->
	twitchGamesChannels: (game, offset) ->
		$http({
			method: 'JSONP'
			url: "https://api.twitch.tv/kraken/streams"
			params: {
				callback: 'JSON_CALLBACK'
				game: game
				limit: OPTIONS.gamesInitial
				offset: offset
			}
			headers: {
				Accept: 'application/vnd.twitchtv.v3+json'
			}
		})

	hitboxGamesChannels: (game, offset) ->
		$http({
			method: 'GET'
			url: "https://api.hitbox.tv/media"
			params: {
				game: game
				limit: OPTIONS.gamesInitial
				offset: offset
			}
		})

	azubuGamesChannels: (game, offset) ->
		$http({
			method: 'GET'
			url: "https://api.azubu.tv/public/channel/live/list/game/#{game.replace(/\s+/g, '-').toLowerCase()}" #azubu use different patterns for games urls
			params: {
				limit: OPTIONS.gamesInitial
				offset: offset
			}
		})
])