angular.module('twitcherinoApp', [
	'ngRoute',

	'twitcherinoControllers',
	'twitcherinoServices',
	'infinite-scroll'
])

.config(['$routeProvider',
	($routeProvider) ->
		$routeProvider.when('/', {
			templateUrl: 'partials/channels.html'
			controller: 'ChannelsCtrl'
		}).when('/channels', {
			templateUrl: 'partials/channels.html'
			controller: 'ChannelsCtrl'
		}).when('/hitbox/:channelUser', {
			templateUrl: 'partials/channel.html'
			controller: 'HitboxChannelCtrl'
		}).when('/twitch/:channelUser', {
			templateUrl: 'partials/channel.html'
			controller: 'TwitchChannelCtrl'
		}).when('/games', {
			templateUrl: 'partials/games.html'
			controller: 'GamesCtrl'
		}).when('/games/:gameName', {
			templateUrl: 'partials/channels.html'
			controller: 'GamesChannelsCtrl'
		}).otherwise({
			redirectTo: '/'
		})
	])