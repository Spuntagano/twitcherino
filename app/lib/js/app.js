'use strict';

/* App Module */

var channelApp = angular.module('channelApp', [
  'ngRoute',

  'channelControllers',
  'channelFilters',
  'channelServices'
]);

channelApp.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/', {
        templateUrl: 'partials/channel-list.html',
        controller: 'ChannelCtrl'
      }).
      otherwise({
        redirectTo: '/'
      });
  }]
);
