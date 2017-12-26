var constant = {
    listen_port: 9898,
    server_time: 'server_time',
    enable_log: true,
    day_format: 'DD-MM-YYYY HH:mm:ss',
    short_day_format: 'DD-MM-YYYY',
    limit: 100,
    offset: 0,
    token_length: 20,
    token_expire: 7,
    access_tokenizer: '___',
    SocketIOEvent: {
        CONNECTION: 'connection',
        DISCONNECT: 'disconnect',
        DID_UPDATE_TEMPERATURE: 'didUpdateTemperature',
        DID_UPDATE_MANUALSETTING: 'didUpdateManualSetting',
        DID_UPDATE_MANUAL_SETTING_RESPONSE: 'didUpdateManualSettingResponse',
        DID_UPDATE_FAN_STATUS: 'didUpdateFanStatus',
        DID_UPDATE_FAN_STATUS_RESPONSE: 'didUpdateFanStatusResponse',
        CONNECT_USER: 'connectUser'
    },
    success: 'success',
    status: 'status',
    error: 'error',
    error_code: 'error_code',
    message: 'message',
    results: 'results',
    url_without_tokens_with_parameter: [
    ],
    url_without_tokens: [
        '/auth/login',
        '/auth/register',
        '/setting/test'
    ]
};

module.exports = constant;