angular.module('twitcherinoDirectives', [])

.directive('formatnumber', ($timeout) ->
	(scope, element) ->
		$timeout( ->

			viewers = numeral($(element).attr('data-viewers')).format('0,0')
			$(element).text(viewers)

			$(element).attrchange({
				callback : ->
					viewers = numeral($(element).attr('data-viewers')).format('0,0')
					$(element).text(viewers)
			})
		)
)

#fix an issue when trying to link to twitch login
.directive('fixlink', ($timeout) ->
	(scope, element) ->
		$timeout( ->

			href = $(element).attr('href')

			$(element).on('click', ->
				event.preventDefault()
				window.location.replace(href)
			)

		)
)

.directive('profileForm', ->
	restrict: 'E'
	replace: 'true'
	templateUrl: '/partials/account/profile-form'
)

.directive('navbar', ->
	restrict: 'E'
	replace: 'true'
	templateUrl: '/partials/navbar/navbar'
)