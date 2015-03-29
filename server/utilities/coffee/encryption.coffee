crypto = require('crypto')

exports.createSalt = () ->
	crypto.randomBytes(128).toString('base64')

exports.hashPwd = (salt, pwd) ->
	hmac = crypto .createHmac('sha1', salt)
	hmac.update(pwd).digest('hex')