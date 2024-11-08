//
//  UserInfoClass.swift
//  ZIGSDK
//
//  Created by Ashok on 24/10/24.
//

import Foundation

class userInfoMethod : GetUserInfoDelegate {
    func UserInfo(authKey: String, userId: Int, userName: String, EmailId: String, completion: @escaping (Bool, String) -> Void) {
        if isReachable(){
            SDKViewModel.sharedInstance.configApi(authKey: authKey) { response, success in
                if success{
                    if response?.message != "Invalid Token"{
                        userDetails.clientId = response?.clientId ?? 0
                        userDetails.AuthKey = authKey ?? ""
                        UserMethod.sharedInstance.AddUser(clientId: response?.clientId ?? 0 , userName: userName, userId: userId, emailId: EmailId) { responsevalue, success in
                            if success{
                                if responsevalue?.Message == "Session added successfully"{
                                    UserDefaults.standard.setValue(authKey, forKey: "AuthKey")
                                    UserDefaults.standard.setValue(userId, forKey: "userId")
                                    UserDefaults.standard.set(userName, forKey: "UserName")
                                    UserDefaults.standard.set(EmailId, forKey: "UserEmailID")
                                    
                                    userDetails.UserId = userId
                                    userDetails.AuthKey = authKey
                                    userDetails.emailId = EmailId
                                    userDetails.userName = userName
                                    completion(true,"ZIGSDk - User added Successfully")
                                }
                                else{
                                    userDetails.UserId = UserDefaults.standard.integer(forKey: "userId")
                                    userDetails.userName = UserDefaults.standard.string(forKey: "UserName") ?? ""
                                    userDetails.emailId = UserDefaults.standard.string(forKey: "UserEmailID") ?? ""
                                    completion(false,"ZIGSDK - \(responsevalue?.Message ?? "")")
                                }
                            }
                            else{
                                completion(false,"ZIGSDk - Unable to add user")
                            }
                        }
                    }
                    else{
                        completion(false,"ZIGSDK - Invalid Authentication key")
                    }
                }
                else{
                    completion(false,"ZIGSDK - Invalid Authentication key")
                }
            }
        }
        else{
            completion(false,"ZIGSDK - No Internet connection")
        }
    }
}
