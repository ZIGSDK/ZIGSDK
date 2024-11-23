//
//  TransactionViewModel.swift
//  ZIGSDK
//
//  Created by Ashok on 21/11/24.
//

import Foundation
class TransactionViewModel: NSObject{
    static let sharedInstance: TransactionViewModel = {
        let instance = TransactionViewModel()
        return instance
    }()
    
    func getTransAction(userId: Int, clientId: Int,completion: @escaping (_ response: TranactionModel?, _ success: Bool) -> Void) {
        let urlString = "\(apiBaseUrl.baseURL)api/Wallet_Sdk/Zigsmartv3/api/Wallet/GetWalletTransactions?userId=\(userId)&clientId=\(clientId)"
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
                let json = try JSONDecoder().decode(TranactionModel.self, from: data)
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
