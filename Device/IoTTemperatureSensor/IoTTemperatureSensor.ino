#include <DHT.h>
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <SocketIoClient.h>
#include <EEPROM.h>
#include "constant.h"

/**
   Define
*/
#define DHTPIN      D4
#define DHTTYPE     DHT11

/*
   Global variable
*/
DHT dht(DHTPIN, DHTTYPE);
WiFiClient wifiClient;
SocketIoClient webSocket;
int manualSetting;

void writeEEPROM(int address, const char *data, size_t length) {
  Serial.printf("writeEEPROM, data = %s, length = %d\n", data, length);
  EEPROM.begin(512);
  for (int i = 0; i < length; i++) {
    EEPROM.write(address + i, data[i]);
  }
  EEPROM.commit();
  EEPROM.end();
}

char* readEEPROM(int address) {
  char *result = (char *)malloc(MAX_LENGTH);
  EEPROM.begin(512);
  for (int i = 0; i < MAX_LENGTH; i++) {
    result[i] = char(EEPROM.read(address + i));
    if (result[i] == '\0') {
      break;
    }
  }
  EEPROM.end();
  Serial.printf("readEEPROM: %s\n", result);
  return strdup(result);
}

/**
   Description: Get new manual setting and save it to EEPROM
   payload: Int
*/
void updateManualSetting(const char *payload, size_t length) {
  writeEEPROM(EEPROM_MANUAL_SETTING_ADD, payload, sizeof(payload)/sizeof(const char *));
  char *setting = readEEPROM(EEPROM_MANUAL_SETTING_ADD);
  Serial.printf("updateManualSetting: setting = %s\n", setting);
  webSocket.emit(SOCKET_UPDATE_MANUAL_SETTING_RESPONSE, setting);
}

void setFanStatus(const char *payload, size_t length) {
  int fanStatus = atoi(payload);
  Serial.printf("setFanStatus: payload = %d", payload);
  EEPROM.write(EEPROM_FAN_STATUS, fanStatus);
  // TODO: on/off relay, emit success status
}

void setupSocket() {
  webSocket.on(SOCKET_DID_UPDATE_MANUAL_SETTING, updateManualSetting);
  webSocket.on(SOCKET_DID_UPDATE_FAN_STATUS, setFanStatus);
}

/**
   Description: Read temperature, Humidity of DHT11
   And send data to server
*/
void dht11Process() {
  float h = dht.readHumidity();
  float t = dht.readTemperature();

  if (isnan(h) || isnan(t)) {
    Serial.println("Incorrect data");
    return;
  }

  Serial.print("Humidity: ");
  Serial.print(h);
  Serial.print(" %\t");
  Serial.print("Temperature: ");
  Serial.print(t);
  Serial.println(" *C ");
  String data = "{\"temp\": ";
  data += t;
  data += ", \"humi\": ";
  data += h;
  data += "}";
//  Serial.println(data);
  webSocket.emit(SOCKET_DID_UPDATE_TEMPERATURE, data.c_str());
  delay(2000);
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  delay(10);
  Serial.print("Connecting to wifi ");
  WiFi.begin(SSID, PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("Conntected wifi");
  Serial.print("Wifi address:");
  Serial.println(WiFi.localIP());

  webSocket.on(SOCKET_DID_UPDATE_MANUAL_SETTING, updateManualSetting);

  webSocket.begin(host, port);
  manualSetting = atoi(readEEPROM(EEPROM_MANUAL_SETTING_ADD));
  Serial.printf("Manual setting = %d\n", manualSetting);
  dht.begin();
}

void loop() {
  webSocket.loop();
  dht11Process();

  delay(2000);
}
