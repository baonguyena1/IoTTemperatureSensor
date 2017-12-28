var constant = require('../config/constant');
var crypto = require('crypto');
var _ = require('underscore');

var utils = {
    responseSuccess: function(res, data) {
        var response = {};
        response[constant.success] = true;
        response[constant.results] = data;
        res.json(response);
    },
    responseFail: function(res) {
        this.responseFailWithMessage(res, 'Something went wrong. Please try again!!!');
    },
    /**
     * 501 is token expire
     */
    responseFailWithMessage: function(res, message, error_code = 500) {
        var response = {};
        response[constant.success] = false;
        response[constant.error_code] = error_code
        response[constant.message] = message
        res.json(response);
    },
    generateToken: function(length) {
        if (length <= 0) {
            return null;
        }
        return crypto.randomBytes(length).toString('base64');
    },
    isNull: function(data) {
        return _.isNull(data) || _.isUndefined(data) || _.isEmpty(data);
    }
}

module.exports = utils;