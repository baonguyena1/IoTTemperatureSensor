const PORT = 9898;
var path = require('path');
var bodyParser = require('body-parser');
var express = require('express');

var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

app.use(bodyParser.json());
app.use('/public', express.static(path.join(__dirname, 'public')));

app.use(function (req, res, done) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Cache-Control, Pragma, Origin, Authorization, Content-Type, X-Requested-With, access_token");
    res.header('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE');
    res.header("Access-Control-Allow-Credentials", "true");
    return done();
});

app.get('/', function(req, res) {
    res.send('Welcome to Vietlott Application!');
});

server.listen(PORT, function() {
    console.log('[INFO]App listen at port: ' + PORT);
});

io.on('connection', function(client) {
    console.log('Client is connected...');
    console.log(client.id);
    var data = {
        'id': client.id,
        'data': 'response from server'
    }

    client.emit('response', data);
    
    client.on('temperature', function(data) {
        console.log(data);
    });
});