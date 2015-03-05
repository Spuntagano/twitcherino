angular.module('twitcherinoDirectives', [])

.directive('streamlink', ($timeout) ->
	(element) ->
		$timeout( ->
			$('.streamlink').on('click', ->
				$('nav li.active').removeClass('active')
			)
		)
)