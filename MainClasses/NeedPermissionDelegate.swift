//
//  NeedPermissionDelegate.swift
//  SwiftFramework
//
//  Created by Ashok on 21/10/24.
//

import Foundation
import UIKit
public protocol needPermissionDelegate {
    func needPermisson(Title : String, subTitle : String, description : String, noteTitle : String, noteDescription : String, permissionList: [PermissionItem],completion: @escaping (Bool, String?) -> Void)
}
