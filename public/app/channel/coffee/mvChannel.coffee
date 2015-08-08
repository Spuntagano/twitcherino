angular.module('twitcherinoApp').factory('mvChannel', ['$http', 'mvIdentity', '$q', '$window', ($http, mvIdentity, $q, $window) ->
	isFollowed: (channelTitle, platform) ->
		if (mvIdentity.isAuthenticated())
			mvIdentity.currentUser.follows[platform]

	addFollow: (channelTitle, platform) ->
		dfd = $q.defer()
		$http.post("/follow", {channelTitle: channelTitle, platform: platform, user: mvIdentity.currentUser}).then( (response) ->
			if (response.data.success)
				mvIdentity.currentUser.follows[platform].push(channelTitle)
				dfd.resolve()
			else
				dfd.reject(reason)
		)
		dfd.promise

	removeFollow: (channelTitle, platform) ->
		dfd = $q.defer()
		$http.post("/unfollow", {channelTitle: channelTitle, platform: platform, user: mvIdentity.currentUser}).then( (response) ->
			if (response.data.success)
				for i in [0...mvIdentity.currentUser.follows[platform].length]
					if (mvIdentity.currentUser.follows[platform][i] == channelTitle)
						mvIdentity.currentUser.follows[platform][i] = undefined
				dfd.resolve()
			else
				dfd.reject(reason)
		)
		dfd.promise
])