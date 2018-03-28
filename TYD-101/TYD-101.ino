#include"LMD.h"
#include<CurieBLE.h>
int flag;
unsigned int PMValueSend;
unsigned int oldPMValueSend = 0;
long previousMillis = 0;

uint8_t a = 1;
uint8_t b = 2;
    
uint aaa, bbb; //aaa = 时间，bbb = 速度
//蓝牙定义：
BLEService lmdService("19B10010-E8F2-537E-4F6C-D104768A1214");//蓝牙服务函数
BLECharCharacteristic lmdCharacteristic("19B10011-E8F2-537E-4F6C-D104768A1214", BLERead |BLEWrite);//接受选择模式
BLECharCharacteristic PMCharacteristic("19B10012-E8F2-537E-4F6C-D104768A1214", BLERead | BLENotify);//发送PM
BLECharCharacteristic SetTimeCharacteristic("19B10013-E8F2-537E-4F6C-D104768A1214", BLERead | BLEWrite);//自动模式设置时间
BLECharCharacteristic SetSpeedCharacteristic("19B10014-E8F2-537E-4F6C-D104768A1214", BLERead | BLEWrite);

void setup() {
  pinMode(MotorPin, OUTPUT);
  pinMode(PMPin, INPUT);
  pinMode(LED, OUTPUT);
  Serial.begin(9600);

  BLE.begin();
  BLE.setLocalName("LMD");
  BLE.setAdvertisedService(lmdService);//广播服务
  lmdService.addCharacteristic(lmdCharacteristic);//服务添加接受
  lmdService.addCharacteristic(PMCharacteristic);//服务添加发送
  lmdService.addCharacteristic(SetTimeCharacteristic);
  lmdService.addCharacteristic(SetSpeedCharacteristic);

  BLE.addService(lmdService);
  PMCharacteristic.setValue(0);
  SetTimeCharacteristic.setValue(0);
  SetSpeedCharacteristic.setValue(0);

  BLE.advertise();
  pinMode(13, OUTPUT);
  Serial.println("BLE LMD BEGIN");
}

void loop() {
  BLE.poll();
  if (lmdCharacteristic.written()) {
    if(lmdCharacteristic.value() == '1'){
      Serial.println("Auto Mood"); digitalWrite(13, HIGH); AutoMood();delay(5000);digitalWrite(13,LOW);
      }
    if(lmdCharacteristic.value() == '2'){
      Serial.println("Manual Mood"); digitalWrite(13, LOW); flag = 1; 
      }
  }
}

