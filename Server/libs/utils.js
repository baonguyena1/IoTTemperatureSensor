var constant = require('../config/constant');
var crypto = require('crypto');

var utils = {
    responseSuccess: function(res, data) {
        var response = {};
        response[constant.success] = true;
        response[constant.results] = data;
        res.json(response);
    },
    responseFail: function(res) {
        var response = {};
        response[constant.success] = false;
        response[constant.error_code] = 500
        response[constant.message] = 'Something went wrong. Please try again!!!'
        res.json(response);
    },
    generateToken: function(length) {
        if (length <= 0) {
            return null;
        }
        return crypto.randomBytes(length).toString('base64');
    }
}

module.exports = utils;