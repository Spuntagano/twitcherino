angular.module('twitcherinoApp').factory('mvFollow', ['$http', 'mvIdentity', '$q', ($http, mvIdentity, $q) ->
	isFollowed: (channelTitle, platform) ->
		if (mvIdentity.isAuthenticated())
			switch (platform)
				when 'twitch' then mvIdentity.currentUser.twitchFollows.indexOf(channelTitle) > -1
				when 'hitbox' then mvIdentity.currentUser.hitboxFollows.indexOf(channelTitle) > -1
				when 'azubu' then mvIdentity.currentUser.azubuFollows.indexOf(channelTitle) > -1

	addFollow: (channelTitle, platform) ->
		dfd = $q.defer()
		$http.post("/follow", {channelTitle: channelTitle, platform: platform, user: mvIdentity.currentUser}).then( (response) ->
			console.log(response.data.success)
			console.log(platform)
			console.log(channelTitle)
			if (response.data.success)
				switch (platform)
					when 'twitch' then mvIdentity.currentUser.twitchFollows.push(channelTitle)
					when 'hitbox' then mvIdentity.currentUser.hitboxFollows.push(channelTitle)
					when 'azubu' then mvIdentity.currentUser.azubuFollows.push(channelTitle)
				dfd.resolve()
			else
				dfd.reject()
		)

	removeFollow: (channelTitle, platform) ->
		dfd = $q.defer()
		$http.post("/unfollow", {channelTitle: channelTitle, platform: platform, user: mvIdentity.currentUser}).then( (response) ->
			console.log(response)
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
				dfd.resolve()
			else
				dfd.reject()
		)
])