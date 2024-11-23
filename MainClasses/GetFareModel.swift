//
//  GetFareModel.swift
//  ZIGSDK
//
//  Created by Ashok on 21/11/24.
//

import Foundation
struct getFaredata : Codable {
    var list : [ListFare]
    var ClientID : Int?
    var ClientName : String?
    var ClientDesc : String?
    var ClientSubDesc : String?
    var ClientPrimaryColorcode : String?
    var ClientSecondaryaryColorcode : String?
    var Message : String?
    var Faremessage : String?
    var Miscfee : String?
    var FarepageTitle : String?
}
struct ListFare : Codable{
    var FareId : Int?
    var FareAmount : Int?
    var CategoryId : Int?
    var RouteName : String?
    var isActive : Bool?
    var ValidTill : String?
    var CreatedDate : String?
    var createdby : String?
    var LastUpdatedDate : String?
    var LastUpdatedBy : String?
    var AgencyId : String?
    var serverdate : String?
    var `Type` : String?
    var ExpiryTime : String?
    var ZoneId : Int?
    var Farename : String?
    var MaxCount : Int?
    var ProductDescription : String?
    var ProductMiscDescription : String?
    var VerificationStatus : Int?
    var PaymentMode : Int?
    var ProductName : String?
    var ProductCost : Int?
    var ProductVegCategory : Int?
    var ProductImageURL : String?
    var Category : String?
    var CategoryImage : String?
    var BannerImage : String?
}
