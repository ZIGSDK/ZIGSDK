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
        guard let url = URL(string: urlString) else {
            completion(nil, false)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
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
                let json = try JSONDecoder().decode(BuyTicket.self, from: data)
                DispatchQueue.main.async {
                    completion(json, true)
                }
            } catch _ {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
            }
        }
        
        // Start the task
        task.resume()
    }
}
