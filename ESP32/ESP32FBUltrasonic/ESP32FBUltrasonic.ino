#include <WiFi.h>
#include <HTTPClient.h>
#include <Firebase_ESP_Client.h>
#include <Wire.h>
#include "time.h"
#include "sntp.h"

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
//#define WIFI_SSID "arfa33_2.4G"
//#define WIFI_PASSWORD "blackjack66"

//#define WIFI_SSID "XZ1"
//#define WIFI_PASSWORD "test1234"

#define WIFI_SSID "Eyeman420"
#define WIFI_PASSWORD "test1234"

//#define WIFI_SSID "Hotspot@PUTRA-2.4G"
//#define WIFI_PASSWORD ""

//#define WIFI_SSID "LAPTOP-PNIEDQNG 2826"
//#define WIFI_PASSWORD "8J4^24m3"

// Insert Firebase project API Key
#define API_KEY "AIzaSyDlVO_Ne9zTNjZljeu0_cFscLWzzJ1ppJo"
//#define API_KEY "AIzaSyBvcyHfUINuFXYdeXl8WHz4499yqZZPRPo"

// Insert RTDB URL
#define DATABASE_URL "https://fyp-esp32-19f8b-default-rtdb.asia-southeast1.firebasedatabase.app/"
//#define DATABASE_URL "https://putra-scada-default-rtdb.asia-southeast1.firebasedatabase.app/"

// Messenger Firebase
const char* serverKey = "AAAAzF5r-7M:APA91bFcGa5IMhtAH2D0nUq2PW-KjDk1zoDJ8S1i563FWqYsLcucx5UzFkS8Mz0VP97j4aCQdegJN0MvaeV8wKonLEWU_3yNTmqgOhJVkWcbxP6EnfLxgEU_AzRgIMxsbQoIOrrYZdxG";
//const char* serverKey = "AAAA1MTGS4M:APA91bELhwLBWmOeE4Td484ZVV7WjT4SVzEYLbh_UteI3ecuw02Oe5yx-CpRy-8kAfxZFme7s2lcEgYwpoJY-KMuDgMyOsB77814ZyXtrnxbusBnuMyndN9fksvp3FGgokHsci1H0uf4";

#define USER_EMAIL "motionsensor@gmail.com"
#define USER_PASSWORD "motionsensor1234"

// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
bool signupOK = false;
String token = "";
int motionActive = 0;
String uid;
String wifiIP;
String location = "Kitchen Window";

// Variable to save current epoch time
unsigned long epochTime;

// NTP server to request epoch time
const char* ntpServer1 = "pool.ntp.org";
const char* ntpServer2 = "time.nist.gov";
const long  gmtOffset_sec = 8 * 3600;
const int   daylightOffset_sec = 0 * 3600;

//const char* time_zone = "CET-1CEST,M3.5.0,M10.5.0/3";  // TimeZone rule for Europe/Rome including daylight adjustment rules (optional)
const char* time_zone = "Asia/Kuala_Lumpur";  // Time zone for Malaysia

String Time;
String Date;

#define TRIG_PIN 12 // ESP32 pin GPIO23 connected to Ultrasonic Sensor's TRIG pin
#define ECHO_PIN 13 // ESP32 pin GPIO22 connected to Ultrasonic Sensor's ECHO pin
const int ledpin = 2;

float duration_us, distance_cm;
float sumMaxDistance = 0;
float avgMaxDistance = 0;
bool detectChanges = false;

unsigned long sendDataPrevMillis = 0;
unsigned long lastTimeSensorDelay = millis();
unsigned long sensorDelay = 500;

unsigned long previousMicros = 0;
const int trigDelay = 10; // Set your desired delay in microseconds

int count = 0;


