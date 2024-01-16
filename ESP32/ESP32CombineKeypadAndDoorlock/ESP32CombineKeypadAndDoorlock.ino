#include <Keypad.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include <addons/RTDBHelper.h>
#include <LiquidCrystal_I2C.h>
//
#define WIFI_SSID "Hotspot@PUTRA-2.4G"
#define WIFI_PASSWORD ""
// #define WIFI_SSID "XZ1"
//#define WIFI_PASSWORD "test1234"
//#define WIFI_SSID "Eyeman420"
//#define WIFI_PASSWORD "test1234"
//#define WIFI_SSID "arfa33_2.4G"
//#define WIFI_PASSWORD "blackjack66"

#define WIFI_TIMEOUT_MS 20000
#define API_KEY "AIzaSyDlVO_Ne9zTNjZljeu0_cFscLWzzJ1ppJo"
#define DATABASE_URL "https://fyp-esp32-19f8b-default-rtdb.asia-southeast1.firebasedatabase.app/"
#define USER_EMAIL "keypad@gmail.com"
#define USER_PASSWORD "keypad1234"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
bool signupOK = false;

const byte ROWS = 4;
const byte COLS = 4;
char keys[ROWS][COLS] = {
  { '1', '2', '3', 'A' },
  { '4', '5', '6', 'B' },
  { '7', '8', '9', 'C' },
  { '*', '0', '#', 'D' }
};

byte rowPins[ROWS] = { 25, 26, 27, 14 };
byte colPins[COLS] = { 19, 18, 5, 17 };

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

// set the LCD number of columns and rows
int lcdColumns = 16;
int lcdRows = 2;

// set LCD address, number of columns and rows
// if you don't know your display address, run an I2C scanner sketch
LiquidCrystal_I2C lcd(0x27, lcdColumns, lcdRows);


const int solenoidPin = 2;
const int buttonPin = 33;

String passcode = "";
String inputCode = "";
String inputAsterisk = "";
//bool buttonPressed = false;

String uid;
String wifiIP;

unsigned long lastTimeKeypadDelayed = millis();
//unsigned long lastTimeDoorDelayed;
//unsigned long lastTimeFBDelayed;
//unsigned long lastTimeUpdateDelayed;
unsigned long keypadDelay = 50;
unsigned long doorDelay = 5000;
//unsigned long FBDelay = 3000;
//unsigned long UpdateDelay = 30000;
unsigned long doorOpenTime;
//int counter = 1;

unsigned long sendDataPrevMillis = 0;
//int count = 0;

// Variables will change:
int lastState = LOW;  // the previous state from the input pin
int currentState;      // the current reading from the input pin



void setup() {
  Serial.begin(115200);
  Serial.println("Setup begin...");
  // initialize LCD
  lcd.begin();
  lcd.clear();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Starting Up...");
  sensorInitialization();
  connectToWiFi();
  configFB();
  //getPasscode();
  lcd.clear();
  lcd.setCursor(0, 0);
  // print message
  lcd.print("Passcode: ");
}

