#include <WiFi.h>
#include <HTTPClient.h>
#include <Firebase_ESP_Client.h>
#include <Wire.h>
#include "time.h"

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
//#define WIFI_SSID "arfa33_2.4G"
//#define WIFI_PASSWORD "blackjack66"

//#define WIFI_SSID "XZ1"
//#define WIFI_PASSWORD "test1234"

#define WIFI_SSID "Hotspot@PUTRA-2.4G"
#define WIFI_PASSWORD ""

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

// Variable to save current epoch time
unsigned long epochTime;

// NTP server to request epoch time
const char* ntpServer = "pool.ntp.org";
const long  gmtOffset_sec = 0;
const int   daylightOffset_sec = 8 * 3600;
String Time;
String Date;

const int motionSensor = 4;
int currentStat = LOW;
int prevStat = LOW;

void setup() {
  Serial.begin(115200);
  delay(1000);
  connectToWiFi();
  configFB();
  getToken();
  pinMode(motionSensor, INPUT);
  Serial.println("Exit setup()");
}

void loop() {
  // Store previous state
  prevStat = currentStat;
  currentStat = digitalRead(motionSensor);

  getMotionActive();

  // If detect motion and in mobile phone it is in on mode
  //  if (PrevState == LOW && CurrentStat == HIGH && motionActive == 1) {
  //    Serial.println("Motion detected!\nGoing to push notification");
  //    sendFCMNotification("Hello from ESP32!", "This is a test message from ESP32.");
  //    motionActive = 0;
  //  }
  //  // Detect motion and in mobile phone it is in off mode
  //  else if (PrevState == LOW && CurrentStat == HIGH){
  //    Serial.println("Motion detected!\nMotion Active is in disable mode");
  //  }
  if (prevStat == LOW && currentStat == HIGH) {
    if (motionActive == 1) {
      sendFCMNotification("Alert!", "There is unusual movemoment on Kitchen window!");
      Serial.println("Message alert send!");
      delay(3000);
    }
    else {
      Serial.println("Message alert not send due to motion active is disable");
    }

  }

  delay(1000);
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
  //  if (Firebase.signUp(&config, &auth, "", "")) {
  //    Serial.println("FB Connection okay");
  //    signupOK = true;
  //  } else {
  //    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  //  }

  /* Assign the callback function for the long-running token generation task */
  config.token_status_callback = tokenStatusCallback;  // see addons/TokenHelper.h

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

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

void getLocationMotion() {
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

void printLocalTime() {
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    Serial.println("Failed to obtain time");
    return;
  }

  Time = String(timeinfo.tm_hour) + "-" + String(timeinfo.tm_min) + "-" + String(timeinfo.tm_sec);
  Serial.print("Time: ");
  Serial.println(Time);

  Date = String(timeinfo.tm_year + 1900) + "-" + String(timeinfo.tm_mon + 1) + "-" + String(timeinfo.tm_mday);
  Serial.print("Date: ");
  Serial.println(Date);
}
