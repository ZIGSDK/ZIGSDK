//
//  TripPlannerDelegate.swift
//  ZIGSDK
//
//  Created by Ashok on 25/11/24.
//

import Foundation

public enum vehicleMode {
    case driving
    case walking
    case bus
}
public enum RoutePreferance {
    case leastWalking
    case bestRoute
    case fewestTransfer
}
public enum Time {
    case departNow
    case departAt
    case arriveAt
}
    
protocol TripPlannerDelegate {
    func zigTripPlanner(
        sourceLat: Double,
        sourceLong: Double,
        destinationLat: Double,
        destinationLong: Double,
        sourceAddress: String,
        destinationAddress: String,
        currentTimeType: Time,
        vehicleMode: vehicleMode,
        routePreference: RoutePreferance,
        apiKey: String,dateTime: String,completion: @escaping (Bool, [[String: Any]]) -> Void)
}
