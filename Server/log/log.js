var fs = require('fs');
var constant = require('../config/constant');
var status = constant.enable_log;
var logger = {
	/**
	 * The function to write log
	 * @param  {string} level  ['infor', 'error', 'debug', 'warning']
	 * @param  {string} logText The content user show log
	 * @param  {object} object  The object can input or output
	 * @return {string}  The content log
	 */
	writeLog: function (level, logText, object) {
		if (status) {
			var date = new Date();
			var point = date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds() + ':' + date.getMilliseconds();
			var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
			var duration = days[date.getDay()] + ':' + (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear();
			var time = duration + '|' + point;
			var content = '';
			if (typeof object === 'undefined' || !object) {
				content = '';
			} else {
				if (typeof object === 'object') {
					content += '{\n';
					for (key in object) {
						content += key + ' :' + object[key] + '\n';
					}
					content += '}\n';
				} else {
					content = object;
				}
			}
			fs.appendFile('log/debug.log', time + ' - ' + level + '   - [IoTSmartHome][message]: ' + logText + '\n' + content, function (err, data) {
				if (err) return console.log(err);
				console.log(time + ' - ' + level + '    - [IoTSmartHome][message:]' + logText);
			});
		}
	},
	/**
	 * The function log option is debug
	 * @param  {string} logText You can defined message to log
	 * @param  {object} object The object can input
	 */
	logDebug: function (logText, object) {
		logger.writeLog('[DEBUG]', logText, object);
		return;
	},
	/**
	 * The function log option is infor
	 * @param  {string} logText You can defined message to log
	 * @param  {object} object The object can input
	 */
	logInfo: function (logText, object) {
		logger.writeLog('[INFO]', logText, object);
		return;
	},
	/**
	 * The function log option is warning
	 * @param  {string} logText You can defined message to log
	 * @param  {object} object The object can input
	 */
	logWarning: function (logText, object) {
		logger.writeLog('[WARNING]', logText, object);
		return;
	},
	/**
	 * The function log option is error
	 * @param  {string} logText You can defined message to log
	 * @param  {object} object The object can input
	 */
	logError: function (logText, object) {
		logger.writeLog('[ERROR]', logText, object);
		return;
	}
}
module.exports = logger;
