//
//  TicketValidationDelegate.swift
//  SwiftFramework
//
//  Created by Ashok on 21/10/24.
//

import Foundation
import UIKit
public protocol TicketValidationDelegate {
    func addTickets(TotalAmount: Double, TicketDetails: [[String: Any]], completion: @escaping(Bool,String) -> Void)
    func GetTicket(completion: @escaping(Bool,[[String: Any]])->Void)
    func ActivateTicket(ticketId : Int,completion: @escaping(Bool,[[String: Any]]) -> Void)
}
