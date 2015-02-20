'use strict';

/* Services */

var channelServices = angular.module('channelServices', ['ngResource']);

channelServices.factory('Channel', ['$resource',
  function($resource){
    return $resource('http://api.hitbox.tv/media', {}, {
      query: {method:'GET', isArray:false}
    });
  }
]);