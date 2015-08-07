angular.module('twitcherinoApp').factory('mvImport', ['$http', 'mvNotifier', 'mvImportFollows', ($http, mvNotifier, mvImportFollows) ->
	{
		importTwitch: (user) ->
			channels = []

			$http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/users/#{user}/follows/channels"
				params: {
					callback: 'JSON_CALLBACK'
					limit: 100
				}
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			}).success( (data, status, headers, config) ->
				totalFollows = data._total
				followPageCount = Math.ceil(totalFollows / 100)
				for i in [0...data.follows.length]
					channels.push(data.follows[i].channel.name)

				#twitch api only allow 100 channels to be returned at once
				if (followPageCount > 1)
					for j in [1...followPageCount]
						$http({
							method: 'JSONP'
							url: "https://api.twitch.tv/kraken/users/#{user}/follows/channels"
							params: {
								callback: 'JSON_CALLBACK'
								limit: 100
								offset: j * 100
							}
							headers: {
								Accept: 'application/vnd.twitchtv.v3+json'
							}
						}).success( (data, status, headers, config) ->
							for k in [0...data.follows.length]
								channels.push(data.follows[k].channel.name)
								
							mvImportFollows.importFollows(channels, 'twitch').then( ->
								mvNotifier.notify("#{data.follows.length} Channels imported")
							(reason) ->
								mvNotifier.error(reason)
							)

						)
				mvImportFollows.importFollows(channels, 'twitch').then( ->
					mvNotifier.notify("#{data.follows.length} Channels imported")
				(reason) ->
					mvNotifier.error(reason)
				)
			)

		importHitbox: (user) ->
			channels = []

			$http({
				method: 'GET'
				url: 'https://api.hitbox.tv/following/user'
				params: {
					user_name: user
				}
			}).success( (data, status, headers, config) ->
				if (data.message == 'user_not_found')
					mvNotifier.error("Invalid username")
				else
					totalFollows = data.max_results
					followPageCount = Math.ceil(totalFollows / 100)
					for i in [0...data.following.length]
						channels.push(data.following[i].user_name)

					#hitbox api only allow 100 channels to be returned at once
					if (followPageCount > 1)
						for j in [1...followPageCount]
							$http({
								method: 'GET'
								url: "https://api.hitbox.tv/following/user"
								params: {
									user_name: user
									offset: j * 100
									limit: 100
								}
							}).success( (data, status, headers, config) ->
								for k in [0...data.following.length]
									channels.push(data.following[k].user_name)

								mvImportFollows.importFollows(channels, 'hitbox').then( ->
									mvNotifier.notify("#{data.following.length} Channels imported")
								(reason) ->
									mvNotifier.error(reason)
								)
							)

					mvImportFollows.importFollows(channels, 'hitbox').then( ->
						mvNotifier.notify("#{data.following.length} Channels imported")

					(reason) ->
						mvNotifier.error(reason)
					)
			)
	}
])

angular.module('twitcherinoApp').factory('mvImportFollows', ['$q', '$http', 'mvIdentity', ($q, $http, mvIdentity) ->
	{
		importFollows: (channels, platform) ->

			follows = ''

			switch (platform)
				when 'twitch' then follows = mvIdentity.currentUser.twitchFollows
				when 'hitbox' then follows = mvIdentity.currentUser.hitboxFollows
				when 'azubu' then follows = mvIdentity.currentUser.azubuFollows

			dfd = $q.defer()
			$http.post("/importfollows", {channels: channels, platform: platform}).then( (response) ->
				if (response.data.success)
					switch (platform)
						when 'twitch' then mvIdentity.currentUser.twitchFollows = follows.concat(channels).unique()
						when 'hitbox' then mvIdentity.currentUser.hitboxFollows = follows.concat(channels).unique()
						when 'azubu' then mvIdentity.currentUser.azubuFollows = follows.concat(channels).unique()
					dfd.resolve()
				else
					dfd.reject()
			)
	}
])