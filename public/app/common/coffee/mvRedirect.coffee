angular.module('twitcherinoApp').factory('mvRedirect', ($location) ->
	{
		###
		toHTTP: (msg) ->
			if ((!window.env || window.env == "production") && $location.protocol() == 'https')
				window.location.replace("http://#{$location.host()}#{$location.path()}")
				$('.loading-overlay').show();

		toHTTPS: (msg) ->
			if ((!window.env || window.env == "production") && $location.protocol() == 'http')
				window.location.replace("https://#{$location.host()}#{$location.path()}")
				$('.loading-overlay').show();
		###
	}
)