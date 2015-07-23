angular.module('twitcherinoApp').factory('mvIdentity', ['$window', 'mvUser', ($window, mvUser) ->

	if (!!$window.bootstrappedUserObject)
		currentUser = new mvUser()
		angular.extend(currentUser, $window.bootstrappedUserObject)
	{
		currentUser: currentUser
		isAuthenticated: ->
			!!this.currentUser
		isAuthorized: (role) ->
			!!this.currentUser && this.currentUser.roles.indexOf('admin') > -1
		isTwitchConnected: ->
			if (!!this.currentUser)
				return !!this.currentUser.twitchtvUsername
			else
				return false
	}
])