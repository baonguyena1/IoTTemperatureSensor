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

/**
   Description: Get new manual setting and save it to EEPROM
   payload: Int
*/
void updateManualSetting(const char *payload, size_t length) {
  int newSetting = atoi(payload);
  Serial.printf("updateManualSetting: payload = %d", newSetting);
  EEPROM.write(EEPROM_MANUAL_SETTING_ADD, newSetting);
  manualSetting = getManualSetting();
  char *setting;
  sprintf(setting, "%d", manualSetting);
  delay(50);
  webSocket.emit(SOCKET_UPDATE_MANUAL_SETTING_RESPONSE, setting);
}

int getManualSetting() {
  int manualSetting = EEPROM.read(EEPROM_MANUAL_SETTING_ADD);
  return manualSetting;
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
  Serial.println(data);
  webSocket.emit(SOCKET_DID_UPDATE_TEMPERATURE, data.c_str());
  delay(1000);
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

  /**
     Register socket io event
  */
  webSocket.on(SOCKET_DID_UPDATE_TEMPERATURE, updateManualSetting);

  webSocket.begin(host, port);
  manualSetting = getManualSetting();
  Serial.printf("Manual setting = %d\n", manualSetting);
  dht.begin();
}

void loop() {
  webSocket.loop();
  dht11Process();

  delay(500);
}
