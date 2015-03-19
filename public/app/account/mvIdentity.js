angular.module('twitcherinoApp').factory('mvIdentity', function() {
  return {
    currentUser: void 0,
    isAuthenticated: function() {
      return !!this.currentUser;
    }
  };
});
