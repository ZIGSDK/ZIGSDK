//
//  ReferanceViewModel.swift
//  ZIGSDK
//
//  Created by Ashok on 20/11/24.
//

import Foundation
class ReferanceViewModel: NSObject{
    static let sharedInstance: ReferanceViewModel = {
        let instance = ReferanceViewModel()
        return instance
    }()
    func addReferance(Amount: Int, Transcationtype: String, Currency: String, Txn_id: String, Correlation_id: String,Bankmessage: String,Txnstatus: String, Gatewayrespcode: String, Retrival_ref_no: String, Specialpayment: String,CardType: String,MaskedCardNumber:String,Txntag: String,EmailID:String,Phone:String,UserName:String,Userid:String,Txn_ref_no:String,Error_code:String,Error_description:String,Status_code:String,Fareid: String, Wallet:Bool,AuthKey: String,completion: @escaping (_ response: referanceResponse?, _ success: Bool) -> Void) {
        guard let url = URL(string: "\(apiBaseUrl.baseURL)Payment/Addreference") else {
            completion(nil, false)
            return
        }
        let parameter:[String:Any] = [
            "Amount": Amount,
            "Transcationtype": Transcationtype,
            "Currency": Currency,
            "Txn_id": Txn_id,
            "Correlation_id": Correlation_id,
            "Bankmessage": Bankmessage,
            "Txnstatus": Txnstatus,
            "Gatewayrespcode": Gatewayrespcode,
            "Retrival_ref_no": Retrival_ref_no,
            "Bank_resp_code": "",
            "Validation_status": "true",
            "Gateway_message": "Approved",
            "Method": "",
            "Specialpayment": Specialpayment,
            "CardType": CardType,
            "MaskedCardNumber": MaskedCardNumber,
            "Txntag": Txntag,
            "EmailID": EmailID,
            "Phone": Phone,
            "UserName": UserName,
            "Misc": "",
            "Userid": Userid,
            "Cvv2": "",
            "Avs": "",
            "Txn_ref_no": Txn_ref_no,
            "Error_code": Error_code,
            "Error_description": Error_description,
            "Status_code": Status_code,
            "Fareid": Fareid,
            "Wallet": Wallet,
            "AuthKey": AuthKey
        ]
      //  print("Add-Referance----->",parameter)
     //   print("Add-Referance----->",url)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameter, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil, let data = data else {
                    completion(nil, false)
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(referanceResponse.self, from: data)
                    completion(decodedResponse, true)
                } catch {
                    completion(nil, false)
                }
            }
            task.resume()
        } catch {
            completion(nil, false)
        }
    }
}
