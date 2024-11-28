//
//  commonModel.swift
//  ZIGSDK
//
//  Created by Ashok on 20/11/24.
//

import Foundation
import UIKit
import CryptoKit
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
    
    func generateAndStoreSymmetricKey() -> SymmetricKey {
        let key = SymmetricKey(size: .bits256)
        let keyData = key.withUnsafeBytes { Data(Array($0)) }
        UserDefaults.standard.set(keyData.base64EncodedString(), forKey: "encryptionKey")
        return key
    }

    func retrieveOrGenerateSymmetricKey() -> SymmetricKey {
        if let keyBase64 = UserDefaults.standard.string(forKey: "encryptionKey"),
           let keyData = Data(base64Encoded: keyBase64) {
            return SymmetricKey(data: keyData)
        }
        let newKey = SymmetricKey(size: .bits256)
        let keyData = newKey.withUnsafeBytes { Data(Array($0)) }
        UserDefaults.standard.set(keyData.base64EncodedString(), forKey: "encryptionKey")
        return newKey
    }

    
    func encrypt(data: Data, key: SymmetricKey) -> Data? {
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined
        } catch {
         //   print("Encryption failed: \(error)")
            return nil
        }
    }

    func decrypt(data: Data, key: SymmetricKey) -> Data? {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            return try AES.GCM.open(sealedBox, using: key)
        } catch {
         //   print("Decryption failed: \(error)")
            return nil
        }
    }
    
    func saveToUserDefaults(dictionary: [String: Any], forKey userDefaultsKey: String) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let key = retrieveOrGenerateSymmetricKey()
            guard let encryptedData = encrypt(data: jsonData, key: key) else {
                print("Encryption failed.")
                return
            }
            let base64String = encryptedData.base64EncodedString()
        //    print("Cardknox integration------->", base64String)
            CustomUserDefaults.shared.set(base64String, forKey: userDefaultsKey)
        } catch {
          //  print("Error encoding dictionary: \(error)")
        }
    }
    
    func retrieveSavedCardDetails(forKey userDefaultsKey: String) -> [String: Any]? {
        guard let base64String = CustomUserDefaults.shared.object(forKey: userDefaultsKey) as? String,
              let encryptedData = Data(base64Encoded: base64String) else {
          //  print("Failed to retrieve data from UserDefaults.")
            return nil
        }
        let key = retrieveOrGenerateSymmetricKey()
        guard let decryptedData = decrypt(data: encryptedData, key: key) else {
           // print("Decryption failed.")
            return nil
        }
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: decryptedData, options: []) as? [String: Any] {
                return jsonObject
            }
        } catch {
          //  print("Error decoding data to dictionary: \(error)")
        }
        return nil
    }

}

