angular.module('twitcherinoApp').factory('mvIdentity', ->
	{
		currentUser: undefined
		isAuthenticated: ->
			return !!this.currentUser
	}
)