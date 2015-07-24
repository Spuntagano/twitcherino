angular.module('twitcherinoApp').factory('mvUser', ['$resource', ($resource) ->
	UserResource = $resource("/api/user/:id", {_id: '@id'}, {
		update: {method: 'PUT', isArray: false}
	})

	UserResource.prototype.isAdmin = ->
		this.roles && this.roles.indexOf('admin') > -1

	UserResource
])