//
//  TransactionClass.swift
//  ZIGSDK
//
//  Created by Ashok on 21/11/24.
//

import Foundation
class TransactionClass: TransactionDelegate {
    func zigTransaction(userId: Int,completion: @escaping (Bool, [[String: Any]],Int,String) -> Void) {
        if isReachable(){
            TransactionViewModel.sharedInstance.getTransAction(userId: userId, clientId: userDetails.clientId) { response, success, data in
                if success{
                    if response?.Message == "Ok"{
                        if let transactionData = response?.TransactionsData {
                            if let responseData = data {
                                do {
                                    if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                                       let routes = json["TransactionsData"] as? [[String: Any]] {
                                        completion(true, routes,5004,"OK")
                                    } else {
                                        completion(false, [[:]],5003,"ZIGSDK - Failed to get Transaction details")
                                    }
                                } catch {
                                    completion(false, [[:]],5003,"ZIGSDK - Failed to get Transaction details")
                                }
                            }
                        } else {
                            completion(false, [[:]],5001,"ZIGSDK - No transactions found.")
                        }
                    }
                    else{
                        if ((response?.Message.contains("invlid")) != nil) {
                            completion(false, [[:]],5002,"ZIGSDK - Invalid UserId or AuthKey")
                        }
                        else{
                            completion(false, [[:]],5003,"ZIGSDK - Failed to get Transaction details")
                        }
                    }
                }
                else{
                    completion(false, [[:]],5003,"ZIGSDK - Failed to get Transaction details")
                }
            }
        }
        else{
            completion(false, [[:]],2001,"ZIGSDK - No internet Connection")
        }
    }
}
