angular.module('twitcherinoApp').controller('NavigationCtrl', [
  '$scope', '$location', '$http', 'mvIdentity', 'mvNotifier', 'mvAuth', 'mvUser', function($scope, $location, $http, mvIdentity, mvNotifier, mvAuth, mvUser) {
    $scope.identity = mvIdentity;
    $scope.isActive = function(viewLocation) {
      return $location.path().startsWith(viewLocation);
    };
    $scope.signin = function(username, password) {
      return mvAuth.authenticateUser(username, password).then(function(success) {
        if (success) {
          mvNotifier.notify('Welcome');
          return $location.path('/profile');
        } else {
          return mvNotifier.error('Invalid login');
        }
      });
    };
    $scope.signout = function() {
      return mvAuth.logoutUser().then(function() {
        $scope.username = "";
        $scope.password = "";
        mvNotifier.notify('Bye');
        return $location.path('/');
      });
    };
    $scope.isAuthenticated = mvIdentity.isAuthenticated();
    if ((typeof errorMessage !== "undefined" && errorMessage !== null) && errorMessage) {
      mvNotifier.error(errorMessage);
    }
    if ((typeof infoMessage !== "undefined" && infoMessage !== null) && infoMessage) {
      return mvNotifier.notify(infoMessage);
    }
  }
]);
