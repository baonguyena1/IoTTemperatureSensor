var path = require('path');
var bodyParser = require('body-parser');
var express = require('express');
var mongoose = require('mongoose');
const Q = require('q');

var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

var constant = require('./config/constant')
var database_config = require('./config/database_config');
var Logger = require('./log/log');
var connect_database = require('./config/connect_database');
var middleware = require('./libs/middleware');
const util = require('./libs/utils');

const Status = require('./models/Status');
const User = require('./models/User');

var settingController = require('./controllers/SettingController');
var authController = require('./controllers/AuthController');
const statusController = require('./controllers/StatusController');

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

var userId;

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

    socket.on(constant.SocketIOEvent.CONNECT_USER, function(user_id) {
        Logger.logInfo('connect user = ' + user_id)
        userId = user_id;
    });

    socket.on(constant.SocketIOEvent.DID_UPDATE_TEMPERATURE, function(data) {
        Logger.logInfo(JSON.stringify(data));
        if (userId) {
            updateStatusOfUserId(userId, data)
            .then(() => {
                io.emit(constant.SocketIOEvent.DID_UPDATE_TEMPERATURE, data);
            })
        } else {
            io.emit(constant.SocketIOEvent.DID_UPDATE_TEMPERATURE, data);
        }
        
    });

    socket.on(constant.SocketIOEvent.DID_UPDATE_MANUALSETTING, function(setting) {
        var settingValue = setting ? 1 : 0;
        Logger.logInfo('did update manual setting: ' + settingValue);
        io.emit(constant.SocketIOEvent.DID_UPDATE_MANUALSETTING, settingValue.toString());
    });

    socket.on(constant.SocketIOEvent.DID_UPDATE_MANUAL_SETTING_RESPONSE, function(success) {
        var success = parseInt(success);
        Logger.logInfo('Response = ' + success);
        io.emit(constant.SocketIOEvent.DID_UPDATE_MANUAL_SETTING_RESPONSE, success);
    });

    socket.on(constant.SocketIOEvent.DID_UPDATE_FAN_STATUS, function(status) {
        status = status ? 1 : 0;
        Logger.logInfo('Set fan status = ' + status);
        io.emit(constant.SocketIOEvent.DID_UPDATE_FAN_STATUS, status.toString());
        const data = {
            'fanStatus': status
        }
        if (userId) {
            updateStatusOfUserId(userId, data);
        }
    })

});

app.use(middleware.access_token);
app.use(middleware.verifyAuth);
app.use('/setting/', settingController);
app.use('/auth/', authController);
app.use('/status/', statusController);

function getStatusByUserId(userId) {
    const defer = Q.defer()
    Status.findOne({
        user_id: userId
    })
    .exec(function(error, status) {
        if (error || util.isNull(status)) {
            defer.reject(error);
        } else {
            defer.resolve(status);
        }
    });
    return defer.promise;
}

function saveModel(object) {
    const defer = Q.defer()
    object.save(function(error, obj) {
        if (error || util.isNull(obj)) {
            defer.reject(error);
        } else {
            defer.resolve(obj);
        }
    });
    return defer.promise;
}

function getUserById(userId) {
    var defer = Q.defer();
    User.findById(userId)
    .exec(function(error, user) {
        if (error) {
            defer.reject(error);
        } else {
            defer.resolve(user);
        }
    })
    return defer.promise;
}

function updateStatusOfUserId(userId, data) {
    const defer = Q.defer();
    getStatusByUserId(userId)
    .then((status) => {
        if (data.temperature) {
            status.temperature = data.temp;
        }
        if (data.humidity) {
            status.humidity = data.humi;
        }
        if (data.fanStatus) {
            status.fanStatus = data.fanStatus;
        }
        status.updated_at = new Date();
        return saveModel(status);
    })
    .then((status) => {
        Logger.logInfo(JSON.stringify(status));
        defer.resolve(status);
    })
    .catch((error) => {
        Logger.logError(error);
        defer.reject(error);
    })
    return defer.promise;
}