angular.module('twitcherinoControllers', []).controller('TwitchChannelCtrl', [
  '$scope', '$routeParams', '$sce', '$http', function($scope, $routeParams, $sce, $http) {
    var twitchcall;
    $scope.videoUrl = function() {
      return $sce.trustAsResourceUrl("http://www.twitch.tv/" + $routeParams.channelUser + "/embed?auto_play=true");
    };
    $scope.chatUrl = function() {
      return $sce.trustAsResourceUrl("http://www.twitch.tv/" + $routeParams.channelUser + "/chat");
    };
    $scope.channel = {};
    return twitchcall = $http({
      method: 'JSONP',
      url: "https://api.twitch.tv/kraken/streams/" + $routeParams.channelUser,
      params: {
        callback: 'JSON_CALLBACK'
      },
      headers: {
        Accept: 'application/vnd.twitchtv.v3+json'
      }
    }).success(function(data, status, headers, config) {
      var channel;
      channel = {
        title: data.stream.channel.status,
        display_name: data.stream.channel.display_name,
        viewers_number: parseInt(data.stream.viewers, 10),
        profile_url: data.stream.channel.logo,
        platform: 'twitch'
      };
      return $scope.channel = channel;
    });
  }
]).controller('HitboxChannelCtrl', [
  '$scope', '$routeParams', '$sce', '$http', function($scope, $routeParams, $sce, $http) {
    var hitboxcall;
    $scope.videoUrl = function() {
      return $sce.trustAsResourceUrl("http://www.hitbox.tv/embed/" + $routeParams.channelUser + "?autoplay=true");
    };
    $scope.chatUrl = function() {
      return $sce.trustAsResourceUrl("http://www.hitbox.tv/embedchat/" + $routeParams.channelUser);
    };
    $scope.channel = {};
    return hitboxcall = $http({
      method: 'GET',
      url: "https://api.hitbox.tv/media/live/" + $routeParams.channelUser
    }).success(function(data, status, headers, config) {
      var channel;
      channel = {
        title: data.livestream[0].media_status,
        display_name: data.livestream[0].media_user_name,
        viewers_number: parseInt(data.livestream[0].media_views, 10),
        profile_url: "https://edge.sf.hitbox.tv" + data.livestream[0].channel.user_logo,
        platform: 'hitbox'
      };
      return $scope.channel = channel;
    });
  }
]).controller('ChannelsCtrl', [
  '$http', '$scope', '$routeParams', function($http, $scope, $routeParams) {
    $scope.offset = 0;
    $scope.channels = {};
    $scope.channels.streams = [];
    return $scope.loadMore = function() {
      var hitboxcall, twitchcall;
      twitchcall = $http({
        method: 'JSONP',
        url: "https://api.twitch.tv/kraken/streams",
        params: {
          callback: 'JSON_CALLBACK',
          limit: channelsInitial,
          offset: $scope.offset
        },
        headers: {
          Accept: 'application/vnd.twitchtv.v3+json'
        }
      }).success(function(data, status, headers, config) {
        var channel, i, _i, _ref, _results;
        _results = [];
        for (i = _i = 0, _ref = data.streams.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          channel = {
            username: data.streams[i].channel.name,
            title: data.streams[i].channel.status,
            display_name: data.streams[i].channel.display_name,
            viewers_number: parseInt(data.streams[i].viewers, 10),
            thumbnail_url: data.streams[i].preview.medium,
            game_thumbnail_url: "https://static-cdn.jtvnw.net/ttv-boxart/" + data.streams[i].channel.game + "-73x100.jpg",
            game_link: "/games/" + data.streams[i].channel.game,
            game_name: data.streams[i].channel.game,
            link: "/twitch/" + data.streams[i].channel.name,
            platform_logo: '/img/twitch_logo.png',
            profile_url: data.streams[i].channel.logo
          };
          _results.push($scope.channels.streams.push(channel));
        }
        return _results;
      });
      hitboxcall = $http({
        method: 'GET',
        url: "https://api.hitbox.tv/media",
        params: {
          limit: channelsInitial,
          offset: $scope.offset
        }
      }).success(function(data, status, headers, config) {
        var channel, i, _i, _ref, _results;
        _results = [];
        for (i = _i = 0, _ref = data.livestream.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          channel = {
            username: data.livestream[i].media_user_name,
            title: data.livestream[i].media_status,
            display_name: data.livestream[i].media_user_name,
            viewers_number: parseInt(data.livestream[i].media_views, 10),
            thumbnail_url: "https://edge.sf.hitbox.tv" + data.livestream[i].media_thumbnail,
            game_thumbnail_url: "https://edge.sf.hitbox.tv" + data.livestream[i].category_logo_large,
            game_link: "/games/" + data.livestream[i].category_name,
            game_name: data.livestream[i].category_name,
            link: "/hitbox/" + data.livestream[i].media_user_name,
            platform_logo: '/img/hitbox_logo.png',
            profile_url: "https://edge.sf.hitbox.tv" + data.livestream[i].channel.user_logo
          };
          _results.push($scope.channels.streams.push(channel));
        }
        return _results;
      });
      return $scope.offset += channelsIncrement;
    };
  }
]).controller('GamesCtrl', [
  '$http', '$scope', '$routeParams', function($http, $scope, $routeParams) {
    $scope.offset = 0;
    $scope.cats = {};
    $scope.cats.categories = [];
    return $scope.loadMore = function() {
      var twitchcall;
      twitchcall = $http({
        method: 'JSONP',
        url: "https://api.twitch.tv/kraken/games/top",
        params: {
          callback: 'JSON_CALLBACK',
          limit: gamesInitial,
          offset: $scope.offset
        },
        headers: {
          Accept: 'application/vnd.twitchtv.v3+json'
        }
      }).success(function(data, status, headers, config) {
        var category, i, j, skip, _i, _j, _ref, _ref1, _results;
        _results = [];
        for (i = _i = 0, _ref = Object.keys(data.top).length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          skip = false;
          for (j = _j = 0, _ref1 = $scope.cats.categories.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; j = 0 <= _ref1 ? ++_j : --_j) {
            if ($scope.cats.categories[j].category_name === data.top[i].game.name) {
              $scope.cats.categories[j].viewers_number += parseInt(data.top[i].viewers, 10);
              $scope.cats.categories[j].thumbnail_url === ("https://static-cdn.jtvnw.net/ttv-boxart/" + data.top[i].game.name + "-327x457.jpg");
              skip = true;
            }
          }
          if (!skip) {
            category = {
              category_name: data.top[i].game.name,
              viewers_number: parseInt(data.top[i].viewers, 10),
              thumbnail_url: "https://static-cdn.jtvnw.net/ttv-boxart/" + data.top[i].game.name + "-327x457.jpg",
              link: "/twitch/" + data.top[i].game.name
            };
            _results.push($scope.cats.categories.push(category));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
      return setTimeout(function() {
        var hitboxcall;
        hitboxcall = $http({
          method: 'GET',
          url: "https://api.hitbox.tv/games",
          params: {
            limit: gamesInitial,
            offset: $scope.offset
          }
        }).success(function(data, status, headers, config) {
          var category, i, j, skip, _i, _j, _ref, _ref1, _results;
          _results = [];
          for (i = _i = 0, _ref = data.categories.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
            skip = false;
            for (j = _j = 0, _ref1 = $scope.cats.categories.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; j = 0 <= _ref1 ? ++_j : --_j) {
              if ($scope.cats.categories[j].category_name === data.categories[i].category_name) {
                $scope.cats.categories[j].viewers_number += parseInt(data.categories[i].category_viewers, 10);
                skip = true;
              }
            }
            if (!skip) {
              category = {
                category_name: data.categories[i].category_name,
                viewers_number: parseInt(data.categories[i].category_viewers, 10),
                thumbnail_url: "http://edge.sf.hitbox.tv" + data.categories[i].category_logo_large,
                link: "/hitbox/" + data.categories[i].category_name
              };
              _results.push($scope.cats.categories.push(category));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        });
        return $scope.offset += gamesIncrement;
      }, 100);
    };
  }
]).controller('GamesChannelsCtrl', [
  '$http', '$scope', '$routeParams', function($http, $scope, $routeParams) {
    $scope.offset = 0;
    $scope.channels = {};
    $scope.channels.streams = [];
    $scope.game_search = true;
    $scope.game_name = $routeParams.gameName;
    return $scope.loadMore = function() {
      var hitboxcall, twitchcall;
      twitchcall = $http({
        method: 'JSONP',
        url: "https://api.twitch.tv/kraken/streams",
        params: {
          callback: 'JSON_CALLBACK',
          game: $routeParams.gameName,
          limit: gamesInitial,
          offset: $scope.offset
        },
        headers: {
          Accept: 'application/vnd.twitchtv.v3+json'
        }
      }).success(function(data, status, headers, config) {
        var channel, i, _i, _ref, _results;
        _results = [];
        for (i = _i = 0, _ref = data.streams.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          channel = {
            username: data.streams[i].channel.name,
            display_name: data.streams[i].channel.display_name,
            title: data.streams[i].channel.status,
            viewers_number: parseInt(data.streams[i].viewers, 10),
            thumbnail_url: data.streams[i].preview.medium,
            game_thumbnail_url: "https://static-cdn.jtvnw.net/ttv-boxart/" + data.streams[i].channel.game + "-73x100.jpg",
            game_link: "/games/" + data.streams[i].channel.game,
            game_name: data.streams[i].channel.game,
            link: "/twitch/" + data.streams[i].channel.name,
            platform_logo: '/img/twitch_logo.png',
            profile_url: data.streams[i].channel.logo
          };
          _results.push($scope.channels.streams.push(channel));
        }
        return _results;
      });
      hitboxcall = $http({
        method: 'GET',
        url: "https://api.hitbox.tv/media",
        params: {
          game: $routeParams.gameName,
          limit: gamesInitial,
          offset: $scope.offset
        }
      }).success(function(data, status, headers, config) {
        var channel, i, _i, _ref, _results;
        _results = [];
        for (i = _i = 0, _ref = data.livestream.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          channel = {
            username: data.livestream[i].media_user_name,
            display_name: data.livestream[i].media_user_name,
            title: data.livestream[i].media_status,
            viewers_number: parseInt(data.livestream[i].media_views, 10),
            thumbnail_url: "https://edge.sf.hitbox.tv" + data.livestream[i].media_thumbnail,
            game_thumbnail_url: "https://edge.sf.hitbox.tv" + data.livestream[i].category_logo_large,
            game_link: "/games/" + data.livestream[i].category_name,
            game_name: data.livestream[i].category_name,
            link: "/hitbox/" + data.livestream[i].media_user_name,
            platform_logo: '/img/hitbox_logo.png',
            profile_url: "https://edge.sf.hitbox.tv" + data.livestream[i].channel.user_logo
          };
          _results.push($scope.channels.streams.push(channel));
        }
        return _results;
      });
      return $scope.offset += gamesIncrement;
    };
  }
]).controller('NavigationCtrl', [
  '$scope', '$location', '$http', 'mvIdentity', 'mvNotifier', 'mvAuth', 'mvUser', function($scope, $location, $http, mvIdentity, mvNotifier, mvAuth, mvUser) {
    $scope.identity = mvIdentity;
    $scope.isActive = function(viewLocation) {
      return $location.path().startsWith(viewLocation);
    };
    $scope.signin = function(username, password) {
      return mvAuth.authenticateUser(username, password).then(function(success) {
        if (success) {
          return mvNotifier.notify('mah nigga');
        } else {
          return mvNotifier.notify('fuk uu');
        }
      });
    };
    return $scope.signout = function() {
      return mvAuth.logoutUser().then(function() {
        $scope.username = "";
        $scope.password = "";
        mvNotifier.notify('peace out nigga');
        return $location.path('/');
      });
    };
  }
]).controller('UserListCtrl', [
  '$scope', 'mvUser', function($scope, mvUser) {
    return $scope.users = mvUser.query();
  }
]).controller('SignupCtrl', [
  '$scope', '$location', 'mvNotifier', 'mvAuth', 'mvUser', function($scope, $location, mvNotifier, mvAuth, mvUser) {
    return $scope.signup = function() {
      var newUserData;
      newUserData = {
        username: $scope.email,
        password: $scope.password,
        firstName: $scope.fname,
        lastName: $scope.lname
      };
      return mvAuth.createUser(newUserData).then(function() {
        mvNotifier.notify('User account created!');
        return $location.path('/');
      }, function(reason) {
        return mvNotifier.error(reason);
      });
    };
  }
]).controller('ProfileCtrl', [
  '$scope', 'mvAuth', 'mvIdentity', 'mvNotifier', function($scope, mvAuth, mvIdentity, mvNotifier) {
    $scope.email = mvIdentity.currentUser.username;
    $scope.fname = mvIdentity.currentUser.firstName;
    $scope.lname = mvIdentity.currentUser.lastName;
    return $scope.update = function() {
      var newUserData;
      newUserData = {
        username: $scope.email,
        firstName: $scope.fname,
        lastName: $scope.lname
      };
      if ($scope.password && $scope.password.length > 0) {
        newUserData.password = $scope.password;
      }
      return mvAuth.updateCurrentUser(newUserData).then(function() {
        return mvNotifier.notify('Your profile has been updated');
      }, function(reason) {
        return mvNotifier.error(reason);
      });
    };
  }
]);
