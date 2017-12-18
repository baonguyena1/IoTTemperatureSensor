#include <DHT.h>
#include <Arduino.h>
#include <ESP8266WiFi.h>

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
#define SSID        GetZ
#define PASSWORD    G3tzP@ss

/*
 * Global variable
 */
DHT dht(DHTPIN, DHTTYPE);
WiFiClient wifiClient;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  DEBUG_PRINTLN("DHT Text!!!");
  dht.begin();
}

void loop() {
  // put your main code here, to run repeatedly:
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  float f = dht.readTemperature(true);
  
  if (isnan(h) || isnan(t) || isnan(f)) {
    DEBUG_PRINT("Incorrect data");
    return;
  }

  float hif = dht.computeHeatIndex(f, h);
  float hic = dht.computeHeatIndex(t, h, false);

  DEBUG_PRINT("Humidity: ");
  DEBUG_PRINT(h);
  DEBUG_PRINT(" %\t");
  DEBUG_PRINT("Temperature: ");
  DEBUG_PRINT(t);
  DEBUG_PRINT(" *C ");
  DEBUG_PRINT(f);
  DEBUG_PRINT(" *F\t");
  DEBUG_PRINT("Heat index: ");
  DEBUG_PRINT(hic);
  DEBUG_PRINT(" *C ");
  DEBUG_PRINT(hif);
  DEBUG_PRINTLN(" *F");
  delay(2000);
  
 }
