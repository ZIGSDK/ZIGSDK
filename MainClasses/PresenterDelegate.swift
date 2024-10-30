//
//  PresenterDelegate.swift
//  SwiftFramework
//
//  Created by Ashok on 21/10/24.
//

import Foundation
import UIKit
protocol PresenterDelegate {
   func showAlert(title : String)
   func showAlert(title: String, message: String,buttonName : String, completion: @escaping (Bool) -> Void)
}
