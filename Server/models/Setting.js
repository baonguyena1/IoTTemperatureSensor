var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var settingSchema = new Schema({
    user_id: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    manualSetting: {
        type: Boolean,
        default: false
    },
    highTempEnable: {
        type: Boolean,
        default: false
    },
    highTemp: {
        type: Number,
        default: 27.0
    },
    lowTempEnable: {
        type: Boolean,
        default: false
    },
    lowTemp: {
        type: Number,
        default: 15.0
    },
    created_at: {
        type: Date,
        default: Date.now
    },
    updated_at: {
        type: Date,
        default: Date.now
    }
});

var Setting = mongoose.model('Setting', settingSchema);
module.exports = Setting;