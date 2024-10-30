//
//  AddTicket.swift
//  ZIGSDK
//
//  Created by Ashok on 23/10/24.
//

import Foundation
import RealmSwift
struct TicketList {
    var FromAddress: String
    var DestinationAddress: String
    var Amount: Double
    var Fareid: Int
    var RouteId: String
}
class TicketMethods : TicketValidationDelegate{
    var ticketArray: [[String: Any]] = []
    var TicketListData : [TicketList] = []
    
    static let sharedInstance: TicketMethods = {
        let instance = TicketMethods()
        return instance
    }()
    
    public func addTickets(TotalAmount: Double, TicketDetails: [[String: Any]], completion: @escaping(Bool,String) -> Void){
        if isReachable(){
            let agencyid = userDetails.clientId
            let userId = UserDefaults.standard.integer(forKey: "userId")
            let authKey = UserDefaults.standard.string(forKey: "AuthKey")
            let username = UserDefaults.standard.string(forKey: "UserEmailID")
            print("ZIG-SDK-ADDTicket======>",TicketDetails)
            if TicketDetails.count > 0{
                var fareID = 0
                var routeName = ""
                var amount = 0.0
                let FromAddress = "S 6th @ W Liberty"
                let DestinationAddress = "4th @ Ormsby"
                let transactionId = generateUniqueTenDigitID()
                
                let destinationAddress1 = "1257 S 3rd St, Louisville, KY 40203, USA"
                let fromaddress1 = "Louisville, KY, USA"
                for ticket in TicketDetails {
                    fareID = ticket["fareID"] as? Int ?? 0
                    routeName = ticket["routeName"] as? String ?? ""
                    amount = ticket["ticketCost"] as? Double ?? 0.0
                    TicketListData.append(TicketList(FromAddress: FromAddress, DestinationAddress: DestinationAddress, Amount: amount, Fareid: fareID, RouteId: routeName))
                }
                
                TicketViewModel.sharedInstance.zigAddTicket(agencyid: agencyid, TotalAmount: TotalAmount, UserID: userId, TicketList: TicketListData, DestinationAddress: destinationAddress1, Token: authKey ?? "", FromAddress: fromaddress1, Message: "Ticket Take in IOS App",transactionID: transactionId, UserName:username ?? "") { response, success in
                    if success{
                        if response?.Message ?? "" == "Ok"{
                            self.GetTicket { success, Message in
                                if success{
                                    completion(true,"Ticket Added Successfully")
                                }
                                else{
                                    completion(false,"Issue on add Ticket")
                                }
                            }
                        }
                        else{
                            completion(false,"Issue on add Ticket")
                        }
                    }
                    else{
                        completion(false,"TicketDetails are empty!")
                    }
                    
                }
            }
        }
        else{
            completion(false,"No Internet Connection")
        }
    }
    func GetTicket(completion: @escaping (Bool, [[String: Any]]) -> Void) {
        var userId = userDetails.UserId
        if isReachable(){
            TicketViewModel.sharedInstance.ZigGetTicket(userId: userId, agencyId: userDetails.clientId) { response, success in
                if success {
                    do {
                        if response?.Message ?? "" == "Ok" {
                            self.DeleteRealm(agencyId: userDetails.clientId) { success, message in
                                if success && message == "Realm Deleteed Successfully" {
                                    let ticketDetails = response?.Tickets ?? []
                                    print("ZIG-SDK-TicketDetails=====>", ticketDetails.count)
                                    
                                    var ticketsArray: [[String: Any]] = []
                                    
                                    for ticket in ticketDetails {
                                        print("ZIG-SDK-TicketDetails=====>", ticketDetails.count)
                                        
                                        // Initialize ticket variables
                                        let TransactionDate = ticket.TransactionDate ?? ""
                                        let Username = ticket.Username ?? ""
                                        let UserId = ticket.UserId ?? 0
                                        let Ticketcount = ticket.Ticketcount ?? 0
                                        
                                        // Iterate over subsets
                                        let subset = ticket.Subsets
                                        if subset.count > 0 {
                                            for subsetData in subset {
                                                let Expirydate = subsetData?.Expirydate ?? ""
                                                let Activateddate = subsetData?.Activateddate ?? ""
                                                let Validateddate = subsetData?.Validateddate ?? ""
                                                let FromAddress = subsetData?.FromAddress ?? ""
                                                let isActive = subsetData?.isActive ?? false
                                                let isValid = subsetData?.isValid ?? false
                                                let AgencyId = Int(subsetData?.AgencyId ?? "0") ?? 0
                                                let TicketId = subsetData?.TicketId ?? 0
                                                let TripId = subsetData?.TripId ?? ""
                                                let Fareid = subsetData?.Fareid ?? 0
                                                let Amount = subsetData?.Amount ?? 0.0
                                                let DestinationAddress = subsetData?.DestinationAddress ?? ""
                                                let RouteId = subsetData?.RouteId ?? ""
                                                let TicketStatus = subsetData?.status ?? 0
                                                
                                                // Prepare dictionary for each ticket
                                                let ticketDictionary: [String: Any] = [
                                                    "TransactionDate": TransactionDate,
                                                    "Username": Username,
                                                    "UserId": UserId,
                                                    "Expirydate": Expirydate,
                                                    "Activateddate": Activateddate,
                                                    "Validateddate": Validateddate,
                                                    "FromAddress": FromAddress,
                                                    "isActive": isActive,
                                                    "isValid": isValid,
                                                    "AgencyId": AgencyId,
                                                    "TicketId": TicketId,
                                                    "TripId": TripId,
                                                    "Fareid": Fareid,
                                                    "Amount": Amount,
                                                    "DestinationAddress": DestinationAddress,
                                                    "RouteId": RouteId,
                                                    "Ticketcount": Ticketcount,
                                                    "TicketStatus": TicketStatus
                                                ]
                                                
                                                // Add ticket data to ticketsArray
                                                ticketsArray.append(ticketDictionary)
                                                
                                                // Save to Realm
                                                do {
                                                    let realm = try Realm()
                                                    let newTask = TicketRealmMethod()
                                                    newTask.TransactionDate = TransactionDate
                                                    newTask.Username = Username
                                                    newTask.UserId = UserId
                                                    newTask.Expirydate = Expirydate
                                                    newTask.Activateddate = Activateddate
                                                    newTask.Validateddate = Validateddate
                                                    newTask.FromAddress = FromAddress
                                                    newTask.isActive = isActive
                                                    newTask.isValid = isValid
                                                    newTask.AgencyId = AgencyId
                                                    newTask.TicketId = TicketId
                                                    newTask.TripId = TripId
                                                    newTask.Fareid = Fareid
                                                    newTask.Amount = Amount
                                                    newTask.DestinationAddress = DestinationAddress
                                                    newTask.RouteId = RouteId
                                                    newTask.Ticketcount = Ticketcount
                                                    newTask.TicketStatus = TicketStatus
                                                    
                                                    try realm.write {
                                                        realm.add(newTask)
                                                    }
                                                } catch {
                                                    completion(false, [])
                                                    return
                                                }
                                                break
                                            }
                                        } else {
                                            // If no subsets found, complete with empty data
                                            completion(false, [])
                                            return
                                        }
                                    }
                                    
                                    // If processing is successful, call completion with ticketsArray
                                    completion(true, ticketsArray)
                                } else {
                                    completion(false, [])
                                }
                            }
                        } else {
                            completion(false, [])
                        }
                    } catch {
                        completion(false, [])
                    }
                } else {
                    completion(false, [])
                }
            }
        }
        else{
            completion(false,[["Message": "No internet Connection"]])
        }
    }
    func DeleteRealm(agencyId: Int,completion:@escaping(Bool,String)->Void){
        if isReachable(){
            do {
                let realm = try Realm()
                let ticketsToDelete = realm.objects(TicketRealmMethod.self).filter("AgencyId == %@", agencyId)
                try realm.write {
                    realm.delete(ticketsToDelete)
                }
                completion(true,"Realm Deleteed Successfully")
            } catch {
                completion(false,"Realm not Deleteed")
            }
        }
        else{
            completion(false,"No Internet Connection")
        }
    }
    func deleteAllTickets(completion:@escaping(Bool,String)->Void) {
        let realm = try! Realm()
        
        try! realm.write {
            let allTickets = realm.objects(TicketRealmMethod.self)
            realm.delete(allTickets)
            completion(true,"Successfully deleted")
        }
    }
    func generateUniqueTenDigitID() -> String {
        let timestamp = Int(Date().timeIntervalSince1970) % 1000000
        let randomNumber = Int.random(in: 0...999999)
        let uniqueID = 9000000000 + (timestamp * 1000 + randomNumber)
        return String(uniqueID)
    }
    func ActivateTicket(ticketId: Int, completion: @escaping (Bool, [[String : Any]]) -> Void) {
        if isReachable(){
            let userId = UserDefaults.standard.integer(forKey: "userId")
            TicketViewModel.sharedInstance.ZigActivate(TicketId: ticketId, userId: userId) { response, success in
                if success{
                    self.GetTicket { success, responsedata in
                        if success{
                            completion(true, responsedata)
                        }
                        else{
                            let jsonObject: [String: Any] = [
                                "Message" : "Issue on Ticket Activation",
                            ]
                            completion(false,[jsonObject])
                        }
                    }
                }
                else{
                    let jsonObject: [String: Any] = [
                        "Message" : "Issue on Ticket Activation",
                    ]
                    completion(false,[jsonObject])
                }
            }
        }
        else{
            completion(false,[["Message": "No internet Connection"]])
        }
    }
    func TicketStatusChange(ticketId: Int,newIsActiveStatus:Int,completion:@escaping(Bool,String)->Void){
        if isReachable(){
            do {
                let realm = try Realm()
                if let ticketToUpdate = realm.objects(TicketRealmMethod.self).filter("TicketId == %@", ticketId).first {
                    try realm.write {
                        ticketToUpdate.TicketStatus = newIsActiveStatus
                    }
                    completion(true,"RealmUpdate Successfully")
                } else {
                    completion(false,"RealmUpdate not Successfully")
                }
            } catch {
                completion(false,"RealmUpdate not Successfully")
            }
        }
        else{
            completion(false,"No internet Connection")
        }
    }
}

