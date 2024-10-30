//
//  UserInfoClass.swift
//  ZIGSDK
//
//  Created by Ashok on 24/10/24.
//

import Foundation

class userInfoMethod : GetUserInfoDelegate {
    func UserInfo(authKey: String, userId: Int, userName: String, EmailId: String, completion: @escaping (Bool, String) -> Void) {
        print("ClientID======>",userDetails.clientId)
        UserMethod.sharedInstance.AddUser(clientId: userDetails.clientId, userName: userName, userId: userId, emailId: EmailId) { response, success in
            if success{
                UserDefaults.standard.setValue(authKey, forKey: "AuthKey")
                UserDefaults.standard.setValue(userId, forKey: "userId")
                UserDefaults.standard.set(userName, forKey: "UserName")
                UserDefaults.standard.set(EmailId, forKey: "UserEmailID")
                userDetails.UserId = userId
                userDetails.AuthKey = authKey
                userDetails.emailId = EmailId
                userDetails.userName = userName
                completion(true,"Added user in our SDK succesfully!")
            }
            else{
                completion(false,"User Not added")
            }
        }
    }
}
