angular.module('twitcherinoApp').value('mvToastr', toastr);

angular.module('twitcherinoApp').factory('mvNotifier', function(mvToastr) {
  return {
    notify: function(msg) {
      mvToastr.success(msg);
      return console.log(msg);
    }
  };
});
