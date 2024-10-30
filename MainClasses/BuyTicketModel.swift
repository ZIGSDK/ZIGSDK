//
//  BuyTicketModel.swift
//  ZIGSDK
//
//  Created by Ashok on 23/10/24.
//

import Foundation

struct BuyTicket: Codable{
    var list : [List?]
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
struct List: Codable{
    var FareId : Int?
    var FareAmount : Double?
    var CategoryId : Int?
    var RouteName : String?
    var isActive : Bool?
    var ValidTill : String?
    var CreatedDate : String?
    var createdby : String?
    var LastUpdatedDate : String?
    var LastUpdatedBy : String?
    var AgencyId : Int?
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
    var ProductCost : Double?
    var ProductVegCategory : Int?
    var ProductImageURL : String?
    var Category : String?
    var CategoryImage : String?
    var BannerImage : String?
}

struct AddTicket: Codable{
    var Message: String?
    var TicketId: Int?
}

struct GetTicket: Codable{
    var Message : String?
    var Count : Int?
    var ID_Count_User : Int?
    var Total_Ticket_Count : Int?
    var Tickets : [Ticket]
}
struct Ticket: Codable{
    var TransactionDate : String?
    var status : Int?
    var serverdate : String?
    var Username : String?
    var UserId : Int?
    var Amount : Double?
    var FromAddress : String?
    var DestinationAddress : String?
    var MasterTransactionid : Int?
    var Subsets : [subset?]
    var TransactionId : String?
    var Ticketcount : Int?
}
struct subset: Codable{
    var Expirydate : String?
    var Activateddate : String?
    var Validateddate : String?
    var FromAddress : String?
    var status : Int?
    var isActive : Bool?
    var isValid : Bool?
    var AgencyId : String?
    var TicketId : Int?
    var RemainingTime : Int?
    var TripId : String?
    var Fareid : Int?
    var Amount : Double?
    var DestinationAddress : String?
    var RouteId : String?
}

struct ActivateTicket: Codable{
    var Message : String?
}