void setup() {
  // begin serial port
  Serial.begin (115200);
  Serial.println("Reading max distance...");
  // Initial Read
  // configure the trigger pin to output mode
  pinMode(TRIG_PIN, OUTPUT);
  // configure the echo pin to input mode
  pinMode(ECHO_PIN, INPUT);

  //Measuring the sumMaxDistance
  for (int i = 0; i < 20; i++) {
    // generate 10-microsecond pulse to TRIG pin
    digitalWrite(TRIG_PIN, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIG_PIN, LOW);

    // measure duration of pulse from ECHO pin
    duration_us = pulseIn(ECHO_PIN, HIGH);

    // calculate the distance
    distance_cm = 0.017 * duration_us;

    sumMaxDistance += distance_cm;

    delay(500);
  }

  //Measuring the avgMaxDistance
  avgMaxDistance = sumMaxDistance / 20;
  Serial.print("AvgMaxDistance: ");
  Serial.println(avgMaxDistance);

  connectToWiFi();
  configFB();
  getToken();
  //setLocationMotion();
  pinMode(ledpin, OUTPUT);

  // set notification call-back function
  sntp_set_time_sync_notification_cb( timeavailable );
  sntp_servermode_dhcp(1);    // (optional)
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer1, ntpServer2);

  //Get count
  if (Firebase.RTDB.getString(&fbdo, "/MotionSensor/Count")) {
    if (fbdo.dataType() == "int") {
      count = fbdo.intData();
      Serial.print("Success\nCount: ");
      Serial.println(count);
    }
  }

}

void loop() {
  unsigned long timeNow = millis();

  // Repeat read sensor
  if (timeNow - lastTimeSensorDelay > sensorDelay) {
    lastTimeSensorDelay = timeNow;

    //READ Sensor
    // generate 10-microsecond pulse to TRIG pin
    digitalWrite(TRIG_PIN, HIGH);
    //delayMicroseconds(10);
    //Delay it for 10 microseconds
    unsigned long currentMicros = micros();
    if (currentMicros - previousMicros >= trigDelay) {
      previousMicros = currentMicros;

      digitalWrite(TRIG_PIN, LOW);

      // measure duration of pulse from ECHO pin
      duration_us = pulseIn(ECHO_PIN, HIGH);

      // calculate the distance
      distance_cm = 0.017 * duration_us;

      // print the value to Serial Monitor
      Serial.print("distance: ");
      Serial.print(distance_cm);
      Serial.println(" cm");

      // Change flag for detectChanges when somebody trip the sensor
      if (distance_cm < (avgMaxDistance - 3.00)) {
        detectChanges = true;
        Serial.println("Detect changes in length!");
      }
    }

  }

  // Alert firebase
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 3000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();

    String message;

    getMotionActive();
    if (detectChanges == true) {
      if (motionActive == 1) {
        //getTime
        getLocalTime();
        digitalWrite(ledpin, HIGH);
        //message = "Unusual movement detected at " + location + " on " + Time + ", " + Date + ".";
        message = "Unusual movement detected at Kitchen windows on " + Time + ", " + Date + ".";
        sendFCMNotification("Alert!", message);
        Serial.println("Message alert send!");
      }
      else {

        Serial.println("Message alert not send due to motion active is disable");
      }

      //reset flag
      detectChanges = false;
    }
    else {
      // Turn off led
      digitalWrite(ledpin, LOW);
    }
  }
  //Refesh token if expired
  if (Firebase.isTokenExpired()) {
    Firebase.refreshToken(&config);
    Serial.println("Refresh token");
  }
}

void sendFCMNotification(String title, String body) {


  HTTPClient http;
  http.begin("https://fcm.googleapis.com/fcm/send");
  http.addHeader("Content-Type", "application/json");
  http.addHeader("Authorization", "key=" + String(serverKey));

  // Construct the FCM notification payload
  String jsonData = "{\"to\":\"" + String(token) + "\",\"notification\":{\"title\":\"" + String(title) + "\",\"body\":\"" + String(body) + "\"}}";

  int httpResponseCode = http.POST(jsonData);

  if (httpResponseCode > 0) {
    String response = http.getString();
    Serial.println("FCM Notification Sent Successfully!");
    Serial.println(response);
  } else {
    Serial.print("Error sending FCM Notification. HTTP Error code: ");
    Serial.println(httpResponseCode);
  }

  http.end();

  // Push count and logs to firebase
  String path = "/Logs/" + String(count);
  String logsMessage = Time + " - " + Date + ": Kitchen window";
  if (Firebase.RTDB.setString(&fbdo, path, logsMessage)) {
    count++;
    //Upload counter
    if (Firebase.RTDB.setInt(&fbdo, "/MotionSensor/Count", count)) {
    } else {
      Serial.println("FAILED Count");
      Serial.println("REASON: " + fbdo.errorReason());
    }

  } else {
    Serial.println("FAILED Message FB");
    Serial.println("REASON: " + fbdo.errorReason());
  }

  if (Firebase.isTokenExpired()) {
    Firebase.refreshToken(&config);
    Serial.println("Refresh token");
  }
}

