var express = require('express');
var router = express.Router();
var Q = require('q');
var crypto = require('crypto');

var util = require('../libs/utils');
var Logger = require('../log/log');
var constant = require('../config/constant');
var User = require('../models/User');
var message = require('../config/message');

router.post('/login', function(req, res) {
    var username = req.body.username.trim();
    var password = req.body.password.trim();
    if (util.isNull(username) || util.isNull(password)) {
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
        var token = user.id + constant.access_tokenizer + access_token;
        Logger.logInfo('Token = ' + token);

        user.tokens.push({
            access_token: access_token,
            expire_date: expire_date
        });
        return saveUser(user)
        .then(function(user) {
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

router.post('/register', function(req, res) {
    var username = req.body.username.trim();
    var password = req.body.password.trim();

    Logger.logInfo('[BEGIN] register. username = ' + username);
    isExistsUsername(username)
    .then(function(user) {
        Logger.logError('User is exists.');
        util.responseFailWithMessage(res, 'Username is exists. Please try with another username.');
    })
    .catch(function(error) {
        password = crypto.createHash('sha1').update(password).digest('hex');
        var user = new User();
        user.username = username;
        user.password = password;

        var current_date = new Date();
        current_date.setDate(current_date.getDate(), constant.token_length);
        var expire_date = current_date;
        var access_token = util.generateToken(constant.token_length);
        var token = user.id + constant.access_tokenizer + access_token;
        Logger.logInfo('Token = ' + token);

        user.tokens.push({
            access_token: access_token,
            expire_date: expire_date
        });
        return saveUser(user)
        .then(function(user) {
            var data = {
                '_id': user.id,
                'username': user.username,
                'access_token': token
            };
            util.responseSuccess(res, data);
        })
    })
    .then(function(error){
        util.responseFail(res);
    })
    .then(function() {
        Logger.logInfo('[END] register');
    });
});

router.get('/logout', function(req, res) {
    var access_token = req.access_token;
    var user_id = req.user_id;
    Logger.logInfo('[BEGIN] logout');
    User.findOne({
        _id: user_id,
        'tokens.access_token': access_token
    })
    .exec(function(error, user) {
        if (error || util.isNull(user)) {
            util.responseFailWithMessage(res, message.token_invalid);
        } else {
            var tokens = user.tokens;
            for (var i = 0; i < tokens.length; i++) {
                var token = tokens[i];
                if (token.access_token == access_token) {
                    tokens.splice(i, 1);
                    break;
                }
            }

            user.tokens = tokens;
            saveUser(user)
            .then(function(user) {
                util.responseSuccess(res, {});
            })
            .catch(function(error) {
                Logger.logError(error);
                util.responseFailWithMessage(res, message.token_invalid);
            })
            .then(function() {
                Logger.logInfo('[END] logout');
            });
        }
    });

})

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

function isExistsUsername(username) {
    var defer = Q.defer();
    User.findOne({
        username: username
    })
    .exec(function(error, user) {
        if (error || util.isNull(user)) {
            defer.reject(null);
        } else {
            defer.resolve(user);
        }
    });
    return defer.promise;
}

function saveUser(user) {
    var defer = Q.defer();
    user.save(function(error, object) {
        if (error) {
            defer.reject(error);
        } else {
            defer.resolve(object);
        }
    })
    return defer.promise;
}

module.exports = router;