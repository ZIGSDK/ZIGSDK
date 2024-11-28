//
//  PaymentViewModel.swift
//  ZIGSDK
//
//  Created by Ashok on 20/11/24.
//


import Foundation
class PaymentViewModel: NSObject{
    static let sharedInstance: PaymentViewModel = {
        let instance = PaymentViewModel()
        return instance
    }()
    
    func paymentGateWay(cardNumber: String, expriedNumber: String, cvv: String, amount : String, streetAddress: String, zipCode : String,appName: String,userName: String,holderName: String,completion :  @escaping (_ response: paymentGateway?, _ success: Bool) -> Void) {
        var key = ""
        if paymentMethod.paymentMode{
            key = paymentMethod.liveKey
        }
        else{
            key = paymentMethod.sandboxKey
        }
        
        guard let url = URL(string: "\(apiBaseUrl.paymentUrl)") else {
            completion(nil, false)
            return
        }
        let parameter:[String:Any] = [
            "xCardNum": cardNumber,
            "xExp": expriedNumber,
            "xKey": key,
            "xVersion": "5.0.0",
            "xSoftwareName": "\(appName) - Wallet",
            "xSoftwareVersion": "1.0.1",
            "xCommand": "cc:sale",
            "xAmount": amount,
            "xCustom01": holderName,
            "xCVV": cvv,
            "xStreet": streetAddress,
            "xZip": zipCode,
            "xName": holderName,
            "xDescription":"Ticket Take in IOS App",
            "xAllowDuplicate":true,
            "xDBA": appName
            
        ]
      //  print("PaymentGateway----->",parameter)
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
                    let decodedResponse = try JSONDecoder().decode(paymentGateway.self, from: data)
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
    func paymentGateWayToken(appName: String,amount : String,token: String,cvvNumber:String,completion :  @escaping (_ response: paymentGateway?, _ success: Bool) -> Void) {
        var key = ""
        if paymentMethod.paymentMode{
            key = paymentMethod.liveKey
        }
        else{
            key = paymentMethod.sandboxKey
        }
        guard let url = URL(string: "\(apiBaseUrl.paymentUrl)") else {
            completion(nil, false)
            return
        }
        let parameter:[String:Any] = [
            "xKey": key,
            "xVersion": "5.0.0",
            "xSoftwareName": "\(appName) - Wallet",
            "xSoftwareVersion": "1.0.1",
            "xCommand": "cc:sale",
            "xAmount": amount,
            "xToken": token,
            "xCVV": cvvNumber,
            "xAllowDuplicate":true,
            "xDescription":"Ticket Take in IOS App",
            "xDBA": appName
        ]
       // print("Paymentgateway----->",parameter)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameter, options: [])
            var request = URLRequest(url: url)
         //   print("Paymentgateway----->",request)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil, let data = data else {
                    completion(nil, false)
                    return
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(paymentGateway.self, from: data)
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
