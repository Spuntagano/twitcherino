angular.module('twitcherinoApp').factory('mvUser', ['$resource', ($resource) ->
	UserResource = $resource('/api/users/:id', {_id: '@id'})

	UserResource.prototype.isAdmin = ->
		this.roles && this.roles.indexOf('admin') > -1

	UserResource
])