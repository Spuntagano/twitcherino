angular.module('twitcherinoApp').factory('mvChannel', ['$http', 'mvIdentity', '$q', '$window', '$routeParams', ($http, mvIdentity, $q, $window, $routeParams) ->

	isFollowed: (channelTitle, platform) ->
		switch (platform)
			when 'twitch' then return $http({
				method: 'GET'
				url: "https://api.twitch.tv/kraken/users/#{mvIdentity.currentUser.twitchtvUsername}/follows/channels/#{$routeParams.channelUser}"
				headers : {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			})
			when 'hitbox' then return $http({
				method: 'GET'
				url: "https://api.hitbox.tv/following/user/#{$routeParams.channelUser}"
				params : {
					user_name: mvIdentity.currentUser.hitboxtvUsername
				}
			})

	addFollow: (channelTitle, platform) ->
		switch (platform)
			when 'twitch' then return $http({
				method: 'PUT'
				url: "https://api.twitch.tv/kraken/users/#{mvIdentity.currentUser.twitchtvUsername}/follows/channels/#{$routeParams.channelUser}"
				headers : {
					Accept: 'application/vnd.twitchtv.v3+json'
					Authorization: "OAuth #{mvIdentity.currentUser.twitchtvAccessToken}"
				}
			})
			when 'hitbox' then return $http({
				method: 'POST'
				url: "https://api.hitbox.tv/follow"
				params : {
					authToken: mvIdentity.currentUser.hitboxtvAccessToken
				}
				data : {
					type: 'user'
					follow_id: $routeParams.channelUser
				}
			})

	removeFollow: (channelTitle, platform) ->
		switch (platform)
			when 'twitch' then return $http({
				method: 'DELETE'
				url: "https://api.twitch.tv/kraken/users/#{mvIdentity.currentUser.twitchtvUsername}/follows/channels/#{$routeParams.channelUser}"
				headers : {
					Accept: 'application/vnd.twitchtv.v3+json'
					Authorization: "OAuth #{mvIdentity.currentUser.twitchtvAccessToken}"
				}
			})
			when 'hitbox' then return $http({
				method: 'DELETE'
				url: "https://api.hitbox.tv/follow"
				params : {
					authToken: mvIdentity.currentUser.hitboxtvAccessToken
					type: 'user'
					follow_id: $routeParams.channelUser
				}
			})
])