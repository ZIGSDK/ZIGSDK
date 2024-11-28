//
//  TransactionClass.swift
//  ZIGSDK
//
//  Created by Ashok on 21/11/24.
//

import Foundation
class TransactionClass: TransactionDelegate {
    func zigTransaction(userId: Int,completion: @escaping (Bool, [[String: Any]]) -> Void) {
        if isReachable(){
            TransactionViewModel.sharedInstance.getTransAction(userId: userId, clientId: userDetails.clientId) { response, success in
                if success{
                    if response?.Message == "Ok"{
                        if let transactionData = response?.TransactionsData {
                            let formattedResponse: [[String: Any]] = transactionData.map {
                                return [
                                    "message": "ok",
                                    "statusCode" : 5004,
                                    "transactionid": $0.transactionid ?? "",
                                    "amount": $0.amount ?? "0.0",
                                    "transactiondate": $0.transactiondate ?? ""
                                ]
                            }
                            completion(true, formattedResponse)
                        } else {
                            completion(false, [["statusCode" : 5001,
                                                "message": "No transactions found."]])
                        }
                    }
                    else{
                        if ((response?.Message.contains("invlid")) != nil) {
                            completion(false,[["statusCode" : 5002,
                                               "message": "ZIGSDK - Invalid UserId or AuthKey"]])
                        }
                        else{
                            completion(false,[["statusCode" : 5003,
                                               "message": "ZIGSDK - Failed to get Transaction details"]])
                        }
                    }
                }
                else{
                    completion(false,[["statusCode" : 5003,
                                       "message": "ZIGSDK - Failed to get Transaction details"]])
                }
            }
        }
        else{
            completion(false,[["statusCode" : 2001,
                               "message": "No internet Connection"]])
        }
    }
}
