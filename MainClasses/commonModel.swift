//
//  commonModel.swift
//  ZIGSDK
//
//  Created by Ashok on 20/11/24.
//

import Foundation
import UIKit
struct paymentMethod {
    static var liveKey = ""
    static var sandboxKey = ""
    static var paymentMode = false
    static var paymentmethod = false
}
class LoaderUtility {
    static let shared = LoaderUtility()
    private var activityIndicator: UIActivityIndicatorView?

    private init() {}

    func showLoader(on view: UIView) {
        DispatchQueue.main.async {
            if self.activityIndicator == nil {
                self.activityIndicator = UIActivityIndicatorView(style: .medium)
            }

            guard let activityIndicator = self.activityIndicator else { return }

            activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
            activityIndicator.color = .black
            activityIndicator.frame = view.bounds
            activityIndicator.center = view.center
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
            self.activityIndicator = nil
        }
    }
    func generateRandom17DigitNumber() -> String {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let randomNumber = Int.random(in: 0...999999)
        let uniqueID = (timestamp * 1000000 + randomNumber) % 1000000000000000
        return "9" + String(uniqueID)
    }
}

