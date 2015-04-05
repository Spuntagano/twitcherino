angular.module('twitcherinoApp').factory('mvIdentity', [
  '$window', 'mvUser', function($window, mvUser) {
    var currentUser;
    if (!!$window.bootstrappedUserObject) {
      currentUser = new mvUser();
      angular.extend(currentUser, $window.bootstrappedUserObject);
    }
    return {
      currentUser: currentUser,
      isAuthenticated: function() {
        return !!this.currentUser;
      },
      isAuthorized: function(role) {
        return !!this.currentUser && this.currentUser.roles.indexOf('admin') > -1;
      },
      isTwitchConnected: function() {
        if (!!this.currentUser) {
          return !!this.currentUser.twitchtvId;
        } else {
          return false;
        }
      }
    };
  }
]);
