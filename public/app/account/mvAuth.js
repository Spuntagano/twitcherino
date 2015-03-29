angular.module('twitcherinoApp').factory('mvAuth', [
  '$http', 'mvUser', 'mvIdentity', '$q', function($http, mvUser, mvIdentity, $q) {
    return {
      authenticateUser: function(username, password) {
        var dfd;
        dfd = $q.defer();
        $http.post('/login', {
          username: username,
          password: password
        }).then(function(response) {
          var user;
          if (response.data.success) {
            user = new mvUser();
            angular.extend(user, response.data.user);
            mvIdentity.currentUser = user;
            dfd.resolve(true);
            return mvIdentity.currentUser = response.data.user;
          } else {
            return dfd.resolve(false);
          }
        });
        return dfd.promise;
      },
      createUser: function(newUserData) {
        var dfd, newUser;
        newUser = new mvUser(newUserData);
        dfd = $q.defer();
        newUser.$save().then(function() {
          mvIdentity.currentUser = newUser;
          return dfd.resolve();
        }, function(response) {
          return dfd.reject(response.data.reason);
        });
        return dfd.promise;
      },
      updateCurrentUser: function(newUserData) {
        var clone, dfd, newClone;
        dfd = $q.defer();
        clone = angular.copy(mvIdentity.currentUser);
        angular.extend(clone, newUserData);
        newClone = new mvUser(clone);
        console.log(newClone);
        newClone.$update().then(function() {
          mvIdentity.currentUser = newClone;
          return dfd.resolve();
        }, function(response) {
          return dfd.reject(response.data.reason);
        });
        return dfd.promise;
      },
      logoutUser: function() {
        var dfd;
        dfd = $q.defer();
        $http.post('/logout', {
          logout: true
        }).then(function() {
          mvIdentity.currentUser = void 0;
          return dfd.resolve();
        });
        return dfd.promise;
      },
      authorizedCurrentUserForRoute: function(role) {
        if (mvIdentity.isAuthorized(role)) {
          return true;
        } else {
          return $q.reject('Not authorized');
        }
      },
      authorizedCurrentUserForRoute: function() {
        if (mvIdentity.isAuthenticated()) {
          return true;
        } else {
          return $q.reject('Not authorized');
        }
      }
    };
  }
]);
