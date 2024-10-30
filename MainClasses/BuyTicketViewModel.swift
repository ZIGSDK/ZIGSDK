//
//  BuyTicketViewModel.swift
//  ZIGSDK
//
//  Created by Ashok on 23/10/24.
//

import Foundation

class TicketMethod: NSObject{
    static let sharedInstance: TicketMethod = {
        let instance = TicketMethod()
        return instance
    }()
    
    func buyTicket(agencyId: Int, completion: @escaping (_ response: BuyTicket?, _ success: Bool) -> Void) {
        let urlString = "\(apiBaseUrl.baseURL)api/v2/Getfares?agencyId=\(agencyId)"
        print("BuyTicketURL====>",urlString)
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            completion(nil, false)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            
            guard let data = data else {
                print("No data received.")
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            
            do {
                let json = try JSONDecoder().decode(BuyTicket.self, from: data)
                DispatchQueue.main.async {
                    completion(json, true)
                }
            } catch let decodingError {
                print("Decoding Error: \(decodingError.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, false)
                }
            }
        }
        
        // Start the task
        task.resume()
    }
}
