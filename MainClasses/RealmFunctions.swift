//
//  RealmFunctions.swift
//  ZIGSDK
//
//  Created by Ashok on 23/10/24.
//

import Foundation

class RealmMethod {
    static let sharedInstance: RealmMethod = {
        let instance = RealmMethod()
        return instance
    }()
    
    func addTicket(ticketID: Int, passengerName: String, destination: String, price: Double, dateOfJourney: Date?,completion:@escaping(Bool,String) -> Void){
        
    }
}
