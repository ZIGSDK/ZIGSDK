//
//  ReceiverDelegate.swift
//  SwiftFramework
//
//  Created by Ashok on 21/10/24.
//

import Foundation
import UIKit
public protocol receiverDelegate {
    func registerForMessages(handler: @escaping ([String: Any]) -> Void)
}