// Connect to WiFi
void connectToWiFi() {

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.println("Wifi connecting: ");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi connected!");
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  // Connected with IP
  IPAddress localIP = WiFi.localIP();
  wifiIP = localIP.toString();
}

// Setup for Firebase
void configFB() {

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  // Assign the user sign in credentials
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("FB Connection okay");
    signupOK = true;
  } else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long-running token generation task */
  config.token_status_callback = tokenStatusCallback;  // see addons/TokenHelper.h

  //Firebase.begin(&config, &auth);
  Firebase.reconnectNetwork(true);
  // Since v4.4.x, BearSSL engine was used, the SSL buffer need to be set.
  // Large data transmission may require larger RX buffer, otherwise connection issue or data read time out can be occurred.
  fbdo.setBSSLBufferSize(4096 /* Rx buffer size in bytes from 512 - 16384 */, 1024 /* Tx buffer size in bytes from 512 - 16384 */);

  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  config.timeout.serverResponse = 10 * 1000;

  // Getting the user UID might take a few seconds
  Serial.println("Getting User UID");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }
  // Print user UID
  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.println(uid);

  // Push IP Address
  if (Firebase.RTDB.setString(&fbdo, "/MotionSensor/IPAddressMotion", wifiIP)) {
    Serial.println("IP Address send to FB!");
  }
  else {
    Serial.print("Error IPAddressMotion: ");
    Serial.println(fbdo.errorReason());
  }

}

// get token value for smartphone
void getToken() {

  Serial.println("Requesting Token...");
  if (Firebase.RTDB.getString(&fbdo, "/SmartPhone/Token")) {
    if (fbdo.dataType() == "string") {
      token = fbdo.stringData();
      Serial.print("Success\ntoken: ");
      Serial.println(token);
    }
  } else {
    Serial.println(fbdo.errorReason());
  }

}

// get status of motion either need to be on or off
void getMotionActive() {
  //Serial.println("Requesting Token...");
  if (Firebase.RTDB.getInt(&fbdo, "MotionSensor/MotionActive")) {
    if (fbdo.dataType() == "int") {
      motionActive = fbdo.intData();
    }
  } else {
    Serial.println(fbdo.errorReason());
    Serial.print("Motion Active:");
    Serial.println(motionActive);
  }
}

// Bala punca x leh compiled
//void setLocationMotion() {
//  if (Firebase.RTDB.setInt(&fbdo, "/MotionSensor/LocationMotion", location)) {
//    Serial.println("Push location to FB");
//  } else {
//    Serial.print("Error set location!");
//    Serial.println(fbdo.errorReason());
//  }
//
//}

void getLocalTime() {
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    Serial.println("No time available (yet)");
    return;
  }

  Time = String(timeinfo.tm_hour) + ":" + String(timeinfo.tm_min);
  //  Time = String(timeinfo.tm_hour) + ":" + String(timeinfo.tm_min) + ":" + String(timeinfo.tm_sec);
  //Serial.print("Time: ");
  //Serial.println(Time);

  Date = String(timeinfo.tm_mday) + "." + String(timeinfo.tm_mon + 1) + "." + String(timeinfo.tm_year + 1900);
  //Serial.print("Date: ");
  //Serial.println(Date);

  Serial.print("Time: ");
  Serial.print(Time);
  Serial.print("  Date: ");
  Serial.println(Date);
}
//
//String getTimeStamp() {
//  char timestamp[20];
//  sprintf(timestamp, "%lu", millis());
//  return String(timestamp);
//}
// Callback function (get's called when time adjusts via NTP)
void timeavailable(struct timeval *t)
{
  Serial.println("Got time adjustment from NTP!");
  getLocalTime();
}
