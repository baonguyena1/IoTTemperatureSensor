var express = require('express');
var router = express.Router();
var Q = require('q');

var Logger = require('../log/log');
var constant = require('../config/constant');
var Setting = require('../models/Setting');

router.get('/test', function(req, res) {
    Logger.logInfo('Test...');
    var setting = Setting();
    setting.save(function(error, object) {
        Logger.logInfo(JSON.stringify(object));
    });
    // createNewSetting()
    // .then(function(setting) {
    //     Logger.logInfo('Success: ' + JSON.stringify(setting));
    //     res.send(JSON.stringify(setting));
    // })
    // .catch(function(error) {
    //     Logger.logError('Fail: ' + JSON.stringify(error));
    //     res.send(JSON.stringify(error))
    // })
    // .then(function() {
    //     Logger.logInfo('Done');
    // });

    // function createNewSetting() {
    //     var defered = Q.defer();
    //     var setting = new Setting();
    //     setting.save(function(err, object) {
    //         if (err) {
    //             defered.reject(err);
    //         } else {
    //             defered.resolve(object);
    //         }
    //     });
    //     return defered.promise;
    // }

});

module.exports = router;