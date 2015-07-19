angular.module('twitcherinoApp').factory('mvFollow', ['$http', 'mvIdentity', '$q', ($http, mvIdentity, $q) ->
	isFollowed: (channelTitle, platform) ->
		if (mvIdentity.isAuthenticated())
			switch (platform)
				when 'twitch' then mvIdentity.currentUser.twitchFollows.indexOf(channelTitle) > -1
				when 'hitbox' then mvIdentity.currentUser.hitboxFollows.indexOf(channelTitle) > -1
				when 'azubu' then mvIdentity.currentUser.azubuFollows.indexOf(channelTitle) > -1
	addFollow: (channelTitle, platform) ->
		dfd = $q.defer()
		$http.post("#{window.urls.httpsBaseUrl}/follow", {channelTitle: channelTitle, platform: platform, user: mvIdentity.currentUser}).then( (response) ->
			if (response.data.success)
				switch (platform)
					when 'twitch' then mvIdentity.currentUser.twitchFollows.push(channelTitle)
					when 'hitbox' then mvIdentity.currentUser.hitboxFollows.push(channelTitle)
					when 'azubu' then mvIdentity.currentUser.azubuFollows.push(channelTitle)
				dfd.resolve(true)
			else
				dfd.resolve(false)
		)
		dfd.promise

	removeFollow: (channelTitle, platform) ->
		dfd = $q.defer()
		$http.post("#{window.urls.httpsBaseUrl}/unfollow", {channelTitle: channelTitle, platform: platform, user: mvIdentity.currentUser}).then( (response) ->
			if (response.data.success)
				switch (platform)
					when 'twitch' then for i in [0...mvIdentity.currentUser.twitchFollows.length]
						if (mvIdentity.currentUser.twitchFollows[i] == channelTitle)
							mvIdentity.currentUser.twitchFollows.splice(i, 1)
					when 'hitbox' then for i in [0...mvIdentity.currentUser.hitboxFollows.length]
						if (mvIdentity.currentUser.hitboxFollows[i] == channelTitle)
							mvIdentity.currentUser.hitboxFollows.splice(i, 1)
					when 'azubu' then for i in [0...mvIdentity.currentUser.azubuFollows.length]
						if (mvIdentity.currentUser.azubuFollows[i] == channelTitle)
							mvIdentity.currentUser.azubuFollows.splice(i, 1)
				dfd.resolve(true)
			else
				dfd.resolve(false)
		)
		dfd.promise

	importTwitchFollows: (channels) ->
		dfd = $q.defer()
		$http.post("#{window.urls.httpsBaseUrl}/importtwitchfollows", {channels: channels}).then( (response) ->
			if (response.data.success)
				mvIdentity.currentUser.twitchFollows = mvIdentity.currentUser.twitchFollows.concat(channels).unique()
				dfd.resolve(true)
			else
				dfd.resolve(false)
		)
		dfd.promise
])