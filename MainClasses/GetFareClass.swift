//
//  GetFareClass.swift
//  ZIGSDK
//
//  Created by Ashok on 21/11/24.
//

import Foundation

class GetFareClass : GetFareDelegate{
    func getFare(authkey: String, completion: @escaping(Bool,[[String:Any]],Int,String)->Void){
        if isReachable(){
            SDKViewModel.sharedInstance.configApi(authKey: authkey) { response, success in
                if success{
                    let clientId = response?.clientId ?? 0
                    GetFareViewModel.sharedInstance.getFare(authKey: authkey, clientId: clientId) { response, success, data  in
                        if response?.Message == "Ok"{
                            if response?.list.count ?? 0 > 0 {
                                if let transactionData = response?.list {
                                    if let responseData = data {
                                        do {
                                            if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                                               let routes = json["list"] as? [[String: Any]] {
                                                completion(true, routes,3002,"OK")
                                            } else {
                                                completion(false, [[:]],3001,"ZIGSDK - Failed to get fare list")
                                            }
                                        } catch {
                                            completion(false, [[:]],3001,"ZIGSDK - Failed to get fare list")
                                        }
                                    }
                                }
                                else{
                                    completion(false, [[:]],3001,"ZIGSDK - Failed to get fare list")
                                }
                            }else{
                                completion(false, [[:]],3001,"ZIGSDK - Failed to get fare list")
                            }
                        }
                        else{
                            completion(false, [[:]],3001,"ZIGSDK - Failed to get fare list")
                        }
                    }
                }
                else{
                    completion(false, [[:]],3001,"ZIGSDK - Failed to get fare list")
                }
            }
        }
        else{
            completion(false, [[:]],2001,"ZIGSDK - No internet Connection")
        }
    }
}
