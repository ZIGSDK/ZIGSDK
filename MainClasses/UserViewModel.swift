//
//  UserViewModel.swift
//  ZIGSDK
//
//  Created by Ashok on 25/10/24.
//

import Foundation
class UserMethod {
    static let sharedInstance: UserMethod = {
        let instance = UserMethod()
        return instance
    }()
    func AddUser(clientId:Int,userName: String,userId: Int,emailId: String,completion:@escaping(_ response: ActivateTicket?, _ success: Bool) -> Void){
        let parametersValue: [String: Any] = [
            "clientId" : clientId,
            "userName" : userName,
            "userId" : userId,
            "emailId" : emailId
        ]
        guard let url = URL(string: "\(apiBaseUrl.baseURL)User/SessionData") else {
            completion(nil, false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parametersValue, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            completion(nil, false)
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            do {
                let jsonResponse = try JSONDecoder().decode(ActivateTicket.self, from: data)
                DispatchQueue.main.async {
                    completion(jsonResponse, true)
                }
            } catch {
                print("Error decoding JSON response: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, false)
                }
            }
        }
        task.resume()
    }
}