void loop() {

  unsigned long timeNow = millis();

  if (timeNow - lastTimeKeypadDelayed > keypadDelay) {
    lastTimeKeypadDelayed = timeNow;
    char key = keypad.getKey();
    lcd.setCursor(10, 0);
    //    Serial.print("Free Memory: ");
    //    Serial.println(ESP.getFreeHeap());

    //Read button to unlock
    currentState = digitalRead(buttonPin);
    if (lastState == LOW && currentState == HIGH) {
      Serial.println("Unlock button was pressed!");
      doorUnlock(timeNow);
      //      lcd.clear();
      //      lcd.setCursor(0, 1);
      //      lcd.print("Door Opened!");
      //      doorOpenTime = timeNow;
      //      Serial.println("Button pressed!, door opened");
      //      digitalWrite(solenoidPin, HIGH);
      //buttonPressed = false; //Update it to default value
    }


    if (key) {
      if (key == '*') {
        inputCode = "";
        inputAsterisk = "";
        lcd.clear();
        lcd.setCursor(0, 0);
        lcd.print("Passcode:");
        lcd.setCursor(0, 1);
        lcd.print("Passcode reset");
        Serial.println("Passcode successfully reset");
      }
      else if (key != '#' && inputCode.length() <= 4) {
        inputCode += key;
        inputAsterisk += "*";

      }  else {
        Serial.println();
        //When password is correct or button was pressed
        if (inputCode == passcode) {
          Serial.println("Valid passcode");
          doorUnlock(timeNow);
          //          lcd.clear();
          //          lcd.setCursor(0, 1);
          //          lcd.print("Door Opened!");
          //          doorOpenTime = timeNow;
          //          Serial.println("Valid passcode, door opened");
          //          digitalWrite(solenoidPin, HIGH);
          //          buttonPressed = false; //Update it to default value
        } else {
          lcd.clear();
          lcd.setCursor(0, 1);
          lcd.print("Wrong passcode!");
          Serial.println("Incorrect passcode!");
        }

        inputCode = "";
        inputAsterisk = "";
        Serial.println("Passcode reset");
      }
      lcd.setCursor(0, 0);
      lcd.print("Passcode:");
      lcd.setCursor(10, 0);
      lcd.print(inputAsterisk);
    }
    //Serial.println(counter);
    //counter++;
  }

  //Sharing between KeypadDoor and Doorlock
  if (digitalRead(solenoidPin) == HIGH && timeNow - doorOpenTime >= doorDelay) {
    digitalWrite(solenoidPin, LOW);
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Door Locked!");

    Serial.println("Door locked");
    lcd.clear();
    lcd.setCursor(0, 0);
    // print message
    lcd.print("Passcode: ");
  }

  //Request FB
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 4000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    int doorlockValue = 0;
    getPasscode();

    // Read the doorlock value from Firebase
    if (Firebase.RTDB.getInt(&fbdo, "Door/DoorState")) {
      doorlockValue = fbdo.intData();
      if (doorlockValue == 1) {
        lcd.clear();
        lcd.setCursor(0, 1);
        lcd.print("Door Opened!");
        doorOpenTime = sendDataPrevMillis;
        Serial.println("Door opened  FB");
        digitalWrite(solenoidPin, HIGH);
      }

    } else {
      Serial.println("Error GET DoorState in UnlockDoor: " + fbdo.errorReason());
      //      Serial.println("Restart ESP32...");
      //      ESP.restart();
    }

    //After turn on Solenoid, quickly update 0 to FB to avoid conflict loop
    if (digitalRead(solenoidPin) == HIGH) {

//      lcd.clear();
//      lcd.setCursor(0, 0);
//      // print message
//      lcd.print("Passcode: ");

      if (Firebase.RTDB.setInt(&fbdo, "Door/DoorState", 0)) {
      } else {
        Serial.println("FAILED");
        Serial.println("Error SET DoorState in LockDoor: " + fbdo.errorReason());
        Serial.println("Restart ESP32...");
        ESP.restart();
      }
    }

    // If the token is expired, refresh it
    if (Firebase.isTokenExpired()) {
      Firebase.refreshToken(&config);
      Serial.println("Refresh token");
    }

  }
  // save the the last state for button
  lastState = currentState;
}

// Connect to WiFi
void connectToWiFi() {

  WiFi.mode(WIFI_STA);
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

  Firebase.reconnectNetwork(true);
  // Since v4.4.x, BearSSL engine was used, the SSL buffer need to be set.
  // Large data transmission may require larger RX buffer, otherwise connection issue or data read time out can be occurred.
  //fbdo.setBSSLBufferSize(4096 /* Rx buffer size in bytes from 512 - 16384 */, 1024 /* Tx buffer size in bytes from 512 - 16384 */);
  fbdo.setBSSLBufferSize(1024, 512); // Adjust buffer sizes


  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);
  //Firebase.reconnectWiFi(true);

  //config.timeout.serverResponse = 10 * 1000;
  config.timeout.serverResponse = 20000; // Set the timeout to 20 seconds


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
  //  if (Firebase.RTDB.setString(&fbdo, "/Door/IPAddressDoor", wifiIP)) {
  //    Serial.println("IP Address send to FB!");
  //  }
  //  else {
  //    Serial.print("Error IPAddressMotion: ");
  //    Serial.println(fbdo.errorReason());
  //  }
}

void sensorInitialization() {
  pinMode(solenoidPin, OUTPUT);
  digitalWrite(solenoidPin, LOW);  // Ensure the solenoid is initially not activated
  pinMode(buttonPin, INPUT_PULLUP);


}

void getPasscode() {
  Serial.println("Requesting Passcode...");
  if (Firebase.RTDB.getInt(&fbdo, "Door/Passcode")) {
    if (fbdo.dataType() == "int") {
      passcode = fbdo.intData();
      Serial.print("Success\nPasscode: ");
      Serial.println(passcode);
    }
  } else {
    Serial.println("Error get Passcode: " + fbdo.errorReason());
    Serial.println("Restart ESP32...");
    ESP.restart();
  }
}

void doorUnlock(unsigned long tN) {
  unsigned long timeNow = tN;
  lcd.clear();
  lcd.setCursor(0, 1);
  lcd.print("Door Opened!");
  doorOpenTime = timeNow;
  Serial.println("Door opened");
  digitalWrite(solenoidPin, HIGH);
}
