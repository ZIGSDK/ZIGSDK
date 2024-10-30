//
//  UserInfoDelegate.swift
//  ZIGSDK
//
//  Created by Ashok on 24/10/24.
//

import Foundation
import UIKit
protocol GetUserInfoDelegate {
    func UserInfo(authKey: String, userId: Int, userName: String, EmailId: String, completion:@escaping(Bool,String) -> Void)
}
