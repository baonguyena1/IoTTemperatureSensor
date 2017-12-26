var express = require('express');
var router = express.Router();
var Q = require('q');

var util = require('../libs/utils');
var Logger = require('../log/log');
var constant = require('../config/constant');
var Status = require('../models/Status');

router.get('/', (req, res) => {
    getStatusByUserId(req.user_id)
    .then((status) => {
        util.responseSuccess(res, status);
    })
    .catch((error) => {
        Logger.logError(error);
        util.responseFail(res);
    })
    .then(() => {

    });
});

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

module.exports = router;