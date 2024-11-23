//
//  WalletProtocal.swift
//  SwiftFramework
//
//  Created by Ashok on 05/09/24.
//

import Foundation
public enum paymentType {
    case live
    case sandbox
}
protocol addWalletDelegate {
    func zigCreditWallet( walletTitle: String,
                          buttonText: String,
                          userId : Int,
                          userName : String,paymentMode : paymentType,
                          creditAmount : Double,setBrandColour : String,completion: @escaping (Bool, ([String: Any])) -> Void)
}
protocol walletPaymentDelegate {
    func zigSuperwalletPayment( walletTitle: String,
                        buttonText: String,
                        userId : Int,
                        userName : String,
                        debitAmount : Double,
                        purpose: String,setBrandColour : String,completion: @escaping (Bool, ([String: Any])) -> Void)
}
protocol ZIGSuperWalletBalanceDelegate {
    func zigGetWallet(userId: Int,completion: @escaping (Bool, ([String: Any])) -> Void)
}
