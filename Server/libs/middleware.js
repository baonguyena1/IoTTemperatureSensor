var Q = require('q');
var User = require('../models/User');
var constant = require('../config/constant');
var util = require('./utils');
var message = require('../config/message');

var middleware = {
    access_token: function(req, res, next) {
        var token = req.headers['access_token'];
        if (!util.isNull(token)) {
            var user_id = token.split(constant.access_tokenizer, 1)[0];
            var tokenizer_index = (user_id + constant.access_tokenizer).length;
            var access_token = token.substring(tokenizer_index);
            req.user_id = user_id;
            req.access_token = access_token;
        } 
        next();
    },
    verifyAuth: function(req, res, next) {

        var checkURLWithoutToken = function(url) {
            var checkUrl = false;
            if(constant.url_without_tokens_with_parameter.length == 0) {
                return false;
            } else {
                constant.url_without_tokens_with_parameter.forEach(function(sub_url) {
                    if( url.indexOf(sub_url) > -1) {
                        checkUrl = true;
                        return false;
                    }
                });
                return checkUrl;
            }
        }

        var isExpiredToken = function(token) {
            var token_expire = token.token_expire;
            var current_day = new Date();
            var date = new Date(token_expire).getTime() - new Date(current_day).getTime();
            var diffDays = Math.ceil(date / (1000 * 3600 * 24));
            if (diffDays < 0) {
                return false;
            } else {
                return true;
            }
        }

        var url = req.url.replace(/^(\/)(.*)(\/)$/i, "$2");
        if (constant.url_without_tokens.indexOf(url) > -1 || checkURLWithoutToken(url)) {
            next();
        } else {
            if (req.access_token) {
                User.findOne({
                    _id: req.user_id ,
                    'tokens.access_token': req.access_token
                })
                .exec(function(error, user) {
                    if (error || util.isNull(user)) {
                        util.responseFailWithMessage(res, message.token_invalid, 501);
                    } else {

                        var is_expired_curent_token = true;
                        var tokens = user.tokens;
                        for (var i = 0; i < tokens.length; i++) {
                            var token = tokens[i];
                            var is_expired = isExpiredToken(token);
                            if (token.access_token == req.access_token && is_expired === false) {
                                is_expired_curent_token = false;
                                tokens.splice(i, 1);
                            } else if (is_expired === false) {
                                tokens.splice(i, 1);
                            }
                        }

                        user.tokens = tokens;
                        user.save();
                        if (is_expired_curent_token === false) {
                            util.responseFailWithMessage(res, message.token_expire, 501);
                        } else {
                            next();
                        }

                    }
                });
                
            } else {
                util.responseFailWithMessage(res, message.token_expire, 501);
            }

        }

    }

}

module.exports = middleware;