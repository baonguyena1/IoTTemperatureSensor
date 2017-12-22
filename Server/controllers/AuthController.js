var express = require('express');
var router = express.Router();
var Q = require('q');
var _ = require('underscore');
var crypto = require('crypto');

var util = require('../libs/utils');
var Logger = require('../log/log');
var constant = require('../config/constant');
var User = require('../models/User');

router.post('/login', function(req, res) {
    var username = req.body.username;
    var password = req.body.password;
    if (isNull(username) || isNull(password)) {
        return util.responseFail(res);
    }
    password = crypto.createHash('sha1').update(password).digest('hex');
    Logger.logInfo('[BEGIN] login, username = ' + username);
    findUser(username, password)
    .then(function(user) {
        
        var current_date = new Date();
        current_date.setDate(current_date.getDate(), constant.token_length);
        var expire_date = current_date;
        var access_token = util.generateToken(constant.token_length);
        var token = user.id + constant.access_tokenizer + token;

        user.tokens.push({
            access_token: access_token,
            expire_date: expire_date
        });
        user.save(function(error) {
            var data = {
                '_id': user.id,
                'username': user.username,
                'access_token': token
            };
            util.responseSuccess(res, data);
        });
    })
    .catch(function(error) {
        Logger.logError(error)
        util.responseFail(res);
    })
    .then(function(){
        Logger.logInfo('[END] login');
    });

    function findUser(username, password) {
        var defer = Q.defer();
        User.findOne({
            username: username,
            password: password
        })
        .exec(function(error, user) {
            if (error) {
                defer.reject(error);
            } else {
                defer.resolve(user);
            }
        });
        return defer.promise;
    }

});

function isNull(data) {
    return _.isNull(data) || _.isUndefined(data) || _.isEmpty(data);
}function isNull(data) {
        return _.isNull(data) || _.isUndefined(data) || _.isEmpty(data);
    }

function getUserByUsername(username) {
    var defer = Q.defer();
    User.findOne({
        username: username
    })
    .exec(function(error, user) {
        if (error) {
            defer.reject(error);
        } else {
            delete user.password;
            delete user.tokens;
            defer.resolve(user);
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
            delete user.password;
            delete user.tokens;
            defer.resolve(user);
        }
    })
    return defer.promise;
}

module.exports = router;