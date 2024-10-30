//
//  BuyTicketDelegate.swift
//  ZIGSDK
//
//  Created by Ashok on 23/10/24.
//

import Foundation
import UIKit
protocol BuyTicketDelegate {
    func buyTicket(agencyId: Int,userName: String,userId: Int,completion:@escaping(Bool,String) -> Void)
}
