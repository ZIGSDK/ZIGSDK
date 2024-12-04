//
//  TripPlannerViewModel.swift
//  ZIGSDK
//
//  Created by Ashok on 25/11/24.
//

import Foundation
class TripPlannerViewModel: NSObject{
    static let sharedInstance: TripPlannerViewModel = {
        let instance = TripPlannerViewModel()
        return instance
    }()
    func tripPlannerViewModel(SourceLat: Double,SourceLong: Double,DestinationLat: Double,DestinationLong: Double,SourceAddress: String,DestinationAddress: String,CurrentTimeType: String,vehicleMode: String,RoutePreferance: String,ClientId: Int,ApiKey: String,DateTime:String,completion : @escaping (_ response: Data?, _ success: Bool) -> Void){
        guard let url = URL(string: "\(apiBaseUrl.baseURL)sdk/Trips/Directions") else {
            completion(nil, false)
            return
        }
        let parameter : [String:Any] = [
            "SourceLat": SourceLat,
            "SourceLong": SourceLong,
            "DestinationLat": DestinationLat,
            "DestinationLong": DestinationLong,
            "SourceAddress": SourceAddress,
            "DestinationAddress": DestinationAddress,
            "CurrentTimeType": CurrentTimeType,
            "CurrentTime": DateTime,
            "VechicalMode": vehicleMode,
            "RoutePreferance": RoutePreferance,
            "ClientId": ClientId,
            "ApiKey": ApiKey,
            "MobileType": "iOS"
        ]
//        print(parameter)
//        print(url)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameter, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil, false)
                    return
                }
                
                completion(data, true)
            }
            task.resume()
        } catch {
            print("Serialization Error: \(error.localizedDescription)")
            completion(nil, false)
        }
    }
    
}
