angular.module('twitcherinoDirectives', []).directive('formatnumber', function($timeout) {
  return function(scope, element) {
    return $timeout(function() {
      var viewers;
      viewers = numeral($(element).attr('data-viewers')).format('0,0');
      $(element).text(viewers);
      return $(element).attrchange({
        callback: function() {
          viewers = numeral($(element).attr('data-viewers')).format('0,0');
          return $(element).text(viewers);
        }
      });
    });
  };
});
