//
//  ZIGWalletMethod.swift
//  SwiftFramework
//
//  Created by Ashok on 05/09/24.
//

import Foundation
import UIKit

class ZIGSuperWallet: addWalletDelegate{
    func zigCreditWallet(walletTitle: String, buttonText: String, userId: Int, userName: String, paymentMode: paymentType, creditAmount: Double, setBrandColour: String, completion: @escaping (Bool, ([String : Any])) -> Void) {
        if isReachable(){
            if featureStatus.WalletEnableStatus{
                if userId == userDetails.UserId {
                    AddWalletViewController.brandTitle = walletTitle
                    AddWalletViewController.payTitle = buttonText
                    if paymentMode == .live {
                        paymentMethod.paymentMode = true
                    } else if paymentMode == .sandbox {
                        paymentMethod.paymentMode = false
                    }
                    AddWalletViewController.userID = userId
                    AddWalletViewController.userName = userName
                    AddWalletViewController.creditAmount = creditAmount
                    AddWalletViewController.setBrandColour = setBrandColour
                    
                    let storyboard = UIStoryboard(name: "addWallet", bundle: Bundle(for: NeedPermisson.self))
                    let addWalletScreen = storyboard.instantiateViewController(withIdentifier: "AddWalletViewController") as! AddWalletViewController
                    guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
                        return
                    }
                    addWalletScreen.successHandler = { success, message in
                        completion(success, message ?? [:])
                    }
                    
                    addWalletScreen.failureHandler = {  success, message in
                        completion(success, message ?? [:])
                    }
                    addWalletScreen.modalPresentationStyle = .fullScreen
                    rootViewController.present(addWalletScreen, animated: true, completion: nil)
                }
                else{
                    let jsonObject: [String: Any] = [
                        "statusCode" : 4103,
                        "message" : "ZIGSDK - Invalid Authentication or userID"
                    ]
                    completion(false, jsonObject)
                }
            }
            else{
                let jsonObject: [String: Any] = [
                    "statusCode" : 4103,
                    "message" : "ZIGSDK - Your Wallet has been blocked,Contact administrator"
                ]
                completion(false, jsonObject)
            }
        }
        else{
            let jsonObject: [String: Any] = [
                "statusCode" : 2001,
                "message" : "ZIGSDK - ZIGSDK - No internet Connection"
            ]
            completion(false, jsonObject)
        }
    }
}
class ZIGwalletPaytment: walletPaymentDelegate {
    func zigSuperwalletPayment(walletTitle: String, buttonText: String, userId: Int, userName: String, debitAmount: Double,purpose: String,setBrandColour : String, completion: @escaping (Bool, ([String: Any])) -> Void) {
        if isReachable(){
            if featureStatus.WalletEnableStatus {
                if userId == userDetails.UserId {
                    ReduceWalletAmount.debitAmount = 0.0
                    ReduceWalletAmount.userId = userId
                    ReduceWalletAmount.debitAmount = debitAmount
                    ReduceWalletAmount.purpose = purpose
                    ReduceWalletAmount.userName = userName
                    ReduceWalletAmount.walletTitle = walletTitle
                    ReduceWalletAmount.payTitle = buttonText
                    ReduceWalletAmount.setBrandColour = setBrandColour
                    let storyboard = UIStoryboard(name: "WalletPayment", bundle: Bundle(for: NeedPermisson.self))
                    guard let addWalletScreen = storyboard.instantiateViewController(withIdentifier: "ReduceWalletAmount") as? ReduceWalletAmount else {
                        return
                    }
                    
                    addWalletScreen.successHandler = { success, message in
                        completion(success, message ?? [:])
                    }
                    
                    addWalletScreen.failureHandler = { success, message in
                        completion(success, message ?? [:])
                    }
                    
                    addWalletScreen.modalPresentationStyle = .overCurrentContext
                    
                    if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                        rootViewController.present(addWalletScreen, animated: false, completion: {
                            addWalletScreen.view.frame = CGRect(x: 0, y: rootViewController.view.bounds.height, width: rootViewController.view.bounds.width, height: 200)
                            
                            UIView.animate(withDuration: 0.3) {
                                addWalletScreen.view.frame = CGRect(x: 0, y: rootViewController.view.bounds.height - 350, width: rootViewController.view.bounds.width, height: 350)
                                
                                let path = UIBezierPath(roundedRect: addWalletScreen.view.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 20, height: 20))
                                let mask = CAShapeLayer()
                                mask.path = path.cgPath
                                addWalletScreen.view.layer.mask = mask
                            }
                        })
                    }
                }
                else{
                    let jsonObject: [String: Any] = [
                        "statusCode" : 4103,
                        "message" : "ZIGSDK - Invalid Authentication or userID"
                    ]
                    completion(false, jsonObject)
                }
            }
            else{
                let jsonObject: [String: Any] = [
                    "statusCode" : 4103,
                    "message" : "ZIGSDK - Your Wallet has been blocked,Contact administrator"
                ]
                completion(false, jsonObject)
            }
        }
        else{
            let jsonObject: [String: Any] = [
                "statusCode" : 2001,
                "message" : "ZIGSDK - No internet Connection"
            ]
            completion(false, jsonObject)
        }
    }
}
class ZIGSuperWalletBalance : ZIGSuperWalletBalanceDelegate {
    func zigGetWallet(userId: Int, completion: @escaping (Bool, ([String : Any])) -> Void) {
        if isReachable(){
            if featureStatus.WalletEnableStatus {
                if userId == userDetails.UserId {
                    WalletViewModel.sharedInstance.walletBalanceCheck(clientId: MqttValidationData.userid, userId: userId) { response, success in
                        if success{
                            let balanceAmount = String.init(format: "%.2f", response?.walletBalanceAmount ?? 0.0)
                            let jsonObject: [String: Any] = [
                                "statusCode" : 4201,
                                "WalletBalance" : "ZIGSDK - \(response?.walletBalanceAmount ?? 0.0)",
                                "WalletMessage" : "ZIGSDK - your Wallet has \(balanceAmount ?? "0.00")"
                            ]
                            completion(success,jsonObject)
                        }
                        else{
                            let jsonObject: [String: Any] = [
                                "statusCode" : 4202,
                                "message" : "ZIGSDK - \(response?.Message ?? "")"
                            ]
                            completion(success,jsonObject)
                        }
                    }
                }
                else{
                    let jsonObject: [String: Any] = [
                        "statusCode" : 4103,
                        "message" : "ZIGSDK - Invalid Authentication or userID"
                    ]
                    completion(false, jsonObject)
                }
            }
            else{
                let jsonObject: [String: Any] = [
                    "statusCode" : 4103,
                    "message" : "ZIGSDK - Your Wallet has been blocked,Contact administrator"
                ]
                completion(false, jsonObject)
            }
        }
        else{
            let jsonObject: [String: Any] = [
                "statusCode" : 2001,
                "message" : "ZIGSDK - No internet Connection"
            ]
            completion(false, jsonObject)
        }
    }
}
