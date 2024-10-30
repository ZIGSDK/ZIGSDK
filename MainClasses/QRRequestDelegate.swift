//
//  QRRequestDelegate.swift
//  SwiftFramework
//
//  Created by Ashok on 21/10/24.
//

import Foundation
import UIKit
public protocol QRRequestDelegate {
    func QRgeneration(ticketStatus : String,ticketId : String,expiryDate : String,totalCount : String,startColorHex : String,endColorHex : String,textColorHex : String,agencyName: String)
}
