/**
 * Define
 */
#define SSID        "Getz"
#define PASSWORD    "G3tzP@ss"
#define EEPROM_MANUAL_SETTING_ADD   0
#define EEPROM_FAN_STATUS           5
#define EEPROM_HIGH_TEMP_ENABLE     10
#define EEPROM_LOW_TEMP_ENABLE      15
#define EEPROM_HIGH_TEMPERATURE     20
#define EEPROM_LOW_TEMPERATURE      25

#define MAX_LENGTH                  10
#define HIGH_TEMP                   "highTemp"
#define LOW_TEMP                    "lowTemp"
#define HIGH_TEMP_ENABLE            "highTempEnable"
#define LOW_TEMP_ENABLE             "lowTempEnable"
#define MANUAL_SETTING              "manualSetting"

#define FREE(x)       { free(x); x = NULL; }

/**
 *  SocketIOEvent 
 **/
const char *SOCKET_DID_UPDATE_MANUAL_SETTING = "didUpdateManualSetting";
const char *SOCKET_DID_UPDATE_TEMPERATURE = "didUpdateTemperature";
const char *SOCKET_DID_UPDATE_MANUAL_SETTING_RESPONSE = "didUpdateManualSettingResponse";
const char *SOCKET_DID_UPDATE_FAN_STATUS = "didUpdateFanStatus";
const char *SOCKET_DID_UPDATE_FAN_STATUS_RESPONSE = "didUpdateFanStatusResponse";
const char *SOCKET_DID_UPDATE_SETTING = "didUpdateSetting";
const char *SOCKET_BROADCAST_DEVICE = "broadcastDevice";
const char *SOCKET_CURRENT_SETTING = "currentSetting";

/**
 * Global define
 */
int port = 26459;
const char *host = "https://smarthome-iot.herokuapp.com";
const char *esp8266_nsp = "/esp8266";
int temperatureSequence = 0;


