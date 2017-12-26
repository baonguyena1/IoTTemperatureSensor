var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var userSchema = new Schema({
    username: {
        type: String,
        unique: true,
        required: true
    },
    password: {
        type: String,
        required: true,
        select: false
    },
    socketId: {
        type: String
    },
    tokens: [{
            access_token: {
                type: String,
                required: true
            },
            expire_date: {
                type: Date,
                required: true
            }
        }
    ],
    created_at: {
        type: Date,
        default: Date.now
    },
    updated_at: {
        type: Date,
        default: Date.now
    }
}, {
    usePushEach: true
});

var User = mongoose.model('User', userSchema);
module.exports = User;