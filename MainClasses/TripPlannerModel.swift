//
//  TripPlannerModel.swift
//  ZIGSDK
//
//  Created by Ashok on 25/11/24.
//

import Foundation
struct tripResponse : Codable{
    var message : String?
    var remainingLimitCount : Int?
    var limitStatus : Bool
    var routes : [routes]?
    var status : String?
}
struct routes : Codable{
    var bounds : bounds?
    var legs : [legs]?
//    var overview_polyline : polyline?
//    var summary : String?
//    var mode : String?
}
struct legs : Codable{
    var arrival_time : arrival_time?
    var departure_time : arrival_time?
    var distance : distance?
    var duration : distance?
    var start_address : String?
    var end_address : String?
    var start_location : latlng?
    var end_location : latlng?
  //  var steps : [steps?]
}
struct steps : Codable{
    var distance : distance?
    var duration : distance?
    var start_location : latlng?
    var end_location : latlng?
    var html_instructions : String?
    var polyline : polyline
    var steps : [walkStep?]
    var transit_details : String?
    var travel_mode : String?
}
struct walkStep : Codable{
    var distance : distance?
    var duration : distance?
    var start_location : latlng?
    var end_location : latlng?
    var html_instructions : String?
    var polyline : polyline
    var steps : String?
    var transit_details : String?
    var travel_mode : String?
}
struct polyline : Codable{
    var points : String?
}
struct distance: Codable{
    var text : String?
    var value : Int?
}
struct arrival_time : Codable{
    var text : String?
    var time_zone : String?
    var value : Int?
}
struct bounds : Codable{
    var northeast : latlng?
    var southwest : latlng?
}
struct latlng: Codable{
    var lat : Double?
    var lng : Double?
}
