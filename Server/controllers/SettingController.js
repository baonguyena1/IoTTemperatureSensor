var express = require('express');
var router = express.Router();
var Q = require('q');

var util = require('../libs/utils');
var Logger = require('../log/log');
var constant = require('../config/constant');
var Setting = require('../models/Setting');
const Status = require('../models/Status');

router.get('/test', function(req, res) {
    Logger.logInfo('[BEGIN] Test');
    function createNewSetting(req) {
        var defer = Q.defer();
        var setting = new Setting();
        setting.user_id = req.user_id;
        setting.save(function(error, object) {
            if (error) {
                defer.reject(error);
            } else {
                defer.resolve(object);
            }
        });
        return defer.promise;
    }

    function createNewStatus(req) {
        const defer = Q.defer();
        const status = new Status();
        status.user_id = req.user_id;
        status.save(function(error, object) {
            if (error) {
                defer.reject(error);
            } else {
                defer.resolve(object);
            }
        });
        return defer.promise;
    }

    createNewSetting(req)
    .then(function(setting) {
        util.responseSuccess(res, setting);
    })
    .catch(function(error) {
        Logger.logError(JSON.stringify(error));
        util.responseFail(res);
    })
    .then(function() {
        Logger.logInfo('[END] Test');
    })
    // createNewStatus(req)
    // .then(function(status) {
    //     util.responseSuccess(res, status);
    // })
    // .catch(function(error) {
    //     Logger.logError(JSON.stringify(error));
    //     util.responseFail(res);
    // })
    // .then(function() {
    //     Logger.logInfo('[END] Test');
    // })
});

router.get('/setting', function(req, res) {
    function getSetting() {
        var defer = Q.defer()
        Setting.findOne({
            user_id: req.user_id
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

    Logger.logInfo('[BEGIN] Get Setting');
    getSetting()
    .then(function(settings) {
        util.responseSuccess(res, settings);
    })
    .catch(function(error) {
        Logger.logError(JSON.stringify(error));
        util.responseFail(res);
    })
    .then(function() {
        Logger.logInfo('[END] Get Setting');
    })
});

module.exports = router;