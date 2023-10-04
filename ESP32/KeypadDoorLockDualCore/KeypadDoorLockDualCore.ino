#include <Arduino.h>
#include <Keypad.h>
#include <WiFi.h>
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

// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
bool signupOK = false;

const byte ROWS = 4;  // four rows
const byte COLS = 4;  // four columns
char keys[ROWS][COLS] = {
  { '1', '2', '3', 'A' },
  { '4', '5', '6', 'B' },
  { '7', '8', '9', 'C' },
  { '*', '0', '#', 'D' }
};
byte rowPins[ROWS] = { 23, 22, 3, 21 };  // connect to the row pinouts of the keypad
byte colPins[COLS] = { 19, 18, 5, 17 };  // connect to the column pinouts of the keypad

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

const int solenoidPin = 2;  // Pin for controlling the solenoid lock
const int buttonPin = 27;

String passcode = "";  // Set your desired passcode

String inputCode = "";
bool doorLocked = true;
String wifiIP = "";

// Variables will change:
int lastState = HIGH;  // the previous state from the input pin
int currentState;      // the current reading from the input pin

// Forward declarations
void unlockDoor();
void lockDoor();
void connectToWiFi();
void configFB();
void sensorInitialization();
void getPasscode();

void setup() {
  // Initialize digital pin LED_BUILTIN as an output.
  // pinMode (LED_BUILTIN, OUTPUT);
  Serial.begin(115200);
  connectToWiFi();
  configFB();
  getPasscode();
  sensorInitialization();
  xTaskCreatePinnedToCore(
    [](void* pvParameters) {
      while (1) {
        char key = keypad.getKey();
        // Serial.print("Key: ");
        // Serial.println(key);

        if (key) {
          // Append keys
          if (key == '*') {
            inputCode = "";
            Serial.println("Passcode successfully reseted");
          } else if (key != '#' && inputCode.length() <= 4) {
            inputCode += key;
            Serial.println(inputCode);
          } else {
            Serial.println();
            // Check passcode
            if (inputCode == passcode) {
              if (doorLocked) {
                unlockDoor();
              } 
              //else {
//                lockDoor();
//              }
            }
            // Wrong passcode
            else {
              Serial.println("Incorrect passcode!");
            }
            inputCode = "";
            Serial.println("Passcode reseted");
          }
        }

        // read the state of the switch/button:
        currentState = digitalRead(buttonPin);

        if (lastState == LOW && currentState == HIGH) {
          Serial.println("The button is released");
          Serial.println("Requesting update passcode");
          getPasscode();
        }

        // save the last state
        lastState = currentState;

        // if (digitalRead(buttonPin) == HIGH) {
        //   Serial.println("Requesting update passcode");
        //   getPasscode();
        // }
        // Serial.println();
        delay(50);  // Fix random error keypad 4 into 1
      }
    },
    "keypadTask",  // Name of the task
    5500,          // Stack size in bytes
    NULL,          // Task input parameter
    1,             // Priority of the task
    NULL,          // Task handle.
    0              // Core where the task should run (core 0)
  );

  xTaskCreatePinnedToCore(
    [](void* pvParameters) {
      while (1) {
        if (Firebase.RTDB.getInt(&fbdo, "Door/DoorState")) {
          if (fbdo.dataType() == "int") {
            int door = fbdo.intData();
            // Serial.print("Success\nPasscode: ");
            // Serial.println(door);
            if (door == 1) {
              unlockDoor();
              delay(2000);
              if (Firebase.RTDB.setInt(&fbdo, "Door/DoorState", 0)) {
              } else {
                Serial.println("FAILED");
                Serial.println("REASON: " + fbdo.errorReason());
              }
            }
          }
        } else {
          Serial.println(fbdo.errorReason());
        }
        delay(2000);
      }
    },
    "firebaseTask",  // Name of the task
    8192,            // Stack size in bytes
    NULL,            // Task input parameter
    1,               // Priority of the task
    NULL,            // Task handle.
    1                // Core where the task should run (core 1)
  );
}

void loop() {
  // Your main loop code here
}

void unlockDoor() {
  //digitalWrite(solenoidPin, LOW);
  if (Firebase.RTDB.setInt(&fbdo, "Door/DoorState", 1)) {
  } else {
    Serial.println("FAILED");
    Serial.println("REASON: " + fbdo.errorReason());
  }

  digitalWrite(solenoidPin, HIGH);  // Activate the solenoid to unlock the door
  Serial.println("Door unlocked");
  doorLocked = false;
  delay(5000);
  lockDoor();
}

void lockDoor() {
  
  if (Firebase.RTDB.setInt(&fbdo, "Door/DoorState", 0)) {
  } else {
    Serial.println("FAILED");
    Serial.println("REASON: " + fbdo.errorReason());
  }
  //digitalWrite(solenoidPin, HIGH);
  digitalWrite(solenoidPin, LOW);  // Deactivate the solenoid to lock the door
  Serial.println("Door locked");
  doorLocked = true;
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

  if (Firebase.RTDB.setString(&fbdo, "Door/IPAddressDoor", wifiIP)) {
  } else {
    Serial.println("FAILED IP Address");
    Serial.println("REASON: " + fbdo.errorReason());
  }
}

void sensorInitialization() {
  pinMode(solenoidPin, OUTPUT);
  digitalWrite(solenoidPin, LOW);  // Ensure the solenoid is initially not activated
  pinMode(buttonPin, INPUT_PULLUP);
}

void getPasscode() {
  delay(1000);  // avoid looping when pressed
  Serial.println("Requesting Passcode...");
  if (Firebase.RTDB.getInt(&fbdo, "Door/Passcode")) {
    if (fbdo.dataType() == "int") {
      passcode = fbdo.intData();
      Serial.print("Success\nPasscode: ");
      Serial.println(passcode);
    }
  } else {
    Serial.println(fbdo.errorReason());
  }
}
