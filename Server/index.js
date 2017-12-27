'use strict';

var path = require('path');
var bodyParser = require('body-parser');
var express = require('express');
var mongoose = require('mongoose');

var constant = require('./config/constant')
var database_config = require('./config/database_config');
var Logger = require('./log/log');
var connect_database = require('./config/connect_database');
var middleware = require('./libs/middleware');

const routes = require('./Routes');

class Server {
    constructor() {
        this.app = express();
        this.server = require('http').createServer(this.app);
        this.io = require('socket.io')(this.server);
    }

    appConfig() {
        mongoose = connect_database.connectDatabase(mongoose, database_config.mongodb);

        this.app.use(bodyParser.json());
        this.app.use('/public', express.static(path.join(__dirname, 'public')));
        this.app.use(function (req, res, done) {
            res.header("Access-Control-Allow-Origin", "*");
            res.header("Access-Control-Allow-Headers", "Cache-Control, Pragma, Origin, Authorization, Content-Type, X-Requested-With, access_token");
            res.header('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE');
            res.header("Access-Control-Allow-Credentials", "true");
            return done();
        });
        this.app.use(middleware.access_token);
        this.app.use(middleware.verifyAuth);
    }

    appExecute() {
        this.appConfig();
        new routes(this.app, this.io).routesConfig();

        this.server.listen(constant.listen_port, function() {
            Logger.logInfo('[INFO]App listen at port: ' + constant.listen_port);
         });
    }
}
const app = new Server();
app.appExecute();