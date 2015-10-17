angular.module('twitcherinoApp').controller('GamesCtrl', ['$http', '$scope', '$routeParams', 'mvGames',
	($http, $scope, $routeParams, mvGames) ->

		$scope.offset = 0
		$scope.cats = {}
		$scope.cats.categories = []

		$scope.loadMore= ->

			mvGames.twitchGames($scope.offset).then( (data) ->
				games = data.data.top
				for i in [0...Object.keys(games).length]
					skip = false
					for j in [0...$scope.cats.categories.length]
						if ($scope.cats.categories[j].category_name == games[i].game.name)
							$scope.cats.categories[j].viewers_number += parseInt(games[i].viewers, 10)
							$scope.cats.categories[j].thumbnail_url == "https://static-cdn.jtvnw.net/ttv-boxart/#{games[i].game.name}-438x614.jpg"
							skip = true
					if (!skip)
						category =
							category_name: games[i].game.name
							viewers_number: parseInt(games[i].viewers, 10)
							thumbnail_url: "https://static-cdn.jtvnw.net/ttv-boxart/#{games[i].game.name}-438x614.jpg"
							link: "/twitch/#{games[i].game.name}"
						$scope.cats.categories.push(category)
			)

			setTimeout( -> #hack to get twitch images
				mvGames.hitboxGames($scope.offset).then( (data) ->
					games = data.data.categories
					for i in [0...games.length]
						skip = false
						for j in [0...$scope.cats.categories.length]
							if ($scope.cats.categories[j].category_name == games[i].category_name)
								$scope.cats.categories[j].viewers_number += parseInt(games[i].category_viewers, 10)
								skip = true
						if (!skip)
							category =
								category_name: games[i].category_name
								viewers_number: parseInt(games[i].category_viewers, 10)
								thumbnail_url: "http://edge.sf.hitbox.tv#{games[i].category_logo_large}"
								link: "/hitbox/#{games[i].category_name}"
							$scope.cats.categories.push(category)
				)

			, 100)

			$scope.offset += OPTIONS.gamesIncrement
			#azubu api dosen't support listing of all games... RIP


])