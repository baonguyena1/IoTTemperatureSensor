'use strict';

const Q = require('q');
var _ = require('underscore');

const constant = require('./config/constant')
const Logger = require('./log/log');
const util = require('./libs/utils');
const Status = require('./models/Status');
const User = require('./models/User');
const Setting = require('./models/Setting');

const settingController = require('./controllers/SettingController');
const authController = require('./controllers/AuthController');
const statusController = require('./controllers/StatusController');

class Routes {
    constructor(app, socket) {
        this.app = app;
        this.io = socket;
        this.users = [];
        this.userId = "";
    }

    appRoutes() {
        this.app.get('/', (req, res) => {
            res.send('Welcome to Vietlott Application!');
        });
        this.app.use('/setting/', settingController);
        this.app.use('/auth/', authController);
        this.app.use('/status/', statusController);
    }

    socketEvents() {
        this.io.on(constant.SocketIOEvent.CONNECTION, (socket) => {
            Logger.logInfo('User is connected. socket id: ' + socket.id);


            socket.on(constant.SocketIOEvent.BORADCAST_DEVICE, (deviceId) => {

                Logger.logInfo('[INFO] Broadcast device id = ' + deviceId);
                let coditional = {
                    device_list: { $in: [deviceId] }
                }
                this.getUserByCoditional(coditional)
                .then((user) => {
                    return this.getSettingByUserId(user.id)
                })
                .then((setting) => {
                    let data = {};
                    data.manualSetting = setting.manualSetting;
                    data.highTempEnable = setting.highTempEnable;
                    data.highTemp = setting.highTemp.toString();
                    data.lowTempEnable = setting.lowTempEnable;
                    data.lowTemp = setting.lowTemp.toString();
                    this.io.emit(constant.SocketIOEvent.CURRENT_SETTING, data);
                });

            })

            socket.on(constant.SocketIOEvent.DISCONNECT, () => {
                Logger.logInfo(socket.id + 'is disconnected');
                for (let i = 0; i < this.users.length; i++) {
                    if (this.users[i].socket_id === socket.id) {
                        this.users.splice(i, 1);
                        break;
                    }
                }
            });
        
            socket.on(constant.SocketIOEvent.CONNECT_USER, (user_id) => {

                Logger.logInfo('connect user = ' + user_id)
                let coditional = {
                    _id: user_id
                };
                this.getUserByCoditional(coditional)
                .then((user) => {
                    user.socketId = socket.id;
                    return this.saveModel(user);
                })
                this.users.push({
                    socket_id: socket.id,
                    user_id: user_id
                });
                this.userId = user_id;
            });
            
            /**
             * ESP8266 send event update temperature
             */
            socket.on(constant.SocketIOEvent.DID_UPDATE_TEMPERATURE, (data) => {

                Logger.logInfo(JSON.stringify(data));
                if (this.userId) {
                    this.updateStatusOfUserId(this.userId, data)
                    .then(() => {
                        this.io.emit(constant.SocketIOEvent.DID_UPDATE_TEMPERATURE, data);
                    })
                } else {
                    this.io.emit(constant.SocketIOEvent.DID_UPDATE_TEMPERATURE, data);
                }
                
            });
        
            /**
             * Client send event
             */
            socket.on(constant.SocketIOEvent.DID_UPDATE_MANUALSETTING, (setting) => {
                var settingValue = setting ? 1 : 0;
                Logger.logInfo('did update manual setting: ' + settingValue);
                if (this.userId) {
                    this.updateSettingOfUserId(this.userId, { 'manualSetting': setting })
                    .then(() => {
                        this.io.emit(constant.SocketIOEvent.DID_UPDATE_MANUALSETTING, settingValue.toString());
                    })
                } else {
                    this.io.emit(constant.SocketIOEvent.DID_UPDATE_MANUALSETTING, settingValue.toString());
                }
            });
        
            /**
             * Client send event
             */
            socket.on(constant.SocketIOEvent.DID_UPDATE_FAN_STATUS, (status) => {
                status = status ? 1 : 0;
                Logger.logInfo('Set fan status = ' + status);
                this.io.emit(constant.SocketIOEvent.DID_UPDATE_FAN_STATUS, status.toString());
                const data = {
                    'fanStatus': status
                }
                if (userId) {
                    updateStatusOfUserId(userId, data);
                }
            });
        
            /**
             * Client send event
             */
            socket.on(constant.SocketIOEvent.DID_UPDATE_SETTING, (data) => {
                Logger.logInfo('did update setting, data = ' + JSON.stringify(data));
                if (this.userId) {
                    this.updateSettingOfUserId(this.userId, data)
                    .then(() => {
                        this.io.emit(constant.SocketIOEvent.DID_UPDATE_SETTING, data);
                    })
                } else {
                    this.io.emit(constant.SocketIOEvent.DID_UPDATE_SETTING, data);
                }
            });
        
        });
    }

    routesConfig() {
        this.appRoutes();
        this.socketEvents();
    }

    getStatusByUserId(userId) {
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
    
    saveModel(object) {
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
    
    getUserByCoditional(coditional) {
        var defer = Q.defer();
        User.findOne(coditional)
        .exec(function(error, user) {
            if (error) {
                defer.reject(error);
            } else {
                defer.resolve(user);
            }
        })
        return defer.promise;
    }
    
    getSettingByUserId(userId) {
        var defer = Q.defer()
        Setting.findOne({
            user_id: userId
        })
        .exec((error, setting) => {
            if (error || util.isNull(setting)) {
                defer.reject(error);
            } else {
                defer.resolve(setting);
            }
        });
        return defer.promise;
    }
    
    updateStatusOfUserId(userId, data) {
        const defer = Q.defer();
        this.getStatusByUserId(userId)
        .then((status) => {
            if (data.temperature) {
                status.temperature = data.temperature;
            }
            if (data.humidity) {
                status.humidity = data.humidity;
            }
            if (data.fanStatus) {
                status.fanStatus = data.fanStatus;
            }
            status.updated_at = new Date();
            return this.saveModel(status);
        })
        .then((result) => {
            defer.resolve(result);
        })
        .catch((error) => {
            Logger.logError(error);
            defer.reject(error);
        })
        return defer.promise;
    }
    
    updateSettingOfUserId(userId, data) {
        const defer = Q.defer();
        this.getSettingByUserId(userId)
        .then((setting) => {
            if (!_.isNull(data.manualSetting) && !_.isUndefined(data.manualSetting)) {
                setting.manualSetting = data.manualSetting;
            }
            if (!_.isNull(data.highTempEnable) && !_.isUndefined(data.highTempEnable)) {
                setting.highTempEnable = data.highTempEnable;
            }
            if (data.highTemp) {
                setting.highTemp = data.highTemp;
            }
            setting.updated_at = new Date();
            return this.saveModel(setting);
        })
        .then((result) => {
            defer.resolve(result);
        })
        .catch((error) => {
            Logger.logError(error);
            defer.reject(error);
        })
        return defer.promise;
    }
}

module.exports = Routes;