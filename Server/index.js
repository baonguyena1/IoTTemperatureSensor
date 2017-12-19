var path = require('path');
var bodyParser = require('body-parser');
var express = require('express');

var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

var constant = require('./config/constant')
var database_config = require('./config/database_config');
var Logger = require('./log/log');

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

server.listen(constant.listen_port, function() {
   Logger.logInfo('[INFO]App listen at port: ' + constant.listen_port);
});

io.on(constant.SocketIOEvent.CONNECTION, function(socket) {
    Logger.logInfo('user is connected. socket id: ' + socket.id);

    socket.on(constant.SocketIOEvent.DISCONNECT, function() {
        Logger.logInfo('user disconnected');
    });

    socket.on(constant.SocketIOEvent.DIDUPDATETEMPERATURE, function(data) {
        Logger.logInfo(JSON.stringify(data));
        socket.emit(constant.SocketIOEvent.DIDUPDATETEMPERATURE, data);
    });
});