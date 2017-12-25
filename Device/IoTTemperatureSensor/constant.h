/**
 * Define
 */
#define SSID        "phuong cuc 1"
#define PASSWORD    "04030201"
#define EEPROM_MANUAL_SETTING_ADD   0
#define EEPROM_HIGH_TEMPERATURE     10
#define EEPROM_LOW_TEMPERATURE      20
#define EEPROM_FAN_STATUS           30

#define MAX_LENGTH                  10

/**
 *  SocketIOEvent 
 **/
const char *SOCKET_DID_UPDATE_MANUAL_SETTING = "didUpdateManualSetting";
const char *SOCKET_DID_UPDATE_TEMPERATURE = "didUpdateTemperature";
const char *SOCKET_UPDATE_MANUAL_SETTING_RESPONSE = "updateManualSettingResponse";
const char *SOCKET_DID_UPDATE_FAN_STATUS = "didUpdateFanStatus";

/**
 * Global define
 */
int port = 9898;
const char *host = "192.168.1.117";
