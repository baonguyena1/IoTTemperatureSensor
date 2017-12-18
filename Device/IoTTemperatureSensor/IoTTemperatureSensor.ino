#include <DHT.h>
#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <SocketIoClient.h>

/**
 * Define
 */
#define DHTPIN      D4
#define DHTTYPE     DHT11
#define SSID        "Getz"
#define PASSWORD    "G3tzP@ss"
const char * host = "192.168.1.86";
int port = 9898;

/*
 * Global variable
 */
DHT dht(DHTPIN, DHTTYPE);
WiFiClient wifiClient;
SocketIoClient webSocket;

void event(const char *payload, size_t length) {
  Serial.printf("Got message: %s\n", payload);
}

/**
 * Read temperature, Humidity of DHT11
 */
 void dht11Process() {
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  float f = dht.readTemperature(true);
  
  if (isnan(h) || isnan(t) || isnan(f)) {
    Serial.println("Incorrect data");
    return;
  }

  float hif = dht.computeHeatIndex(f, h);
  float hic = dht.computeHeatIndex(t, h, false);

  Serial.print("Humidity: ");
  Serial.print(h);
  Serial.print(" %\t");
  Serial.print("Temperature: ");
  Serial.print(t);
  Serial.print(" *C ");
  Serial.print(f);
  Serial.print(" *F\t");
  Serial.print("Heat index: ");
  Serial.print(hic);
  Serial.print(" *C ");
  Serial.print(hif);
  Serial.println(" *F");
  String data = "{\"temp\": ";
  data += t;
  data += "}";
  Serial.println(data);
  webSocket.emit("temperature", data.c_str());
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
 
  webSocket.on("response", event);
  webSocket.begin(host, port);
  Serial.println("DHT Text!!!");
  dht.begin();
}

void loop() {
  webSocket.loop();
  dht11Process();

  delay(2000);

 }
