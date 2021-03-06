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
			templateUrl: '/partials/channels/channels'
			controller: 'ChannelsCtrl'
		}).when('/channels', {
			templateUrl: '/partials/channels/channels'
			controller: 'ChannelsCtrl'
		}).when('/login', {
			templateUrl: '/partials/account/login'
			controller: 'LoginCtrl'
		}).when('/hitbox-login', {
			templateUrl: '/partials/account/hitbox-login'
			controller: 'HitboxLoginCtrl'
			resolve: routeRoleChecks.user
		}).when('/follow', {
			templateUrl: '/partials/follow/follow'
			controller: 'FollowCtrl'
		}).when('/games', {
			templateUrl: '/partials/games/games'
			controller: 'GamesCtrl'
		}).when('/games/:gameName', {
			templateUrl: '/partials/gameschannels/gamesChannels'
			controller: 'GamesChannelsCtrl'
		}).when('/admin/users', {
			templateUrl: '/partials/account/user-list'
			controller: 'UserListCtrl'
			resolve: routeRoleChecks.admin
		}).when('/signup', {
			templateUrl: '/partials/account/signup'
			controller: 'SignupCtrl'
		}).when('/profile', {
			templateUrl: '/partials/account/profile'
			controller: 'ProfileCtrl'
			resolve: routeRoleChecks.user
		}).when('/:platform/:channelUser', {
			templateUrl: '/partials/channel/channel'
			controller: 'ChannelCtrl'
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