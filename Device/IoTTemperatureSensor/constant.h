/**
 * Define
 */
#define SSID        "Getz"
#define PASSWORD    "G3tzP@ss"
#define EEPROM_MANUAL_SETTING_ADD  0

/**
 *  SocketIOEvent 
 **/
const char *SOCKET_DID_UPDATE_MANUAL_SETTING = "didUpdateManualSetting";
const char *SOCKET_DID_UPDATE_TEMPERATURE = "didUpdateTemperature";
const char *SOCKET_UPDATE_MANUAL_SETTING_RESPONSE = "updateManualSettingResponse";

/**
 * Global define
 */
int port = 9898;
const char *host = "192.168.1.41";
