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
		}).otherwise({
			redirectTo: '/'
		})
	])