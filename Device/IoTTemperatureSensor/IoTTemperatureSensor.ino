#include <DHT.h>
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <SocketIoClient.h>
#include <EEPROM.h>

/**
 * Define
 */
#define DHTPIN      D4
#define DHTTYPE     DHT11
#define SSID        "Getz"
#define PASSWORD    "G3tzP@ss"
#define EEPROM_ADD  0

/**
 * Socket IO Event name
 */
 #define RESPONSE                       "response"
 #define UPDATE_MANUAL_SETTING          "didUpdateManualSetting"
 #define TEMPERATURE                    "didUpdateTemperature"

const char * host = "localhost";
int port = 9898;

/*
 * Global variable
 */
DHT dht(DHTPIN, DHTTYPE);
WiFiClient wifiClient;
SocketIoClient webSocket;
int manualSetting;

/**
 * Description: Test response
 * Socket IO Event Call back
 */
void response(const char *payload, size_t length) {
  Serial.printf("%s:%d:Got message: %s\n", __FUNCTION__, __LINE__, payload);
}

/**
 * Description: Get new manual setting and save it to EEPROM
 * payload: Int
 */
void updateManualSetting(const char *payload, size_t length) {
  int newSetting = atoi(payload);
  Serial.printf("updateManualSetting: payload = %d", newSetting);
  EEPROM.write(EEPROM_ADD, newSetting);
  manualSetting = newSetting;
}

/**
 * Description: Read temperature, Humidity of DHT11
 * And send data to server
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
  Serial.print(" *C ");
  String data = "{\"temp\": ";
  data += t;
  data += ", \"humi:\" ";
  data += h;
  data += "}";
  Serial.println(data);
  webSocket.emit(TEMPERATURE, data.c_str());
 }

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  delay(10);
  Serial.print("Connecting to wifi ");
  WiFi.begin(SSID, PASSWORD);
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("Conntected wifi");
  Serial.print("Wifi address:");
  Serial.println(WiFi.localIP());

 /**
  * Register socket io event
  */
  webSocket.on(RESPONSE, response);
  webSocket.on(UPDATE_MANUAL_SETTING, updateManualSetting);
  
  webSocket.begin(host, port);
  manualSetting = EEPROM.read(EEPROM_ADD);
  Serial.printf("Manual setting = %d\n", manualSetting);
  Serial.println("DHT Text!!!");
  dht.begin();
}

void loop() {
  webSocket.loop();
  dht11Process();

  delay(2000);

 }
