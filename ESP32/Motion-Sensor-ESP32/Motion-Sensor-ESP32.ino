#include <WiFi.h>
#include <HTTPClient.h>
#include <Firebase_ESP_Client.h>
#include <Wire.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID "arfa33_2.4G"
#define WIFI_PASSWORD "blackjack66"

// Insert Firebase project API Key
#define API_KEY "AIzaSyDlVO_Ne9zTNjZljeu0_cFscLWzzJ1ppJo"

// Insert RTDB URL
#define DATABASE_URL "https://fyp-esp32-19f8b-default-rtdb.asia-southeast1.firebasedatabase.app/"

// Messenger Firebase
const char* serverKey = "AAAAzF5r-7M:APA91bFcGa5IMhtAH2D0nUq2PW-KjDk1zoDJ8S1i563FWqYsLcucx5UzFkS8Mz0VP97j4aCQdegJN0MvaeV8wKonLEWU_3yNTmqgOhJVkWcbxP6EnfLxgEU_AzRgIMxsbQoIOrrYZdxG";


// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
bool signupOK = false;
String token;
int motionActive = 0;

String wifiIP = "";

const int motionSensor = 4;
int CurrentStat = LOW;
int PrevState = LOW;

void setup() {
  Serial.begin(115200);
  delay(1000);
  connectToWiFi();
  configFB();
  getToken();
  pinMode(motionSensor, INPUT_PULLUP);
}

void loop() {
  // Store previous state 
  PrevState = CurrentStat;
  CurrentStat = digitalRead(motionSensor);

  getMotionActive();

  // If detect motion and in mobile phone it is in on mode
  if (PrevState == LOW && CurrentStat == HIGH && motionActive == 1) {
    Serial.println("Motion detected!\nGoing to push notification");
    sendFCMNotification("Hello from ESP32!", "This is a test message from ESP32.");
    motionActive = 0;
  }
  // Detect motion and in mobile phone it is in off mode
  else if (PrevState == LOW && CurrentStat == HIGH){
    Serial.println("Motion detected!\nMotion Active is in disable mode");
  }
  delay(1000);
}

void sendFCMNotification(const char* title, const char* body) {
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

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
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
  }
}
