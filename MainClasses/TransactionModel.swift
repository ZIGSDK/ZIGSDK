//
//  TransactionModel.swift
//  ZIGSDK
//
//  Created by Ashok on 21/11/24.
//

import Foundation
struct TranactionModel : Codable{
    let Message: String
    let TransactionsData: [TransactionDetails]
}
struct TransactionDetails : Codable{
    var transactionid : String?
    var amount : String?
    var transactiondate : String?
}
