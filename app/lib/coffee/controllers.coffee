twitcherinoControllers = angular.module('twitcherinoControllers', [])

twitcherinoControllers.controller('ChannelCtrl', ['$q', '$http', '$scope', '$routeParams',
	($q, $http, $scope, $routeParams) ->

		if ($scope.offset == undefined)
			$scope.offset = 0

		$scope.loadMore= ->
			hitboxcall = $http({
				method: 'GET'
				url: "http://api.hitbox.tv/media?limit=50&offset=#{$scope.offset}"
			})
			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/streams?callback=JSON_CALLBACK&limit=50&offset=#{$scope.offset}"
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			})

			$q.all([twitchcall, hitboxcall]).then( 
				(result) ->
					channels = {}
					channels.streams = []
					if ($scope.channels == undefined)
						$scope.channels = {}

					if ($scope.channels.streams == undefined)
						$scope.channels.streams = []

					for i in [0...result.length]
						if (result[i].data._links != undefined)
							for j in [0...result[i].data.streams.length]
								channel =
									username: result[i].data.streams[j].channel.name
									viewers_number: parseInt(result[i].data.streams[j].viewers, 10)
									thumbnail_url: result[i].data.streams[j].preview.medium
									link: "#/twitch/#{result[i].data.streams[j].channel.name}"
									platform: 'Twitch'
								$scope.channels.streams.push(channel)
						else if (result[i].data.request != undefined)
							for j in [0...result[i].data.livestream.length]
								channel =
									username: result[i].data.livestream[j].media_user_name
									viewers_number: parseInt(result[i].data.livestream[j].media_views, 10)
									thumbnail_url: "http://edge.sf.hitbox.tv#{result[i].data.livestream[j].media_thumbnail}"
									link: "#/hitbox/#{result[i].data.livestream[j].media_user_name}"
									platform: 'Hitbox'
								$scope.channels.streams.push(channel)

						$scope.offset +=50
			)
		
])

twitcherinoControllers.controller('HitboxCtrl', ['$scope', '$routeParams', '$sce','HitboxChannel'
	($scope, $routeParams, $sce, HitboxChannel) ->
		$scope.hitboxchannel = HitboxChannel.query(channelUser: $routeParams.channelUser)

		$scope.hitboxVideoUrl = (url) ->
			 $sce.trustAsResourceUrl("http://www.hitbox.tv/embed/#{url}")

		$scope.hitboxChatUrl = (url) ->
			 $sce.trustAsResourceUrl("http://www.hitbox.tv/embedchat/#{url}")
])

twitcherinoControllers.controller('TwitchCtrl', ['$scope', '$routeParams', '$sce', 'TwitchChannel',
	($scope, $routeParams, $sce, TwitchChannel) ->
		$scope.twitchchannel = TwitchChannel.query(channelUser: $routeParams.channelUser)

		$scope.twitchVideoUrl = (url) ->
			 $sce.trustAsResourceUrl("http://www.twitch.tv/#{url}/embed");

		$scope.twitchChatUrl = (url) ->
			 $sce.trustAsResourceUrl("http://www.twitch.tv/#{url}/chat");
])

twitcherinoControllers.controller('GamesCtrl', ['$http', '$q', '$scope', '$routeParams',
	($http, $q, $scope, $routeParams) ->

		if ($scope.offset == undefined)
			$scope.offset = 0

		$scope.loadMore= ->
			hitboxcall = $http({
				method: 'GET'
				url: "http://api.hitbox.tv/games?limit=20&offset=#{$scope.offset}"
			})
			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/games/top?callback=JSON_CALLBACK&limit=20&offset=#{$scope.offset}"
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			})

			$q.all([twitchcall, hitboxcall]).then( 
				(result) ->
					cats = {}
					cats.streams = []
					if ($scope.cats == undefined)
						$scope.cats = {}

					if ($scope.cats.categories == undefined)
						$scope.cats.categories = []

					for i in [0...result.length]
						if (result[i].data._links != undefined)
							for j in [0...Object.keys(result[i].data.top).length]
								category =
									category_name: result[i].data.top[j].game.name
									viewers_number: parseInt(result[i].data.top[j].viewers, 10)
									thumbnail_url: result[i].data.top[j].game.box.medium
									link: "#/twitch/#{result[i].data.top[j].game.name}"
								$scope.cats.categories.push(category)
							twitchscopelength = $scope.cats.categories.length
						else if (result[i].data.request != undefined)
							for j in [0...result[i].data.categories.length]
								skip = false
								for k in [0...twitchscopelength]
									if ($scope.cats.categories[k].category_name == result[i].data.categories[j].category_name)
										$scope.cats.categories[k].viewers_number += parseInt(result[i].data.categories[j].category_viewers, 10)
										skip = true
								if (!skip)
									category =
										category_name: result[i].data.categories[j].category_name
										viewers_number: parseInt(result[i].data.categories[j].category_viewers, 10)
										thumbnail_url: "http://edge.sf.hitbox.tv#{result[i].data.categories[j].category_logo_large}"
										link: "#/hitbox/#{result[i].data.categories[j].category_name}"
									$scope.cats.categories.push(category)

						$scope.offset +=20
			)

])


twitcherinoControllers.controller('GamesChannelsCtrl', ['$http', '$q', '$scope', '$routeParams',
	($http, $q, $scope, $routeParams) ->

		if ($scope.offset == undefined)
			$scope.offset = 0

		$scope.loadMore= ->
			hitboxcall = $http({
				method: 'GET'
				url: "http://api.hitbox.tv/media?game=#{$routeParams.gameName}&limit=50&offset=#{$scope.offset}"
			})
			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/streams?game=#{$routeParams.gameName}&callback=JSON_CALLBACK&limit=50&offset=#{$scope.offset}"
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			})

			$q.all([twitchcall, hitboxcall]).then( 
				(result) ->
					console.log("aa")
					channels = {}
					channels.streams = []
					if ($scope.channels == undefined)
						$scope.channels = {}

					if ($scope.channels.streams == undefined)
						$scope.channels.streams = []

					for i in [0...result.length]
						if (result[i].data._links != undefined)
							for j in [0...result[i].data.streams.length]
								channel =
									username: result[i].data.streams[j].channel.name
									viewers_number: parseInt(result[i].data.streams[j].viewers, 10)
									thumbnail_url: result[i].data.streams[j].preview.medium
									link: "#/twitch/#{result[i].data.streams[j].channel.name}"
									platform: 'Twitch'
								$scope.channels.streams.push(channel)
						else if (result[i].data.request != undefined)
							for j in [0...result[i].data.livestream.length]
								channel =
									username: result[i].data.livestream[j].media_user_name
									viewers_number: parseInt(result[i].data.livestream[j].media_views, 10)
									thumbnail_url: "http://edge.sf.hitbox.tv#{result[i].data.livestream[j].media_thumbnail}"
									link: "#/hitbox/#{result[i].data.livestream[j].media_user_name}"
									platform: 'Hitbox'
								$scope.channels.streams.push(channel)

						$scope.offset +=50
			)

])

