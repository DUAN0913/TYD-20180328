//
//  ViewController.swift
//  TYD
//
//  Created by Duanz on 2018/3/27.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit
import CoreBluetooth
import LocalAuthentication

class ViewController: UIViewController,CBCentralManagerDelegate,CBPeripheralDelegate  {
    
    lazy var TYDO = TYD()

    @IBOutlet weak var StatusLabel: UILabel!
    
    var tydManager : CBCentralManager!
    var tydPeripheral : CBPeripheral!
    var tydCharacteristic : CBCharacteristic!
    
    let tydCharacteristicUUID = ""
    let statusCharacteristicUUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tydManager = CBCentralManager.init(delegate: self as CBCentralManagerDelegate, queue: nil)
        StatusLabel.text = ""
        TYDO.touchID()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ConnectButton(_ sender: UIButton) {
        switch tydManager.state {
        case .poweredOn:
            StatusLabel.text = "正在扫描"
            tydManager.scanForPeripherals(withServices: nil, options: nil)
            print("正在扫描")
            break;
        default:
            print("无变化")
            break;
        }
    }
    
    @IBAction func UnlockButton(_ sender: UIButton) {
        print("点击自动")
        if tydPeripheral != nil && tydCharacteristic != nil{
            print("点中了")
            tydPeripheral.writeValue("1".data(using: String.Encoding.utf8)!, for: tydCharacteristic, type: CBCharacteristicWriteType.withResponse)
            print("能发了")
            StatusLabel.text = "开锁成功"
        }
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case .poweredOn : StatusLabel.text = "蓝牙已开启"
        print("开启")
        case .unauthorized : StatusLabel.text = "未授权"
        print("未授权")
        default : StatusLabel.text = "蓝牙未开启"
        print("关闭")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("终于进来了")
        if peripheral.identifier.uuidString == "10A22048-FC0B-7033-3324-BC16A773AE56"{
            print("不容易啊")
            tydPeripheral = peripheral
            central.stopScan()
            central.connect(tydPeripheral, options: nil)
            StatusLabel.text = "扫描成功，开始连接"
            print("扫描成功，开始连接")
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        StatusLabel.text = "连接成功"
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        print("连接成功")
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        StatusLabel.text = "连接失败"
        print("连接失败")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil{
            print("查询服务失败")
            return
        }else{
            for service in tydPeripheral.services!{
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil{
            print("查询特征失败")
            return
        }else{
            for characteristic in service.characteristics!{
                print("终于查到Characteristic😭")
                print(characteristic.uuid.uuidString)
                
                if characteristic.uuid.uuidString == tydCharacteristicUUID{
                    tydCharacteristic = characteristic
                    print(characteristic.uuid.uuidString)
                    print(tydCharacteristic.properties.rawValue)
                }
                if characteristic.uuid.uuidString == statusCharacteristicUUID{
                    peripheral.readValue(for: characteristic)
                }
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil{
            print(error!)
        }else{
            if characteristic.uuid.uuidString == tydCharacteristicUUID{
                print("DONE")
                return
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil{
            print("无更新")
        }else{
            if characteristic.uuid.uuidString == statusCharacteristicUUID{
                print("值为：")
                print(characteristic.value!)
                //少
            }
        }
    }
}

