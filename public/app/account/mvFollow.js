angular.module('twitcherinoApp').factory('mvFollow', [
  '$http', 'mvIdentity', '$q', function($http, mvIdentity, $q) {
    return {
      isFollowed: function(channelTitle, platform) {
        if (mvIdentity.isAuthenticated()) {
          switch (platform) {
            case 'twitch':
              return mvIdentity.currentUser.twitchFollows.indexOf(channelTitle) > -1;
            case 'hitbox':
              return mvIdentity.currentUser.hitboxFollows.indexOf(channelTitle) > -1;
          }
        }
      },
      addFollow: function(channelTitle, platform) {
        var dfd;
        dfd = $q.defer();
        $http.post('/follow', {
          channelTitle: channelTitle,
          platform: platform,
          user: mvIdentity.currentUser
        }).then(function(response) {
          if (response.data.success) {
            switch (platform) {
              case 'twitch':
                mvIdentity.currentUser.twitchFollows.push(channelTitle);
                break;
              case 'hitbox':
                mvIdentity.currentUser.hitboxFollows.push(channelTitle);
            }
            return dfd.resolve(true);
          } else {
            return dfd.resolve(false);
          }
        });
        return dfd.promise;
      },
      removeFollow: function(channelTitle, platform) {
        var dfd;
        dfd = $q.defer();
        $http.post('/unfollow', {
          channelTitle: channelTitle,
          platform: platform,
          user: mvIdentity.currentUser
        }).then(function(response) {
          var i, _i, _j, _ref, _ref1;
          if (response.data.success) {
            switch (platform) {
              case 'twitch':
                for (i = _i = 0, _ref = mvIdentity.currentUser.twitchFollows.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
                  if (mvIdentity.currentUser.twitchFollows[i] === channelTitle) {
                    mvIdentity.currentUser.twitchFollows.splice(i, 1);
                  }
                }
                break;
              case 'hitbox':
                for (i = _j = 0, _ref1 = mvIdentity.currentUser.hitboxFollows.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
                  if (mvIdentity.currentUser.hitboxFollows[i] === channelTitle) {
                    mvIdentity.currentUser.hitboxFollows.splice(i, 1);
                  }
                }
            }
            return dfd.resolve(true);
          } else {
            return dfd.resolve(false);
          }
        });
        return dfd.promise;
      },
      importTwitchFollows: function(channels) {
        var dfd;
        dfd = $q.defer();
        $http.post('/importtwitchfollows', {
          channels: channels
        }).then(function(response) {
          if (response.data.success) {
            mvIdentity.currentUser.twitchFollows = mvIdentity.currentUser.twitchFollows.concat(channels).unique();
            return dfd.resolve(true);
          } else {
            return dfd.resolve(false);
          }
        });
        return dfd.promise;
      }
    };
  }
]);
