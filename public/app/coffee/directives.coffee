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