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
    
    public func addTickets(TotalAmount: Double, TicketDetails: [[String: Any]], completion: @escaping(Bool,Int,String) -> Void){
        if isReachable(){
            userDetails.UserId = UserDefaults.standard.integer(forKey: "userId")
            userDetails.userName = UserDefaults.standard.string(forKey: "UserName") ?? ""
            userDetails.emailId = UserDefaults.standard.string(forKey: "UserEmailID") ?? ""
            _ = userDetails.clientId
            let userId = UserDefaults.standard.integer(forKey: "userId")
            let authKey = UserDefaults.standard.string(forKey: "AuthKey")
            let username = UserDefaults.standard.string(forKey: "UserEmailID")
            if userDetails.UserId != 0 {
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
                    let AmountCent = Int(TotalAmount * 100)
                    if paymentMethod.paymentmethod {
                        ZIGwalletPaytment().zigSuperwalletPayment(walletTitle: "", buttonText: "", userId: userDetails.UserId, userName: userDetails.userName, debitAmount: TotalAmount, purpose: "Ticket Purchase", setBrandColour: "") { success, message in
                            if success{
                                ReferanceViewModel.sharedInstance.addReferance(Amount: AmountCent, Transcationtype: "Wallet", Currency: "USD", Txn_id: transactionId, Correlation_id: "", Bankmessage: "", Txnstatus: "true", Gatewayrespcode: "", Retrival_ref_no: "", Specialpayment: "", CardType: "", MaskedCardNumber: "", Txntag: "", EmailID: userDetails.emailId, Phone: "", UserName: userDetails.userName, Userid: "\(userDetails.UserId)", Txn_ref_no: transactionId, Error_code: "", Error_description: "", Status_code: "", Fareid: "\(fareID)", Wallet: false, AuthKey: userDetails.AuthKey) { response, success in
                                    if success {
                                        if response?.Message == "Ok"{
                                            TicketViewModel.sharedInstance.zigAddTicket(authKey: userDetails.AuthKey, agencyid: userDetails.clientId, TotalAmount: TotalAmount, UserID: userId, TicketList: self.TicketListData, DestinationAddress: destinationAddress1, Token: authKey ?? "", FromAddress: fromaddress1, Message: "Ticket Take in IOS App",transactionID: transactionId, UserName: userDetails.userName) { response, success in
                                                if success{
                                                    if response?.Message ?? "" == "Ok"{
                                                        self.GetTicket { success, Message,statusCode,message  in
                                                            if success{
                                                                completion(true,3103,"ZIGSDK - Ticket Added Successfully")
                                                            }
                                                            else{
                                                                completion(false, 3102,"ZIGSDK - Ticket not generated")
                                                            }
                                                        }
                                                    }
                                                    else{
                                                        ReferanceViewModel.sharedInstance.addReferance(Amount: AmountCent, Transcationtype: "Wallet", Currency: "USD", Txn_id: transactionId, Correlation_id: "", Bankmessage: "", Txnstatus: "false", Gatewayrespcode: "Get Ticket Failed", Retrival_ref_no: "", Specialpayment: "", CardType: "", MaskedCardNumber: "", Txntag: "", EmailID: userDetails.emailId, Phone: "", UserName: userDetails.userName, Userid: "\(userDetails.UserId)", Txn_ref_no: transactionId, Error_code: "", Error_description: "", Status_code: "", Fareid: "\(fareID)", Wallet: false, AuthKey: userDetails.AuthKey) { response, success in
                                                            if success{
                                                                if response?.Message == "Ok"{
                                                                    completion(false, 3102,"ZIGSDK - Ticket not generated")
                                                                }
                                                                else{
                                                                    completion(false, 3102,"ZIGSDK - Ticket not generated")
                                                                }
                                                            }
                                                            else{
                                                                completion(false, 3102,"ZIGSDK - Ticket not generated")
                                                            }
                                                        }
                                                    }
                                                }
                                                else{
                                                    ReferanceViewModel.sharedInstance.addReferance(Amount: AmountCent, Transcationtype: "Wallet", Currency: "USD", Txn_id: transactionId, Correlation_id: "", Bankmessage: "", Txnstatus: "false", Gatewayrespcode: "Add Ticket Failed", Retrival_ref_no: "", Specialpayment: "", CardType: "", MaskedCardNumber: "", Txntag: "", EmailID: userDetails.emailId, Phone: "", UserName: userDetails.userName, Userid: "\(userDetails.UserId)", Txn_ref_no: transactionId, Error_code: "", Error_description: "", Status_code: "", Fareid: "\(fareID)", Wallet: false, AuthKey: userDetails.AuthKey) { response, success in
                                                        if success{
                                                            if response?.Message == "Ok"{
                                                                completion(false, 3102,"ZIGSDK - Ticket not generated")
                                                            }
                                                            else{
                                                                completion(false, 3102,"ZIGSDK - Ticket not generated")
                                                            }
                                                        }
                                                        else{
                                                            completion(false, 3102,"ZIGSDK - Ticket not generated")
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        else{
                                            completion(false, 3102,"ZIGSDK - Ticket not generated")
                                        }
                                    }
                                    else
                                    {
                                        completion(false, 3102,"ZIGSDK - Ticket not generated")
                                    }
                                }
                            }
                            else
                            {
                                completion(false, 4102,"ZIGSDK - Failed to debit amount")
                            }
                        }
                    }
                    else{
                        ReferanceViewModel.sharedInstance.addReferance(Amount: AmountCent, Transcationtype: "Free", Currency: "USD", Txn_id: transactionId, Correlation_id: "", Bankmessage: "", Txnstatus: "true", Gatewayrespcode: "", Retrival_ref_no: "", Specialpayment: "", CardType: "", MaskedCardNumber: "", Txntag: "", EmailID: userDetails.emailId, Phone: "", UserName: userDetails.userName, Userid: "\(userDetails.UserId)", Txn_ref_no: transactionId, Error_code: "", Error_description: "", Status_code: "", Fareid: "\(fareID)", Wallet: false, AuthKey: userDetails.AuthKey) { response, success in
                            if success {
                                if response?.Message == "Ok"{
                                    TicketViewModel.sharedInstance.zigAddTicket(authKey: userDetails.AuthKey, agencyid: userDetails.clientId, TotalAmount: TotalAmount, UserID: userId, TicketList: self.TicketListData, DestinationAddress: destinationAddress1, Token: authKey ?? "", FromAddress: fromaddress1, Message: "Ticket Take in IOS App",transactionID: transactionId, UserName: userDetails.userName) { responses, success in
                                        if success{
                                            if responses?.Message ?? "" == "Ok"{
                                                self.GetTicket { success, Message,statusCode,message  in
                                                    if success{
                                                        completion(true,3103,"ZIGSDK - Ticket Added Successfully")
                                                    }
                                                    else{
                                                        ReferanceViewModel.sharedInstance.addReferance(Amount: AmountCent, Transcationtype: "Wallet", Currency: "USD", Txn_id: transactionId, Correlation_id: "", Bankmessage: "", Txnstatus: "false", Gatewayrespcode: "Get Ticket Failed", Retrival_ref_no: "", Specialpayment: "", CardType: "", MaskedCardNumber: "", Txntag: "", EmailID: userDetails.emailId, Phone: "", UserName: userDetails.userName, Userid: "\(userDetails.UserId)", Txn_ref_no: transactionId, Error_code: "", Error_description: "", Status_code: "", Fareid: "\(fareID)", Wallet: false, AuthKey: userDetails.AuthKey) { response, success in
                                                            if success{
                                                                if response?.Message == "Ok"{
                                                                    completion(false, 3102,"ZIGSDK - Ticket not generated")
                                                                }
                                                                else{
                                                                    completion(false, 3102,"ZIGSDK - Ticket not generated")
                                                                }
                                                            }
                                                            else{
                                                                completion(false, 3102,"ZIGSDK - Ticket not generated")
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            else{
                                                completion(false, 3102,"ZIGSDK - Ticket not generated")
                                            }
                                        }
                                        else{
                                            ReferanceViewModel.sharedInstance.addReferance(Amount: AmountCent, Transcationtype: "Free", Currency: "USD", Txn_id: transactionId, Correlation_id: "", Bankmessage: "", Txnstatus: "false", Gatewayrespcode: "Add Ticket Failed", Retrival_ref_no: "", Specialpayment: "", CardType: "", MaskedCardNumber: "", Txntag: "", EmailID: userDetails.emailId, Phone: "", UserName: userDetails.userName, Userid: "\(userDetails.UserId)", Txn_ref_no: transactionId, Error_code: "", Error_description: "", Status_code: "", Fareid: "\(fareID)", Wallet: false, AuthKey: userDetails.AuthKey) { response, success in
                                                if success{
                                                    if response?.Message == "Ok"{
                                                        completion(false, 3102,"ZIGSDK - Ticket not generated")
                                                    }
                                                    else{
                                                        completion(false, 3102,"ZIGSDK - Ticket not generated")
                                                    }
                                                }
                                                else{
                                                    completion(false, 3102,"ZIGSDK - Ticket not generated")
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                                else{
                                    completion(false, 3102,"ZIGSDK - Ticket not generated")
                                }
                            }
                            else{
                                completion(false, 3102,"ZIGSDK - Ticket not generated")
                            }
                        }
                    }
                }
                else{
                    completion(false, 3101,"ZIGSDK - Invalid FareList")
                }
            }
            else{
                completion(false, 3103,"ZIGSDK - Invalid Authentication or userID")
            }
        }
        else{
            completion(false, 2001,"ZIGSDK - No internet Connection")
        }
    }
    func GetTicket(completion: @escaping (Bool, [[String: Any]],Int,String) -> Void) {
        let userId = userDetails.UserId
        userDetails.UserId = UserDefaults.standard.integer(forKey: "userId")
        userDetails.userName = UserDefaults.standard.string(forKey: "UserName") ?? ""
        userDetails.emailId = UserDefaults.standard.string(forKey: "UserEmailID") ?? ""
        if isReachable(){
            if userDetails.UserId != 0 {
                TicketViewModel.sharedInstance.ZigGetTicket(userId: userId, agencyId: userDetails.clientId) { response, success, data  in
                    if success {
                        do {
                            if response?.Message ?? "" == "Ok" {
                                self.DeleteRealm(agencyId: userDetails.clientId) { success, message in
                                    if success && message == "Realm Deleteed Successfully" {
                                        let ticketDetails = response?.Tickets ?? []
                                        
                                        var ticketsArray: [[String: Any]] = []
                                        
                                        for ticket in ticketDetails {
                                            
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
                                                    let AgencyId = Int(subsetData?.AgencyId ?? 0)
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
                                                        "TicketStatus": TicketStatus,
                                                        "statusCode": 3201,
                                                        "message": "OK"
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
                                                        completion(false,[[:]],3202,"ZIGSDK - Failed to get ticket")
                                                        return
                                                    }
                                                    break
                                                }
                                            } else {
                                                // If no subsets found, complete with empty data
                                                completion(false, [[:]],3203,"ZIGSDK - Ticket list Not Found")
                                                return
                                            }
                                        }
                                        if let responseData = data {
                                            do {
                                                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                                                   let routes = json["Tickets"] as? [[String: Any]] {
                                                    completion(true, routes,3201,"OK")
                                                } else {
                                                    completion(false, [[:]],3202,"ZIGSDK - Failed to get ticket")
                                                }
                                            } catch {
                                                completion(false, [[:]],3202,"ZIGSDK - Failed to get ticket")
                                            }
                                        }
                                        // If processing is successful, call completion with ticketsArray
//                                        completion(true, ticketsArray)
                                    } else {
                                        completion(false, [[:]],3202,"ZIGSDK - Failed to get ticket")
                                    }
                                }
                            } else {
                                completion(false, [[:]],3202,"ZIGSDK - Failed to get ticket")
                            }
                        } catch {
                            completion(false, [[:]],3202,"ZIGSDK - Failed to get ticket")
                        }
                    } else {
                        completion(false, [[:]],3202,"ZIGSDK - Failed to get ticket")
                    }
                }
            }
            else{
                completion(false, [[:]],3204,"ZIGSDK - Invalid Authentication or userID")
            }
        }
        else{
            completion(false, [[:]],2001,"ZIGSDK - No internet Connection")
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
    func ActivateTicket(ticketId: Int, completion: @escaping (Bool, [[String : Any]],Int,String) -> Void) {
        userDetails.UserId = UserDefaults.standard.integer(forKey: "userId")
        userDetails.userName = UserDefaults.standard.string(forKey: "UserName") ?? ""
        userDetails.emailId = UserDefaults.standard.string(forKey: "UserEmailID") ?? ""
        if isReachable(){
            let userId = userDetails.UserId
            if userId != 0 {
                TicketViewModel.sharedInstance.ZigActivate(TicketId: ticketId, userId: userId) { response, success in
                    if success{
                        if response?.Message == "Ok"{
                            self.GetTicket { success, responsedata,statusCode,message  in
                                if success{
                                    completion(true, responsedata,statusCode,message)
                                }
                                else{
                                    completion(false,responsedata,statusCode,message)
                                }
                            }
                        }
                        else{
                            completion(false,[[:]],3303,"ZIGSDK - \(response?.Message ?? "")")
                        }
                    }
                    else{
                        completion(false,[[:]],3302,"Issue on Ticket Activation")
                    }
                }
            }
            else
            {
                completion(false,[[:]],3304,"ZIGSDK - Invalid Authentication or userID")
            }
        }
        else{
            completion(false,[[:]],2001,"No internet Connection")
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

