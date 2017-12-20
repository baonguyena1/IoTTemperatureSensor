var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var settingSchema = new Schema({
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
    createdAt: {
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