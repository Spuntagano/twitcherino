###
angular.module('NoteWrangler')
.directive('title', function($timeout) {
  return function(scope, element) {
    $timeout(function(){
      $(element).tooltip({ container: 'body' });
    });
  }
});
###

angular.module('twitcherinoDirectives', [])

.directive('formatnumber', ($timeout) ->
	(scope, element) ->
		$timeout( ->
			$(element).text(numeral($(element).text()).format('0,0'))
		)
)