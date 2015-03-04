angular.module('twitcherinoServices', ['ngResource'])

.factory('HitboxChannel', ['$resource',
	($resource) ->
		$resource('http://api.hitbox.tv/user/:channelUser', {}, {
			query: {method:'GET', isArray:false}
		})
])


.factory('TwitchChannel', ['$resource',
	($resource) ->
		$resource('https://api.twitch.tv/kraken/channels/:channelUser', {}, {
			query: {method:'JSONP', params: {callback : 'JSON_CALLBACK'}, isArray:false, headers: "-H 'Accept: application/vnd.twitchtv.v3+json'"}
		})
])


.provider('LoadChannelsProvider',
	->

		channelOffset = 30
		channelInitial = 30

		this.setOffset = (initial) ->
			channelInitial = initial

		this.setOffset = (offset) ->
			channelOffset = offset

		this.$get = ($http) ->
			loadChannels: ->

				if (!channels?)
					channels = []

					twitchcall = $http({
						method: 'JSONP'
						url: "https://api.twitch.tv/kraken/streams"
						params : {
							callback: 'JSON_CALLBACK'
							limit: channelInitial
							offset: channelOffset
						}
						headers: {
							Accept: 'application/vnd.twitchtv.v3+json'
						}
					}).success( (data, status, headers, config) ->
						for i in [0...data.streams.length]
							channel =
								username: data.streams[i].channel.name
								viewers_number: parseInt(data.streams[i].viewers, 10)
								thumbnail_url: data.streams[i].preview.medium
								link: "#/twitch/#{data.streams[i].channel.name}"
								platform: 'Twitch'
							channels.push(channel)
					)
				return channels
		return

)


###
angular.module('Gravatar', [])
.provider('$gravatar', function() {
  var avatarSize = 80; // Default size
  var avatarUrl = "http://www.gravatar.com/avatar/";

  this.setSize = function(size) {
	avatarSize = size;
  }

  this.$get = function(){
	return {
	  generate: function(email){
		return avatarUrl + CryptoJS.MD5(email) + "?size=" + avatarSize.toString()
	  }
	}
  }
});
###