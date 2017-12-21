var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var testChema = new Schema({
    author: {
        type: String
    }
});

var Test =  mongoose.model('Test', testChema);
module.exports = Test;  