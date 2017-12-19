var constant = {
    listen_port: 9898,
    status: 'status',
    error: 'error',
    error_code: 'error_code',
    message: 'message',
    results: 'results',
    server_time: 'server_time',
    enable_log: true,
    day_format: 'DD-MM-YYYY HH:mm:ss',
    short_day_format: 'DD-MM-YYYY',
    limit: 100,
    offset: 0,
    SocketIOEvent: {
        CONNECTION: 'connection',
        DISCONNECT: 'disconnect',
        DID_UPDATE_TEMPERATURE: 'didUpdateTemperature',
        DID_UPDATE_MANUALSETTING: 'didUpdateManualSetting',
        UPDATE_MANUAL_SETTING_RESPONSE: 'updateManualSettingResponse'
    }
};

module.exports = constant;