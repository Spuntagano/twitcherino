twitcherinoApp.directive('repeatDone', ->
    (scope, element, attrs) ->
        if (scope.$last)
            scope.$eval(attrs.repeatDone);
        {
            restrict: 'A'
        }
)
