//
//  ApiList.swift
//  SwiftFramework
//
//  Created by apple on 29/03/24.
//

import Foundation
import Alamofire
class Api: NSObject {
    static let sharedInstance: Api = {
        let instance = Api()
        return instance
    }()
    func TicketLog(ticketID: String,
                   Name: String,
                   typeValidation: String,
                   ibeaconStatus: String,
                   sdkVersion: String) {
        guard let url = URL(string: "https://docs.google.com/forms/u/1/d/e/1FAIpQLSfJ3uVTV87NIOFggqYIZH-o-bQ_5Xr0D7geEtv8kYfgBpYL4g/formResponse") else {
            return
        }
        let parameters: [String: String] = [
            "entry.1929799608": ticketID,
            "entry.1947291673": Name,
            "entry.1992346399": typeValidation,
            "entry.171888070": ibeaconStatus,
            "entry.1862799069": sdkVersion
        ]
        do {
            let formData = parameters
                .map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
                .data(using: .utf8)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = formData
            
            let task = URLSession.shared.dataTask(with: request) { _, _, error in
                guard error == nil else {
                    return
                }
            }
            task.resume()
        } catch {
            // Handle any unexpected errors
        }
    }
    func MqttLog(Macddress: String,
                 MQTTMessage: String,
                 SuccessFailure: String,
                 sdkVersion: String) {
        
        guard let url = URL(string: "https://docs.google.com/forms/u/0/d/e/1FAIpQLSc1CKw4o3rlqFIGBVJ1--IpCUWE7siI1ZHLtzOjzvUMIhM1kQ/formResponse") else {
            return
        }
        
        let parameters: [String: String] = [
            "entry.1896005212": Macddress,
            "entry.1031379999": MQTTMessage,
            "entry.1716540237": SuccessFailure,
            "entry.1762653410": sdkVersion
        ]
        
        do {
            let formData = parameters
                .map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
                .data(using: .utf8)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = formData
            
            let task = URLSession.shared.dataTask(with: request) { _, _, error in
                guard error == nil else {
                    return
                }
            }
            
            task.resume()
        } catch {
            // Handle any unexpected errors
        }
    }
}
