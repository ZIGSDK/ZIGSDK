//
//  PaymentModel.swift
//  ZIGSDK
//
//  Created by Ashok on 20/11/24.
//

import Foundation
struct paymentGateway : Codable{
    var xResult : String?
    var xStatus : String?
    var xError : String?
    var xErrorCode : String?
    var xRefNum : String?
    var xExp : String?
    var xAuthCode : String?
    var xBatch : String?
    var xAvsResultCode : String?
    var xAvsResult : String?
    var xCvvResultCode : String?
    var xCvvResult : String?
    var xAuthAmount : String?
    var xMaskedCardNumber : String?
    var xCardType : String?
    var xName : String?
    var xToken : String?
    var xMID : String?
    var xTID : String?
    var xCurrency : String?
    var xDate : String?
    var xEntryMethod : String?
}
struct referanceResponse : Codable{
    var Message: String?
}
