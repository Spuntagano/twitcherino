angular.module('twitcherinoApp').factory('mvGames', ['$http', ($http) ->
	twitchGames: (offset) ->
		$http({
			method: 'JSONP'
			url: "https://api.twitch.tv/kraken/games/top"
			params: {
				callback: 'JSON_CALLBACK'
				limit: OPTIONS.gamesInitial
				offset: offset
			}
			headers: {
				Accept: 'application/vnd.twitchtv.v3+json'
			}
		})

	hitboxGames: (offset) ->
		$http({
			method: 'GET'
			url: "https://api.hitbox.tv/games"
			params: {
				limit: OPTIONS.gamesInitial
				offset: offset
			}
		})
])