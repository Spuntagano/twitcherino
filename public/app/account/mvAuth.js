angular.module('twitcherinoApp').factory('mvAuth', function($http, mvIdentity, mvNotifier, $q) {
  return {
    authenticateUser: function(username, password) {
      var dfd;
      dfd = $q.defer();
      console.log(username);
      $http.post('/login', {
        username: username,
        password: password
      }).then(function(response) {
        if (response.data.success) {
          dfd.resolve(true);
          return mvIdentity.currentUser = response.data.user;
        } else {
          return dfd.resolve(false);
        }
      });
      return dfd.promise;
    }
  };
});
