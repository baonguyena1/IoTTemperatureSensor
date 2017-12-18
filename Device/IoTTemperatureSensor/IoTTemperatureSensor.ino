#include <DHT.h>
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <SocketIoClient.h>

//#define           DEBUG
#ifdef DEBUG
  #define DEBUG_PRINT(...)      { Serial.print(__VA_ARGS__); }
  #define DEBUG_PRINTLN(...)    { Serial.println(__VA_ARGS__); }
#else
  #define DEBUG_PRINT(...)      {}
  #define DEBUG_PRINTLN(...)    {}
#endif

/**
 * Define
 */
#define DHTPIN      5
#define DHTTYPE     DHT11
#define SSID        "GetZ"
#define PASSWORD    "G3tzP@ss"
const char * host = "192.168.1.41";
int port = 9898;

/*
 * Global variable
 */
DHT dht(DHTPIN, DHTTYPE);
WiFiClient wifiClient;
SocketIoClient webSocket;

void event(const char *payload, size_t length) {
  DEBUG_PRINTLN("Got message: %s", payload);
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  delay(10);
  DEBUG_PRINT("Connecting to wifi ");
  WiFi.begin(SSID, PASSWORD);
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    DEBUG_PRINT(".")
  }
  DEBUG_PRINTLN(F("Conntected wifi"));
  DEBUG_PRINTLN(F("Wifi address: %s", Wifi.localIP()));
 
  webSocket.on("connection", event);
   webSocket.begin(host, port);
//  DEBUG_PRINTLN("DHT Text!!!");
//  dht.begin();
}

void loop() {
  webSocket.loop();
  // put your main code here, to run repeatedly:
//  float h = dht.readHumidity();
//  float t = dht.readTemperature();
//  float f = dht.readTemperature(true);
//  
//  if (isnan(h) || isnan(t) || isnan(f)) {
//    DEBUG_PRINT("Incorrect data");
//    return;
//  }
//
//  float hif = dht.computeHeatIndex(f, h);
//  float hic = dht.computeHeatIndex(t, h, false);
//
//  DEBUG_PRINT("Humidity: ");
//  DEBUG_PRINT(h);
//  DEBUG_PRINT(" %\t");
//  DEBUG_PRINT("Temperature: ");
//  DEBUG_PRINT(t);
//  DEBUG_PRINT(" *C ");
//  DEBUG_PRINT(f);
//  DEBUG_PRINT(" *F\t");
//  DEBUG_PRINT("Heat index: ");
//  DEBUG_PRINT(hic);
//  DEBUG_PRINT(" *C ");
//  DEBUG_PRINT(hif);
//  DEBUG_PRINTLN(" *F");
  delay(2000);
  
 }
