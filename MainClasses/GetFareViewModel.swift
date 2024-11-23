//
//  GetFareViewModel.swift
//  ZIGSDK
//
//  Created by Ashok on 21/11/24.
//

import Foundation
class GetFareViewModel: NSObject{
    static let sharedInstance: GetFareViewModel = {
        let instance = GetFareViewModel()
        return instance
    }()
    func getFare(authKey: String,clientId: Int,completion : @escaping (_ response: getFaredata?, _ success: Bool) -> Void){
        let urlString = "\(apiBaseUrl.baseURL)api/v2/Getfares?agencyId=\(clientId)"
        guard let url = URL(string: urlString) else {
            completion(nil, false)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            
            do {
                let json = try JSONDecoder().decode(getFaredata.self, from: data)
                DispatchQueue.main.async {
                    completion(json, true)
                }
            } catch let decodingError {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
            }
        }
        task.resume()
    }
}
    
