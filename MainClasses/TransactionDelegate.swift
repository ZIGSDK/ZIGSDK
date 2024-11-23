//
//  TransactionDelegate.swift
//  ZIGSDK
//
//  Created by Ashok on 21/11/24.
//

import Foundation
public protocol TransactionDelegate {
    func zigTransaction(userId: Int,completion: @escaping (Bool, [[String: Any]]) -> Void)
}

