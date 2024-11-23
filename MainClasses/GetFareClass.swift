//
//  GetFareClass.swift
//  ZIGSDK
//
//  Created by Ashok on 21/11/24.
//

import Foundation

class GetFareClass : GetFareDelegate{
    func getFare(authkey: String, completion: @escaping(Bool,[[String:Any]])->Void){
        if isReachable(){
            SDKViewModel.sharedInstance.configApi(authKey: authkey) { response, success in
                if success{
                    let clientId = response?.clientId ?? 0
                    GetFareViewModel.sharedInstance.getFare(authKey: authkey, clientId: clientId) { response, success in
                        if response?.Message == "Ok"{
                            if response?.list.count ?? 0 > 0 {
                                if let transactionData = response?.list {
                                    var formattedResponse: [[String: Any]] = []
                                    for fare in transactionData {
                                        print("FareList----->",fare)
                                        let fareDictionary: [String: Any] = [
                                            "FareId": fare.AgencyId as Any,
                                            "FareAmount": fare.FareAmount as Any,
                                            "CategoryId": fare.CategoryId as Any,
                                            "RouteName": fare.RouteName as Any,
                                            "isActive": fare.isActive as Any,
                                            "ValidTill": fare.ValidTill as Any,
                                            "CreatedDate": fare.CreatedDate as Any,
                                            "createdby": fare.createdby as Any,
                                            "LastUpdatedDate": fare.LastUpdatedDate as Any,
                                            "LastUpdatedBy": fare.LastUpdatedBy as Any,
                                            "AgencyId": fare.AgencyId as Any,
                                            "serverdate": fare.serverdate as Any,
                                            "Type": fare.Type as Any,
                                            "ExpiryTime": fare.ExpiryTime as Any,
                                            "ZoneId": fare.ZoneId as Any,
                                            "Farename": fare.Farename as Any,
                                            "MaxCount": fare.MaxCount as Any,
                                            "ProductDescription": fare.ProductDescription as Any,
                                            "ProductMiscDescription": fare.ProductDescription as Any,
                                            "VerificationStatus": fare.VerificationStatus as Any,
                                            "PaymentMode": fare.PaymentMode as Any,
                                            "ProductName": fare.ProductName as Any,
                                            "ProductCost": fare.ProductCost as Any,
                                            "ProductVegCategory": fare.ProductVegCategory as Any,
                                            "ProductImageURL": fare.ProductImageURL as Any,
                                            "Category": fare.Category as Any,
                                            "CategoryImage": fare.CategoryImage as Any,
                                            "BannerImage": fare.BannerImage as Any
                                        ]
                                        formattedResponse.append(fareDictionary)
                                    }
                                    completion(true,formattedResponse)
                                }
                                else{
                                    completion(false,[["Message": "Failed to get fare list"]])
                                }
                            }else{
                                completion(false,[["Message": "Fare List not found"]])
                            }
                        }
                        else{
                            completion(false,[["Message": "\(response?.Message ?? "")"]])
                        }
                    }
                }
                else{
                    completion(false,[["Message": "Failed to Get Fare"]])
                }
            }
        }
        else{
            completion(false,[["Message": "No internet Connection"]])
        }
    }
}
