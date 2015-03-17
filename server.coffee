express = require('express')
mongoose = require('mongoose')

env = process.env.MODE_ENV = process.env.MODE_ENV || 'development'
app = express()
config = require('./server/config/config')[env]

require('./server/config/express')(app, config)
require('./server/config/mongoose')(config)
require('./server/config/routes')(app)

app.listen(config.port)
console.log('Listening on port ' + config.port + '...')