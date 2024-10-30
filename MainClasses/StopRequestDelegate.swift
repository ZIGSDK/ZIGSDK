//
//  StopRequestDelegate.swift
//  SwiftFramework
//
//  Created by Ashok on 21/10/24.
//

import Foundation
import UIKit
public protocol StopRequestDelegate {
    func StopRequest(title: String, subtitle: String, backroundColor: String, message: String,imgURL : String,titleTextColor: String,subtitleTextColor: String, completion: @escaping (Bool, String?) -> Void)
}

