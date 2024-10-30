//
//  BuyTicketClass.swift
//  ZIGSDK
//
//  Created by Ashok on 23/10/24.
//

import Foundation
import UIKit

class BuyTicketMethod : BuyTicketDelegate {
    func buyTicket(agencyId: Int,userName: String, userId: Int,completion:@escaping(Bool,String) -> Void) {
        TicketMethod.sharedInstance.buyTicket(agencyId: agencyId) { response, success in
            if success {
                BuyTicketViewController.productData = response
                
                let storyboard = UIStoryboard(name: "BuyTicket", bundle: Bundle(for: NeedPermisson.self))
                let addWalletScreen = storyboard.instantiateViewController(withIdentifier: "BuyTicketViewController") as! BuyTicketViewController
                guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
                    return
                }
                addWalletScreen.successHandler = { success, message in
                    completion(success, "")
                }
                
                addWalletScreen.failureHandler = {  success, message in
                    completion(success, "message")
                }
                addWalletScreen.modalPresentationStyle = .fullScreen
                rootViewController.present(addWalletScreen, animated: true, completion: nil)
            }
            else
            {
                
            }
        }
    }
}
