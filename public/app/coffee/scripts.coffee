if (!String.prototype.startsWith?())
	String.prototype.startsWith = (str) ->
		this.indexOf(str) == 0

$(document).ready( () ->
    $('.dropdown-login').on('click', (event) ->
        event.stopPropagation()
    )
)