angular.module('twitcherinoApp').factory('mvRedirect', (mvToastr) ->
	{
		toHTTP: (msg) ->
			console.log('toHTTP')
			if (window.env == "production" && $location.protocol() == 'https')
				window.location.replace("http://#{$location.host()}#{$location.path()}")
		toHTTPS: (msg) ->
			console.log('toHTTPS')
			if (window.env == "production" && $location.protocol() == 'http')
				window.location.replace("https://#{$location.host()}#{$location.path()}")
	}
)