var path = require('path');
var bodyParser = require('body-parser');
var express = require('express');
var mongoose = require('mongoose');

var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

var constant = require('./config/constant')
var database_config = require('./config/database_config');
var Logger = require('./log/log');
var connect_database = require('./config/connect_database');
var middleware = require('./libs/middleware');

var settingController = require('./controllers/SettingController');
var authController = require('./controllers/AuthController');

mongoose = connect_database.connectDatabase(mongoose, database_config.mongodb);

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
    Logger.logInfo('User is connected. socket id: ' + socket.id);

    socket.on(constant.SocketIOEvent.DISCONNECT, function() {
        Logger.logInfo(socket.id + 'is disconnected');
    });

    socket.on(constant.SocketIOEvent.DID_UPDATE_TEMPERATURE, function(data) {
        Logger.logInfo(JSON.stringify(data));
        io.emit(constant.SocketIOEvent.DID_UPDATE_TEMPERATURE, data);
    });

    socket.on(constant.SocketIOEvent.DID_UPDATE_MANUALSETTING, function(setting) {
        var settingValue = setting ? 1 : 0;
        Logger.logInfo('did update manual setting: ' + settingValue);
        io.emit(constant.SocketIOEvent.DID_UPDATE_MANUALSETTING, settingValue.toString());
    });

    socket.on(constant.SocketIOEvent.UPDATE_MANUAL_SETTING_RESPONSE, function(success) {
        var success = parseInt(success);
        Logger.logInfo('Response = ' + success);
        io.emit(constant.SocketIOEvent.UPDATE_MANUAL_SETTING_RESPONSE, success);
    });

});

app.use(middleware.access_token);
app.use(middleware.verifyAuth);
app.use('/setting/', settingController);
app.use('/auth/', authController);