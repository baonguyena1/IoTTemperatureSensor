var express = require('express');
var router = express.Router();
var Q = require('q');

var Logger = require('../log/log');
var constant = require('../config/constant');
var Setting = require('../models/Setting');

router.get('/test', function(req, res) {
    Logger.logInfo('[BEGIN] Test');
    function createNewSetting() {
        var defer = Q.defer();
        var setting = new Setting();
        setting.save(function(error, object) {
            if (error) {
                defer.reject(error);
            } else {
                defer.resolve(object);
            }
        });
        return defer.promise;
    }

    createNewSetting()
    .then(function(setting) {
        res.send(setting);
    })
    .catch(function(error) {
        Logger.logError(JSON.stringify(error));
        res.send(error);
    })
    .then(function() {
        Logger.logInfo('[END] Test');
    })
});

router.get('/setting', function(req, res) {
    function getSetting() {
        var defer = Q.defer()
        Setting.find(function(error, settings) {
            if (error) {
                defer.reject(error);
            } else {
                defer.resolve(settings);
            }
        });
        return defer.promise;
    }

    Logger.logInfo('[BEGIN] Get Setting');
    getSetting()
    .then(function(settings) {
        res.send(settings);
    })
    .catch(function(error) {
        Logger.logError(JSON.stringify(error));
        res.send(error);
    })
    .then(function() {
        Logger.logInfo('[END] Get Setting');
    })
});

module.exports = router;