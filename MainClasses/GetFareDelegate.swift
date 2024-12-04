//
//  GetFareDelegate.swift
//  ZIGSDK
//
//  Created by Ashok on 21/11/24.
//

import Foundation
public protocol GetFareDelegate {
    func getFare(authkey: String, completion: @escaping(Bool,[[String:Any]],Int,String)->Void)
}
