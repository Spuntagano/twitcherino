twitcherinoApp = angular.module('twitcherinoApp', [
	'ngRoute',

	'twitcherinoControllers',
	'twitcherinoServices',
	'infinite-scroll'
])

twitcherinoApp.config(['$routeProvider',
	($routeProvider) ->
		$routeProvider.when('/', {
			templateUrl: 'partials/channel-list.html'
			controller: 'ChannelCtrl'
		}).when('/hitbox/:channelUser', {
			templateUrl: 'partials/hitbox.html'
			controller: 'HitboxCtrl'
		}).when('/twitch/:channelUser', {
			templateUrl: 'partials/twitch.html'
			controller: 'TwitchCtrl'
		}).when('/games', {
			templateUrl: 'partials/games.html'
			controller: 'GamesCtrl'
		}).when('/games/:gameName', {
			templateUrl: 'partials/channel-list.html'
			controller: 'GamesChannelsCtrl'
		}).otherwise({
			redirectTo: '/'
		})
	])