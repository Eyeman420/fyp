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

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "https://fyp-esp32-19f8b-default-rtdb.asia-southeast1.firebasedatabase.app/"

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
int count = 0;
bool signupOK = false;


const byte ROWS = 4;  //four rows
const byte COLS = 4;  //four columns
char keys[ROWS][COLS] = {
  { '1', '2', '3', 'A' },
  { '4', '5', '6', 'B' },
  { '7', '8', '9', 'C' },
  { '*', '0', '#', 'D' }
};
byte rowPins[ROWS] = { 23, 22, 3, 21 };  //connect to the row pinouts of the keypad
byte colPins[COLS] = { 19, 18, 5, 17 };  //connect to the column pinouts of the keypad

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

const int solenoidPin = 13;  // Pin for controlling the solenoid lock
const int buttonPin = 15;

String passcode = "";  // Set your desired passcode

String inputCode = "";
bool doorLocked = true;


// the setup function runs once when you press reset or power the board

void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  //pinMode (LED_BUILTIN, OUTPUT);
  Serial.begin(115200);
  connectToWiFi();
  configFB();
  getPasscode();
  sensorInitialization();
  xTaskCreatePinnedToCore(
    loop2,    // Function to implement the task
    "loop2",  // Name of the task
    5500,     // Stack size in bytes
    NULL,     // Task input parameter
    1,        // Priority of the task
    NULL,     // Task handle.
    0         // Core where the task should run
  );
}
// the loop function runs over and over again forever
void loop() {
  //bool flag = false;
  char key = keypad.getKey();
  // Serial.print("Key: ");
  // Serial.println(key);

  if (key) {
    //Append keys
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
        } else {
          lockDoor();
        }
      }
      // Wrong passcode
      else {
        Serial.println("Incorrect passcode!");
      }
      inputCode = "";
      Serial.println("Passcode reseted");
    }
  }

  if (digitalRead(buttonPin) == HIGH) {
    Serial.println("Requesting update passcode");
    getPasscode();
  }
  delay(500);
}
// the loop2 function also runs forver but as a parallel task
void loop2(void* pvParameters) {
  while (1) {
    if (Firebase.RTDB.getInt(&fbdo, "/DoorState")) {
      if (fbdo.dataType() == "int") {
        int door = fbdo.intData();
        // Serial.print("Success\nPasscode: ");
        // Serial.println(door);
        if (door == 1) {
          unlockDoor();
          delay(2000);
          if (Firebase.RTDB.setInt(&fbdo, "/DoorState", 0)) {
            // Serial.println("PASSED");
            // Serial.println("PATH: " + fbdo.dataPath());
            // Serial.println("TYPE: " + fbdo.dataType());
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
}


void unlockDoor() {
  digitalWrite(solenoidPin, HIGH);  // Activate the solenoid to unlock the door
  Serial.println("Door unlocked");
  doorLocked = false;
  delay(5000);  // Keep the door unlocked for 2 seconds (adjust as needed)
  lockDoor();
}

void lockDoor() {
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
}

//Setup for FireBase
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

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback;  //see addons/TokenHelper.h

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void sensorInitialization() {
  pinMode(solenoidPin, OUTPUT);
  digitalWrite(solenoidPin, LOW);  // Ensure solenoid is initially not activated
  pinMode(buttonPin, INPUT_PULLUP);
}

void getPasscode() {
  delay(1000); //avoid looping when pressed
  Serial.println("Requesting Passcode...");
  if (Firebase.RTDB.getInt(&fbdo, "/passcode")) {
    if (fbdo.dataType() == "int") {
      passcode = fbdo.intData();
      Serial.print("Success\nPasscode: ");
      Serial.println(passcode);
    }
  } else {
    Serial.println(fbdo.errorReason());
  }
}