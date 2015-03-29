angular.module('twitcherinoApp', [
	'ngRoute',
	'twitcherinoDirectives',
	'twitcherinoControllers',
	'twitcherinoServices',
	'infinite-scroll'
])

.config(['$routeProvider', '$locationProvider'
	($routeProvider, $locationProvider) ->

		routeRoleChecks = {
			admin: {
				auth: (mvAuth) ->
					mvAuth.authorizedCurrentUserForRoute('admin')
			},
			user: {
				auth: (mvAuth) ->
					mvAuth.authorizedCurrentUserForRoute()
			}
		}

		$locationProvider.html5Mode(true)
		$routeProvider.when('/', {
			templateUrl: '/partials/channels.html'
			controller: 'ChannelsCtrl'
		}).when('/channels', {
			templateUrl: '/partials/channels.html'
			controller: 'ChannelsCtrl'
		}).when('/hitbox/:channelUser', {
			templateUrl: '/partials/channel.html'
			controller: 'HitboxChannelCtrl'
		}).when('/twitch/:channelUser', {
			templateUrl: '/partials/channel.html'
			controller: 'TwitchChannelCtrl'
		}).when('/games', {
			templateUrl: '/partials/games.html'
			controller: 'GamesCtrl'
		}).when('/games/:gameName', {
			templateUrl: '/partials/channels.html'
			controller: 'GamesChannelsCtrl'
		}).when('/admin/users', {
			templateUrl: '/partials/user-list.html'
			controller: 'UserListCtrl'
			resolve: routeRoleChecks.admin
		}).when('/signup', {
			templateUrl: '/partials/signup.html'
			controller: 'SignupCtrl'
		}).when('/profile', {
			templateUrl: '/partials/profile.html'
			controller: 'ProfileCtrl'
			resolve: routeRoleChecks.user
		}).otherwise({
			redirectTo: '/'
		})
	])

angular.module('twitcherinoApp').run( ($rootScope, $location) -> 
	$rootScope.$on('$routeChangeError', (evt, current, previous, rejection) ->
		if (rejection == 'Not authorized')
			$location.path('/')
	)
)