angular.module('twitcherinoControllers').controller('GamesCtrl', ['$http', '$scope', '$routeParams',
	($http, $scope, $routeParams) ->

		$scope.offset = 0
		$scope.cats = {}
		$scope.cats.categories = []

		$scope.loadMore= ->

			twitchcall = $http({
				method: 'JSONP'
				url: "https://api.twitch.tv/kraken/games/top"
				params: {
					callback: 'JSON_CALLBACK'
					limit: OPTIONS.gamesInitial
					offset: $scope.offset
				}
				headers: {
					Accept: 'application/vnd.twitchtv.v3+json'
				}
			}).success( (data, status, headers, config) ->
				for i in [0...Object.keys(data.top).length]
					skip = false
					for j in [0...$scope.cats.categories.length]
						if ($scope.cats.categories[j].category_name == data.top[i].game.name)
							$scope.cats.categories[j].viewers_number += parseInt(data.top[i].viewers, 10)
							$scope.cats.categories[j].thumbnail_url == "https://static-cdn.jtvnw.net/ttv-boxart/#{data.top[i].game.name}-327x457.jpg"
							skip = true
					if (!skip)
						category =
							category_name: data.top[i].game.name
							viewers_number: parseInt(data.top[i].viewers, 10)
							thumbnail_url: "https://static-cdn.jtvnw.net/ttv-boxart/#{data.top[i].game.name}-327x457.jpg"
							link: "/twitch/#{data.top[i].game.name}"
						$scope.cats.categories.push(category)
			)

			setTimeout( -> #hack to get twitch images
				hitboxcall = $http({
					method: 'GET'
					url: "https://api.hitbox.tv/games"
					params: {
						limit: OPTIONS.gamesInitial
						offset: $scope.offset
					}
				}).success( (data, status, headers, config) ->
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
								link: "/hitbox/#{data.categories[i].category_name}"
							$scope.cats.categories.push(category)
				)

				$scope.offset += OPTIONS.gamesIncrement
			, 100)



])