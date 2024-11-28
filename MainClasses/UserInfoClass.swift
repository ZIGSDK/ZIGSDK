//
//  UserInfoClass.swift
//  ZIGSDK
//
//  Created by Ashok on 24/10/24.
//

import Foundation

class userInfoMethod : GetUserInfoDelegate {
    func UserInfo(authKey: String, userId: Int, userName: String, EmailId: String, completion: @escaping (Bool, [String : Any]) -> Void) {
        if isReachable(){
            SDKViewModel.sharedInstance.configApi(authKey: authKey) { response, success in
                if success{
                    if response?.message != "Invalid Token"{
                        userDetails.clientId = response?.clientId ?? 0
                        userDetails.AuthKey = authKey
                        UserMethod.sharedInstance.AddUser(AuthKey: authKey, clientId: response?.clientId ?? 0 , userName: userName, userId: userId, emailId: EmailId) { responsevalue, success in
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
                                    completion(true,["statusCode" : 6001,
                                                     "message": "ZIGSDk - User added Successfully"])
                                }
                                else{
                                    UserDefaults.standard.setValue(authKey, forKey: "AuthKey")
                                    UserDefaults.standard.setValue(userId, forKey: "userId")
                                    UserDefaults.standard.set(userName, forKey: "UserName")
                                    UserDefaults.standard.set(EmailId, forKey: "UserEmailID")
                                    
                                    userDetails.UserId = UserDefaults.standard.integer(forKey: "userId")
                                    userDetails.userName = UserDefaults.standard.string(forKey: "UserName") ?? ""
                                    userDetails.emailId = UserDefaults.standard.string(forKey: "UserEmailID") ?? ""
                                    completion(false,["statusCode" : 6002,
                                                     "message": "ZIGSDK - \(responsevalue?.Message ?? "")"])
                                }
                            }
                            else{
                                completion(false,["statusCode" : 6003,
                                                 "message": "ZIGSDk - Unable to add user"])
                            }
                        }
                        UserMethod.sharedInstance.getuserEmail(emailId: EmailId, agencyID: userDetails.clientId) { response, success in
                            if success{
                                
                            }
                            else{
                                
                            }
                        }
                    }
                    else{
                        completion(false,["statusCode" : 6004,
                                         "message": "ZIGSDK - Invalid Authentication key"])
                    }
                }
                else{
                    completion(false,["statusCode" : 6004,
                                     "message": "ZIGSDK - Invalid Authentication key"])
                }
            }
        }
        else{
            completion(false,["statusCode" : 2001,
                             "message": "ZIGSDK - No Internet connection"])
        }
    }
}
