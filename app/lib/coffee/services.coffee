twitcherinoServices = angular.module('twitcherinoServices', ['ngResource'])

twitcherinoServices.factory('HitboxChannel', ['$resource',
    ($resource) ->
        $resource('http://api.hitbox.tv/user/:channelUser', {}, {
            query: {method:'GET', isArray:false}
        })
    ])


twitcherinoServices.factory('TwitchChannel', ['$resource',
    ($resource) ->
        $resource('https://api.twitch.tv/kraken/channels/:channelUser', {}, {
            query: {method:'JSONP', params: {callback : 'JSON_CALLBACK'}, isArray:false, headers: "-H 'Accept: application/vnd.twitchtv.v3+json'"}
        })
  ])

