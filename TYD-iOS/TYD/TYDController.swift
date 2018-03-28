//
//  File.swift
//  TYD
//
//  Created by Duanz on 2018/3/28.
//  Copyright © 2018年 apple. All rights reserved.
//

import Foundation
import LocalAuthentication

class TYD{
    func touchID (){
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "使用指纹", reply: {
                success,error in
                if success {
                    
                }else {
                    if let error = error as NSError? {
                        let message = self.errortype(errorCode: error.code)
                        print(message)
                    }
                    exit(0)
                }
            })
        }
    }
    
    func errortype(errorCode : Int) -> String{
        var message = ""
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        return message
    }
}

