twitcherinoControllers = angular.module('twitcherinoControllers', [])

twitcherinoControllers.controller('ChannelCtrl', ['$q', '$http', '$scope', '$routeParams',
	($q, $http, $scope, $routeParams) ->

		if (!$scope.offset?)
			$scope.offset = 0

		if (!$scope.channels?)
			$scope.channels = {}

		if (!$scope.channels.streams?)
			$scope.channels.streams = []

		$scope.loadMore= ->
			hitboxcall = $http({
				method: 'GET'
				url: "http://api.hitbox.tv/media?limit=50&offset=#{$scope.offset}"
			}).success( (data, status, headers, config) ->
				console.log(data)
				for i in [0...data.livestream.length]
					channel =
						username: data.livestream[i].media_user_name
						viewers_number: parseInt(data.livestream[i].media_views, 10)
						thumbnail_url: "http://edge.sf.hitbox.tv#{data.livestream[i].media_thumbnail}"
						link: "#/hitbox/#{data.livestream[i].media_user_name}"
						platform: 'Hitbox'
					$scope.channels.streams.push(channel)
			)

			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/streams?callback=JSON_CALLBACK&limit=50&offset=#{$scope.offset}"
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			}).success( (data, status, headers, config) ->
				console.log(data)
				for i in [0...data.streams.length]
					channel =
						username: data.streams[i].channel.name
						viewers_number: parseInt(data.streams[i].viewers, 10)
						thumbnail_url: data.streams[i].preview.medium
						link: "#/twitch/#{data.streams[i].channel.name}"
						platform: 'Twitch'
					$scope.channels.streams.push(channel)
			)

			$scope.offset +=50
		
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

		if (!$scope.offset?)
			$scope.offset = 0

		if (!$scope.channels?)
			$scope.channels = {}

		if (!$scope.channels.streams?)
			$scope.channels.streams = []

		$scope.loadMore= ->
			hitboxcall = $http({
				method: 'GET'
				url: "http://api.hitbox.tv/games?limit=20&offset=#{$scope.offset}"
			}).success( () ->
				for i in [0...data.categories.length]
					skip = false
					for j in [0...$scope.cats.categories.length]
						if ($scope.cats.categories[j].category_name == data.categories[i].category_name)
							$scope.cats.categories[j].viewers_number += parseInt(data.categories[i].category_viewers, 10)
							skip = true
					if (!skip)
						category =
							category_name: data.categories[i].category_name
							viewers_number: parseInt(data.categories[i].category_viewers, 10)
							thumbnail_url: "http://edge.sf.hitbox.tv#{data.categories[i].category_logo_large}"
							link: "#/hitbox/#{data.categories[i].category_name}"
						$scope.cats.categories.push(category)
			)

			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/games/top?callback=JSON_CALLBACK&limit=20&offset=#{$scope.offset}"
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			}).success( (data, status, headers, config) ->
				for i in [0...Object.keys(data.top).length]
					skip = false
					for j in [0...$scope.cats.categories.length]
						if ($scope.cats.categories[j].category_name == data.top[i].game.name)
							$scope.cats.categories[j].viewers_number += parseInt(data.top[i].viewers, 10)
							skip = true
					if (!skip)
						category =
							category_name: data.top[i].game.name
							viewers_number: parseInt(data.top[i].viewers, 10)
							thumbnail_url: data.top[i].game.box.medium
							link: "#/twitch/#{data.top[i].game.name}"
						$scope.cats.categories.push(category)
			)

			$scope.offset +=50

			###
			$q.all([twitchcall, hitboxcall]).then( 
				(result) ->
					cats = {}
					cats.streams = []
					if (!$scope.cats?)
						$scope.cats = {}

					if (!$scope.cats.categories?)
						$scope.cats.categories = []

					for i in [0...result.length]
						if (result[i].data._links?)
							for j in [0...Object.keys(result[i].data.top).length]
								category =
									category_name: result[i].data.top[j].game.name
									viewers_number: parseInt(result[i].data.top[j].viewers, 10)
									thumbnail_url: result[i].data.top[j].game.box.medium
									link: "#/twitch/#{result[i].data.top[j].game.name}"
								$scope.cats.categories.push(category)
							twitchscopelength = $scope.cats.categories.length
						else if (result[i].data.request?)
							for j in [0...result[i].data.categories.length]
								skip = false
								for k in [0...$scope.cats.categories.length]
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
			###

])


twitcherinoControllers.controller('GamesChannelsCtrl', ['$http', '$q', '$scope', '$routeParams',
	($http, $q, $scope, $routeParams) ->

		if (!$scope.offset?)
			$scope.offset = 0

		if (!$scope.channels?)
			$scope.channels = {}

		if (!$scope.channels.streams?)
			$scope.channels.streams = []

		$scope.loadMore= ->
			hitboxcall = $http({
				method: 'GET'
				url: "http://api.hitbox.tv/media?game=#{$routeParams.gameName}&limit=50&offset=#{$scope.offset}"
			}).success( (data, status, headers, config) ->
				for i in [0...data.livestream.length]
					channel =
						username: data.livestream[i].media_user_name
						viewers_number: parseInt(data.livestream[i].media_views, 10)
						thumbnail_url: "http://edge.sf.hitbox.tv#{data.livestream[i].media_thumbnail}"
						link: "#/hitbox/#{data.livestream[i].media_user_name}"
						platform: 'Hitbox'
					$scope.channels.streams.push(channel)
			)

			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/streams?game=#{$routeParams.gameName}&callback=JSON_CALLBACK&limit=50&offset=#{$scope.offset}"
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			}).success( (data, status, headers, config) ->
				for i in [0...data.streams.length]
					channel =
						username: data.streams[i].channel.name
						viewers_number: parseInt(data.streams[i].viewers, 10)
						thumbnail_url: data.streams[i].preview.medium
						link: "#/twitch/#{data.streams[i].channel.name}"
						platform: 'Twitch'
					$scope.channels.streams.push(channel)
			)

			$scope.offset +=50


])

