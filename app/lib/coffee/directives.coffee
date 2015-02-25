twitcherinoApp.directive('repeatDone', ->
    (scope, element, attrs) ->
        if (scope.$last)
            scope.$eval(attrs.repeatDone);
        {
            restrict: 'A'
        }
)
###
twitcherinoApp.directive('whenScrolled', ->
	(scope, element, attr) ->
		raw = element[0]
		element.bind('scroll', ->
		    if (raw.scrollTop + raw.offsetHeight >= raw.scrollHeight)
		        scope.$apply(attr.whenScrolled)
		)
)

###