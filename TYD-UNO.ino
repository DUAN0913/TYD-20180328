#include <Keypad.h>
#include<Wire.h>
#include <PN532_I2C.h>
#include <PN532.h>
#include <NfcAdapter.h>
PN532_I2C pn532i2c(Wire);
PN532 nfc(pn532i2c);
uint8_t trueNumber[] = {176,227,71,167,0,0,0};
int flag = 0;

const byte ROWS = 4; 
const byte COLS = 4; 

String trueCode = "01234";
String enterCode = "00000";
int i = 0;
int j = 0;
char hexaKeys[ROWS][COLS] = {
  {'1','2','3','A'},
  {'4','5','6','B'},
  {'7','8','9','C'},
  {'*','0','#','D'}
};
byte rowPins[ROWS] = {2,3,4,5}; 
byte colPins[COLS] = {6,7,8,9}; 

Keypad customKeypad = Keypad( makeKeymap(hexaKeys), rowPins, colPins, ROWS, COLS);

void NFCtag(){
  boolean success;
  uint8_t uid[] = { 0, 0, 0, 0, 0, 0, 0 };
  uint8_t uidLength;
  success = nfc.readPassiveTargetID(PN532_MIFARE_ISO14443A, &uid[0], &uidLength);
  if (success) {
    Serial.println("Found a card!");
    Serial.print("UID Length: ");Serial.print(uidLength, DEC);Serial.println(" bytes");
    Serial.print("UID Value: ");
    for (uint8_t i=0; i < uidLength; i++) 
    {
      Serial.print("0x");
      Serial.print(uid[i]); 
    }
    Serial.println("");
    delay(1000);
    if((uid[0] == trueNumber[0]) && (uid[1] == trueNumber[1]) && (uid[2] == trueNumber[2]) && (uid[3] == trueNumber[3])){
      digitalWrite(13,HIGH);
      delay(3000);
      digitalWrite(13,LOW);
      }else{
        Warning();
        digitalWrite(13,LOW);
        Serial.println("Entercode:");
        flag = 1;
      }
  }else
  {
    Serial.println("Timed out waiting for a card");
  }
}

void jianpan(){
  char customKey = customKeypad.getKey();

  if(customKey){
    i = i+1;
    enterCode[i] = customKey;
    Serial.println(enterCode);
    }
  if(customKey == 'D'){
    if(enterCode == trueCode){
      digitalWrite(13,HIGH);
      delay(5000);
      digitalWrite(13,LOW);
      i = 0;
      enterCode = "00000";
      }else{
        Warning();
        digitalWrite(13,LOW);
        Serial.println("Enter again");
        i = 0;
        enterCode = "00000";
        j = j+1;
        }
    }
  }

void Warning(){
  for(int tyd = 0;tyd<3;tyd++){
  digitalWrite(11,HIGH);
  delay(1000);
  digitalWrite(11,LOW);
  delay(1000);
  }
  }

void setup() {
  pinMode(13,OUTPUT);
  pinMode(12,INPUT);
  Serial.begin(9600);
  Serial.println("Hello!");
  nfc.begin();
  uint32_t versiondata = nfc.getFirmwareVersion();
  if (! versiondata) {
    Serial.print("Didn't find PN53x board");
    while (1); 
  }
  Serial.println("Welcome,show NFC tag");
  nfc.setPassiveActivationRetries(0xFF);
  nfc.SAMConfig();
  Serial.println("Waiting for an ISO14443A card");
}

void loop() {
   char customKey = customKeypad.getKey();
   int c = digitalRead(12);
   Serial.println(c);
   if(flag == 0){
     NFCtag();     
   }
  
   if(flag == 1){
     jianpan();
   }

   if(c == HIGH){
    digitalWrite(13,HIGH);
    delay(5000);
    digitalWrite(13,LOW);
    }
}
