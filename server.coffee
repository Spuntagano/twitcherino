express = require('express')

env = process.env.NODE_ENV = process.env.NODE_ENV || 'development'
app = express()
config = require('./server/config/config')[env]

require('./server/config/express')(app, config)

require('./server/config/mongoose')(config)

require('./server/config/passport')(config)

require('./server/config/routes')(app, config)

app.listen(config.port)
console.log('Listening on port ' + config.port + '...')