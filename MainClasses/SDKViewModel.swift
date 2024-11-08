//
//  SDKViewModel.swift
//  SwiftFramework
//
//  Created by apple on 29/03/24.
//

import Foundation
import Alamofire
class SDKViewModel : NSObject{
    
    static let sharedInstance: SDKViewModel = {
        let instance = SDKViewModel()
        return instance
    }()
    func configApi(authKey: String, completion: @escaping (_ response: configData?, _ success: Bool) -> Void) {
        let urlString = "\(apiBaseUrl.baseURL)api/Auth"
        guard let url = URL(string: urlString) else {
            completion(nil, false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: String] = ["authToken": authKey]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch let error {
            completion(nil, false)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }

            // Attempt to decode the response data
            do {
                let json = try JSONDecoder().decode(configData.self, from: data)
                DispatchQueue.main.async {
                    completion(json, true)
                }
            } catch let decodingError {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
            }
        }

        // Start the task
        task.resume()
    }
    func limitchange(count: Int,
                     userid: Int,
                     typeValidate: String,
                     ticketID: String,
                     ValidationMode: Bool,
                     BatteryHealth: String,
                     MobileModel: String,
                     TypeMobile: String,
                     ConfigAPITime: Int,
                     ValidationDistance: Int,
                     ibeaconStatus: String,
                     ConfigForegroundFeet: String,
                     TimeTaken: Int,clientId: Int,UserName: String,
                     completion: @escaping (_ response: validationLimit?, _ success: Bool) -> Void) {
        
        guard let url = URL(string: "\(apiBaseUrl.baseURL)api/validation") else {
            completion(nil, false)
            return
        }
        
        let parameters: [String: Any] = [
            "Client_id": clientId,
            "Validation_count": count,
            "ValidationType": typeValidate,
            "TicketID": ticketID,
            "ValidationMode": ValidationMode,
            "BatteryHealth": BatteryHealth,
            "MobileModel": MobileModel,
            "TypeMobile": TypeMobile,
            "ConfigAPITime": ConfigAPITime,
            "ValidationDistance": ValidationDistance,
            "ibeaconStatus": ibeaconStatus,
            "ConfigForegroundFeet": ConfigForegroundFeet,
            "TimeTaken": TimeTaken,
            "userid": userid,
            "username": UserName
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil, let data = data else {
                    completion(nil, false)
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(validationLimit.self, from: data)
                    completion(decodedResponse, true)
                } catch {
                    completion(nil, false)
                }
            }
            task.resume()
        } catch {
            completion(nil, false)
        }
    }
}
