const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const statusSchema = new Schema({
    user_id: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    temperature: {
        type: Number,
        default: 0.0
    },
    humidity: {
        type: Number,
        default: 0.0
    },
    fanStatus: {
        type: Boolean,
        default: false
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

const Status = mongoose.model('Status', statusSchema);
module.exports = Status;