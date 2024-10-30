//
//  RealmModel.swift
//  SwiftFramework
//
//  Created by apple on 28/03/24.
//

import Foundation
import RealmSwift
class TicketRealmMethod : Object{
    @objc dynamic var TransactionDate = ""   
    @objc dynamic var Username = ""
    @objc dynamic var UserId = 0
    @objc dynamic var Expirydate = ""
    @objc dynamic var Activateddate = ""
    @objc dynamic var Validateddate = ""
    @objc dynamic var FromAddress = ""
    @objc dynamic var isActive :Bool = false
    @objc dynamic var isValid: Bool = false
    @objc dynamic var AgencyId = 0
    @objc dynamic var TicketId = 0
    @objc dynamic var TripId = ""
    @objc dynamic var Fareid = 0
    @objc dynamic var Amount = 0.0
    @objc dynamic var DestinationAddress = ""
    @objc dynamic var RouteId = ""
    @objc dynamic var Ticketcount = 0
    @objc dynamic var TicketStatus = 0
}

struct OdataAPi : Codable {
    var Message : String?
}



class TicketDetails: Object{
    @objc dynamic var ticketID: Int = 0
    @objc dynamic var passengerName: String = ""
    @objc dynamic var destination: String = ""
    @objc dynamic var price: Double = 0.0
    @objc dynamic var dateOfJourney: Date?
    
    convenience init(ticketID: Int, passengerName: String, destination: String, price: Double, dateOfJourney: Date?) {
        self.init()
        self.ticketID = ticketID
        self.passengerName = passengerName
        self.destination = destination
        self.price = price
        self.dateOfJourney = dateOfJourney
    }
}
