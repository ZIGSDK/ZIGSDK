//
//  UserDefault.swift
//  ZIGSDK
//
//  Created by Ashok on 21/11/24.
//

import Foundation
public class CustomUserDefaults {
    static let shared = CustomUserDefaults()
    private let userDefaults = UserDefaults.standard
    private init() {}
    public func setValue(_ value: Any?, forKey key: String) {
        userDefaults.setValue(value, forKey: key)
    }
    public func set(_ value: Any?, forKey key: String){
        userDefaults.set(value, forKey: key)
    }
    public func object(forKey key: String) -> Any?{
        return userDefaults.object(forKey: key)
    }
    public func removeObject(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
