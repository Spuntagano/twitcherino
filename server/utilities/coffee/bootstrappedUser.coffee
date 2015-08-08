exports.bootstrappedUser = (collection) ->
	bootstrappedUser = false
	has_pw = false
	if (collection && collection.hashed_pwd)
		has_pw = true
	if (collection)
		bootstrappedUser =
			username: collection.username
			twitchtvUsername: collection.twitchtvUsername
			follows: collection.follows
			roles: collection.roles
			has_pw: has_pw