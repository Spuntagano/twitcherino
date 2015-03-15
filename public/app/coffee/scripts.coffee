if (!String.prototype.startsWith?())
	String.prototype.startsWith = (str) ->
		this.indexOf(str) == 0