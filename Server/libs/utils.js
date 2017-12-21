var constant = require('../config/constant');

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
    }
}

module.exports = utils;