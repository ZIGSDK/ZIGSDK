//
//  TicketViewModel.swift
//  ZIGSDK
//
//  Created by Ashok on 24/10/24.
//

import Foundation

class TicketViewModel : NSObject{
    
    static let sharedInstance: TicketViewModel = {
        let instance = TicketViewModel()
        return instance
    }()
    
    func zigAddTicket(agencyid: Int, TotalAmount: Double, UserID: Int, TicketList: [TicketList], DestinationAddress: String, Token: String, FromAddress: String, Message: String, transactionID: String, UserName: String, completion: @escaping (_ response: AddTicket?, _ success: Bool) -> Void) {
        let parametersValue: [String: Any] = [
            "Agencyid": agencyid,
            "TotalAmount": TotalAmount,
            "UserID": UserID,
            "Username": UserName,
            "TransactionId": transactionID,
            "Tickets": TicketList.map { ticket in
                return [
                    "FromAddress": ticket.FromAddress,
                    "DestinationAddress": ticket.DestinationAddress,
                    "Amount": ticket.Amount,
                    "Fareid": ticket.Fareid,
                    "RouteId": ticket.RouteId
                ]
            },
            "DestinationAddress": DestinationAddress,
            "Token": Token,
            "FromAddress": FromAddress,
            "Message": Message
        ]
        print("ZIG-SDK-ADD-Request====>",parametersValue)
        guard let url = URL(string: "\(apiBaseUrl.baseURL)Zigsmartandroid/api/Tickets/Add") else {
            completion(nil, false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parametersValue, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            completion(nil, false)
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            do {
                let jsonResponse = try JSONDecoder().decode(AddTicket.self, from: data)
                DispatchQueue.main.async {
                    completion(jsonResponse, true)
                }
            } catch {
                print("Error decoding JSON response: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, false)
                }
            }
        }
        task.resume()
    }
    
    func ZigGetTicket(userId:Int,agencyId:Int,completion:@escaping(_ response: GetTicket?, _ success: Bool) -> Void){
        let urlString = "\(apiBaseUrl.baseURL)Zigsmartandroid/api/Ticket/GetTicketsNEW?UserID=\(userId)&agencyId=\(agencyId)&count=0"
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            completion(nil, false)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            
            guard let data = data else {
                print("No data received.")
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            
            do {
                let json = try JSONDecoder().decode(GetTicket.self, from: data)
                DispatchQueue.main.async {
                    completion(json, true)
                }
            } catch let decodingError {
                print("Decoding Error: \(decodingError.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, false)
                }
            }
        }
        task.resume()
    }
    
    func ZigActivate(TicketId:Int,userId: Int,completion:@escaping(_ response: ActivateTicket?, _ success: Bool) -> Void){
        let parametersValue: [String: Any] = [
            "TicketId" :TicketId,
            "UserID" : userId
        ]
        print("ZIG-SDK-Activate=====>",parametersValue)
        print("ZIG-SDK-Activate=====> \(apiBaseUrl.baseURL)Zigsmartandroid/api/Tickets/TicketActivate")
        guard let url = URL(string: "\(apiBaseUrl.baseURL)Zigsmartandroid/api/Tickets/TicketActivate") else {
            completion(nil, false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parametersValue, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            completion(nil, false)
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            do {
                let jsonResponse = try JSONDecoder().decode(ActivateTicket.self, from: data)
                DispatchQueue.main.async {
                    completion(jsonResponse, true)
                }
            } catch {
                print("Error decoding JSON response: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, false)
                }
            }
        }
        task.resume()
    }
    func ValidateTicket(ConfigList:[InOutConfig],completion:@escaping (_ response: ActivateTicket?, _ success: Bool) -> Void){
        let parametersValue: [String: Any] = ["list": ConfigList.map { config in
            [
                "latitude": config.latitude,
                "longitude": config.longitude,
                "IsBibo": config.isBibo,
                "beaconid": config.beaconId,
                "ClientId": config.clientId,
                "routeid": config.routeId,
                "tripid": config.tripId,
                "date": config.date,
                "ticketid": config.ticketId,
                "message": config.message,
                "isDriver": config.isDriver,
                "userID": config.userId,
                "accesstoken": config.accessToken,
                "Username": config.Username,
                "EmailID": config.EmailID
            ]
        }]
        print("ZIG-SDK-Validation---->",parametersValue)
        guard let url = URL(string: "\(apiBaseUrl.baseURL)api/Beacon/Add?autovalidate=false") else {
            completion(nil, false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parametersValue, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            completion(nil, false)
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            do {
                let jsonResponse = try JSONDecoder().decode(ActivateTicket.self, from: data)
                DispatchQueue.main.async {
                    completion(jsonResponse, true)
                }
            } catch {
                print("Error decoding JSON response: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, false)
                }
            }
        }
        task.resume()
    }
}
