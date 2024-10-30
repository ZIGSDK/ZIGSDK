//
//  SOSRequestDelegate.swift
//  SwiftFramework
//
//  Created by Ashok on 21/10/24.
//

import Foundation
import UIKit
public protocol SosRequestDelegate {
    func SosRequest(title: String, subtitle: String,backroundColor: String,textColor : String,message : String,imgURL : String, completion: @escaping (Bool, String?) -> Void)
}
