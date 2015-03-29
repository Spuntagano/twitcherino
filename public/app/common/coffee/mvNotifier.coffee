angular.module('twitcherinoApp').value('mvToastr', toastr)

angular.module('twitcherinoApp').factory('mvNotifier', (mvToastr) ->
	{
		notify: (msg) ->
			mvToastr.success(msg)
			console.log(msg)
		error: (msg) ->
			mvToastr.error(msg)
			console.log(msg)
	}
)