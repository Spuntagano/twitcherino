###
angular.module('twitcherinoApp').factory('mvImport', ['$http', 'mvNotifier', 'mvImportFollows', ($http, mvNotifier, mvImportFollows) ->
	importTwitch: (user) ->
		channels = []
		maxImport = 100

		mvImportFollows.loadTwitch(user, maxImport, 0).success( (data, status, headers, config) ->
			totalFollows = data._total
			follows = data.follows
			followPageCount = Math.ceil(totalFollows / 100)
			for i in [0...follows.length]
				channels.push(follows[i].channel.name)

			#twitch api only allow 100 channels to be returned at once
			if (followPageCount > 1)
				for j in [1...followPageCount]
					mvImportFollows.loadTwitch(user, maxImport, j).success( (data, status, headers, config) ->
						follows = data.follows
						for k in [0...follows.length]
							channels.push(follows[k].channel.name)
							
						mvImportFollows.importFollows(channels, 'twitch').then( (response) ->
							mvNotifier.notify("#{follows.length} Channels imported")
						(reason) ->
							mvNotifier.error(reason)
						)

					)
			mvImportFollows.importFollows(channels, 'twitch').then( ->
				mvNotifier.notify("#{follows.length} Channels imported")
			(reason) ->
				mvNotifier.error(reason)
			)
		)

	importHitbox: (user) ->
		channels = []
		maxImport = 100

		mvImportFollows.loadHitbox(user, maxImport, 0).success( (data, status, headers, config) ->
			if (data.message == 'user_not_found')
				mvNotifier.error("Invalid username")
			else
				totalFollows = data.max_results
				follows = data.following
				followPageCount = Math.ceil(totalFollows / maxImport)
				for i in [0...follows.length]
					channels.push(follows[i].user_name)

				#hitbox api only allow 100 channels to be returned at once
				if (followPageCount > 1)
					for j in [1...followPageCount]
						mvImportFollows.loadHitbox(user, maxImport, j).success( (data, status, headers, config) ->
							follows = data.following
							for k in [0...follows.length]
								channels.push(follows[k].user_name)

							mvImportFollows.importFollows(channels, 'hitbox').then( ->
								mvNotifier.notify("#{follows.length} Channels imported")
							(reason) ->
								mvNotifier.error(reason)
							)
						)

				mvImportFollows.importFollows(channels, 'hitbox').then( ->
					mvNotifier.notify("#{follows.length} Channels imported")
				(reason) ->
					mvNotifier.error(reason)
				)
		)
])

angular.module('twitcherinoApp').factory('mvImportFollows', ['$q', '$http', 'mvIdentity', ($q, $http, mvIdentity) ->
	importFollows: (channels, platform) ->

		if (!mvIdentity.currentUser.follows)
			mvIdentity.currentUser.follows = {}
		
		if (!mvIdentity.currentUser.follows[platform])
			mvIdentity.currentUser.follows[platform] = []

		follows = mvIdentity.currentUser.follows[platform]

		dfd = $q.defer()
		$http.post("/importfollows", {channels: channels, platform: platform}).then( (response) ->
			if (response.data.success)
				mvIdentity.currentUser.follows[platform] = follows.concat(channels).unique()
				dfd.resolve()
			else
				dfd.reject(response.data.reason)
		)
		dfd.promise

	loadTwitch: (user, maxImport, i) ->
		$http({
			method: 'JSONP'
			url: "https://api.twitch.tv/kraken/users/#{user}/follows/channels"
			params: {
				callback: 'JSON_CALLBACK'
				limit: maxImport
				offset: i * maxImport
			}
			headers: {
				Accept: 'application/vnd.twitchtv.v3+json'
			}
		})

	loadHitbox: (user, maxImport, i) ->
		$http({
			method: 'GET'
			url: "https://api.hitbox.tv/following/user"
			params: {
				user_name: user
				offset: i * maxImport
				limit: maxImport
			}
		})
])
###