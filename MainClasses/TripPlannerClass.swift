//
//  TripPlannerClass.swift
//  ZIGSDK
//
//  Created by Ashok on 25/11/24.
//

import Foundation
class tripPlannerClass : TripPlannerDelegate{
    func zigTripPlanner(sourceLat: Double, sourceLong: Double, destinationLat: Double, destinationLong: Double, sourceAddress: String, destinationAddress: String, currentTimeType: Time, vehicleMode: vehicleMode, routePreference: RoutePreferance, apiKey: String,dateTime: String, completion: @escaping (Bool, [[String : Any]]) -> Void) {
        if isReachable(){
            var CurrentTimeType = ""
            var vechicleModeData = ""
            var routePreferanceData = ""
            
            if currentTimeType == .arriveAt {
                CurrentTimeType = "arriveBy"
            }
            else if currentTimeType == .departAt {
                CurrentTimeType = "DepartAt"
            }
            else if currentTimeType == .departNow {
                CurrentTimeType = "DepartNow"
            }
            
            if vehicleMode == .driving {
                vechicleModeData = "driving"
            }
            else if vehicleMode == .bus{
                vechicleModeData = "transit"
            }
            else if vehicleMode == .walking {
                vechicleModeData = "walking"
            }
            
            if routePreference == .bestRoute {
                routePreferanceData = "best route"
            }
            else if routePreference == .fewestTransfer {
                routePreferanceData = "fewest transfers"
            }
            else if routePreference == .leastWalking {
                routePreferanceData = "least walking"
            }
            SDKViewModel.sharedInstance.configApi(authKey: apiKey) { response, success in
                if success{
                    TripPlannerViewModel.sharedInstance.tripPlannerViewModel(SourceLat: sourceLat, SourceLong: sourceLong, DestinationLat: destinationLat, DestinationLong: destinationLong, SourceAddress: sourceAddress, DestinationAddress: destinationAddress, CurrentTimeType: CurrentTimeType, vehicleMode: vechicleModeData, RoutePreferance: routePreferanceData, ClientId: response?.clientId ?? 0, ApiKey: apiKey, DateTime: dateTime) { response, success in
                        if success, let responseData = response {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                                   let routes = json["routes"] as? [[String: Any]] {
                                    completion(true, routes)
                                } else {
                                    completion(false, [["statusCode" : 7001,
                                                        "message": "ZIGSDK - No routes found for the given details."]])
                                }
                            } catch {
                                completion(false, [["statusCode" : 7002,
                                                    "message": "ZIGSDK - Something went wrong. Please check your input and try again."]])
                            }
                        } else {
                            completion(false, [["statusCode" : 7003,
                                                "message": "ZIGSDK - Unable to get the trip details."]])
                        }
                    }
                }
                else{
                    completion(false, [["statusCode" : 7003,
                                        "message": "ZIGSDK - Unable to get the trip details."]])
                }
            }
        }
        else{
            completion(false, [["statusCode" : 2001,
                                "message": "ZIGSDK - No Internet Connection"]])
        }
    }
}
