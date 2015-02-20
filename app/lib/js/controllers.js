'use strict';

/* Controllers */

var channelControllers = angular.module('channelControllers', []);

channelControllers.controller('ChannelCtrl', ['$scope', '$routeParams', 'Channel',
  function($scope, $routeParams, Channel) {
    $scope.channels = Channel.query();
  }
]);