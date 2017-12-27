#include <DHT.h>
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <SocketIoClient.h>
#include <EEPROM.h>
#include <ArduinoJson.h>
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
int fanStatus;

void writeEEPROM(int address, const char *data) {
  Serial.printf("writeEEPROM, data = %s, length = %d\n", data, strlen(data));
  EEPROM.begin(512);
  for (int i = 0; i < strlen(data); i++) {
    EEPROM.write(address + i, *(data + i));
  }
  EEPROM.commit();
  EEPROM.end();
}

char* readEEPROM(int address) {
  char *result = (char *)malloc(MAX_LENGTH);
  memset(result, '\0', MAX_LENGTH);
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
  Serial.printf("payload = %s, size = %d\n", payload, length);
  writeEEPROM(EEPROM_MANUAL_SETTING_ADD, payload);
  char *setting = readEEPROM(EEPROM_MANUAL_SETTING_ADD);
  manualSetting = atoi(setting);
}

void updateFanStatus(const char *payload, size_t length) {
  Serial.printf("payload = %s, size = %d\n", payload, length);
  writeEEPROM(EEPROM_FAN_STATUS, payload);
  // on/off replay
}

void updateSetting(const char *payload, size_t length) {
  Serial.printf("payload = %s, size = %d\n", payload, length);
  StaticJsonBuffer<200> jsonBuffer;
  JsonObject &json = jsonBuffer.parseObject(payload);
  const char *highTemp = json[HIGH_TEMP];
  const char *lowTemp = json[LOW_TEMP];
  int highTempEnable = json[HIGH_TEMP_ENABLE];
  int lowTempEnable = json[LOW_TEMP_ENABLE];
  
  if (highTemp != NULL) {
     writeEEPROM(EEPROM_HIGH_TEMPERATURE, highTemp);
     char *enable = (char *)malloc(2);
     sprintf(enable, "%d", highTempEnable);
     writeEEPROM(EEPROM_HIGH_TEMP_ENABLE, enable);
     FREE(enable);
  }
  if (lowTemp != NULL) {
    writeEEPROM(EEPROM_LOW_TEMPERATURE, lowTemp);
    char *enable = (char *)malloc(2);
    sprintf(enable, "%d", lowTempEnable);
    writeEEPROM(EEPROM_LOW_TEMP_ENABLE, enable);
    FREE(enable);
  }
}

/**
   Description: Read temperature, Humidity of DHT11
   And send data to server
*/
void dht11Process() {
  // Read temperature after 1 minute.
  if (temperatureSequence++ % 120 != 0) {
    if (temperatureSequence > 120) {
      temperatureSequence = 1;
    }
    return;
  }
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
  String data = "{\"temperature\": ";
  data += t;
  data += ", \"humidity\": ";
  data += h;
  data += "}";

  webSocket.emit(SOCKET_DID_UPDATE_TEMPERATURE, data.c_str());
}

void readInitialData() {
  manualSetting = atoi(readEEPROM(EEPROM_MANUAL_SETTING_ADD));
  fanStatus = atoi(readEEPROM(EEPROM_FAN_STATUS));
  Serial.printf("Manual setting = %d, fan status = %d\n", manualSetting, fanStatus);
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
  webSocket.on(SOCKET_DID_UPDATE_FAN_STATUS, updateFanStatus);
  webSocket.on(SOCKET_DID_UPDATE_SETTING, updateSetting);

  webSocket.begin(host, port);
  readInitialData();
  dht.begin();
}

void loop() {
  webSocket.loop();
  dht11Process();

  delay(500);
}
