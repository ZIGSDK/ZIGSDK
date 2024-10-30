//
//  BeaconRangingDeleagte.swift
//  SwiftFramework
//
//  Created by Ashok on 21/10/24.
//

import Foundation
import UIKit
public protocol bearonRangingDelegate {
    func ZIGSDKInit(authKey : String,enableLog : Bool,completion: @escaping (Bool, String?) -> Void)
}
