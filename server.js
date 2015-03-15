var express = require('express'),
	logger = require('morgan'),
	bodyParser = require('body-parser'),
	mongoose = require('mongoose');

var env = process.env.MODE_ENV = process.env.MODE_ENV || 'development';

var app = express();

app.set('views', __dirname + '/server/views');
app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');

app.use(logger('dev'));
app.use(bodyParser());

app.use(express.static(__dirname + '/public'));
if (env === 'development'){
	mongoose.connect('mongodb://localhost/twitcherino');
} else{
	mongoose.connect('mongodb://Spuntagano:bobcat3821@ds043170.mongolab.com:43170/heroku_app34924980');
}

var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error...'));
db.once('open', function callback(){
	console.log('twitcherino db opened');
});

var messageSchema = mongoose.Schema({message: String});
var Message = mongoose.model('Message', messageSchema);
var mongoMessage;
Message.findOne().exec(function(err, messageDoc){
	mongoMessage = messageDoc.message;
});

app.get('/partials/:partialPath', function(req, res){
	res.render('partials/' + req.params.partialPath);
});

app.get('*', function(req, res){
	res.render('index');
});

var port = process.env.PORT || 3030;
app.listen(port);
console.log('Listening on port ' + port + '...');