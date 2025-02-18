//
//  ReduceWalletAmount.swift
//  SwiftFramework
//
//  Created by Ashok on 08/09/24.
//

import UIKit

class ReduceWalletAmount: UIViewController {
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var walletTotalAmount: UILabel!
    @IBOutlet weak var walletDescription: UILabel!
    @IBOutlet weak var walletTitle: UILabel!
    @IBOutlet weak var walletCheckBox: UIButton!
    @IBOutlet weak var walletPaymentView: UIView!
    @IBOutlet weak var totalTitlr: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var PaymentTitle: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    var successHandler: ((Bool, [String: Any]?) -> Void)?
    var failureHandler: ((Bool, [String: Any]?) -> Void)?
    let activityIndicator = UIActivityIndicatorView()
    static var clientId = 0
    static var userId = 0
    static var debitAmount = 0.0
    static var purpose = ""
    static var userName = ""
    static var walletTitle = ""
    static var payTitle = ""
    static var setBrandColour = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    func setUpUI(){
        if isReachable(){
            overrideUserInterfaceStyle = .light
            self.showLoader()
            cancelButton.layer.cornerRadius = 10
            buyButton.layer.cornerRadius = 10
            ReduceWalletAmount.setBrandColour = ReduceWalletAmount.setBrandColour.isEmpty ? "#0A79BE" : ReduceWalletAmount.setBrandColour
            WalletViewModel.sharedInstance.walletBalanceCheck(clientId: MqttValidationData.userid, userId: ReduceWalletAmount.userId) { response, success in
                if success{
                    self.hideLoader()
                    // print("ReduceWalletAmount.debitAmount====>",ReduceWalletAmount.debitAmount)
                    let balanceAmount = String.init(format: "%.2f", response?.walletBalanceAmount ?? 0.0)
                    let walletAmount = String.init(format: "%.2f", ReduceWalletAmount.debitAmount)
                    self.walletTotalAmount.text = "$ \(balanceAmount)"
                    self.totalAmount.text = "$ \(walletAmount)"
                }
                else{
                    self.hideLoader()
                    let jsonObject: [String: Any] = [
                        "statusCode" : 4102,
                        "message" : "\(response?.Message ?? "")"
                    ]
                    self.failureHandler?(success,jsonObject)
                }
            }
            buyButton.backgroundColor = UIColor(hex: ReduceWalletAmount.setBrandColour)
        }
        else{
            let jsonObject: [String: Any] = [
                "statusCode" : 2001,
                "message" : "ZIGSDK - No internet connection)"
            ]
            self.failureHandler?(false,jsonObject)
        }
    }
    @IBAction func buyAction(_ sender: Any) {
        if isReachable(){
            self.showLoader()
            buyButton.isEnabled = false
            WalletViewModel.sharedInstance.walletPaymentMethod(clientName: MqttValidationData.userName, clientId: MqttValidationData.userid, userId: ReduceWalletAmount.userId, userName: ReduceWalletAmount.userName, creditAmount: 0.0, debitAmount: ReduceWalletAmount.debitAmount, purpose: ReduceWalletAmount.purpose, walletBool: false) { response, success in
                if success{
                    self.buyButton.isEnabled = true
                    if response?.WalletEnableStatus ?? false {
                        let balanceAmount = String.init(format: "%.2f", response?.walletBalanceAmount ?? 0.0)
                        let jsonObject: [String: Any] = [
                            "statusCode" : 4101,
                            "message" : "Amount debited from wallet successfully",
                            "userId" : "\(response?.userId ?? 0)",
                            "userName" : "\(response?.userName ?? "")",
                            "BalanceAmount" : "\(balanceAmount)"
                        ]
                        Trigger().scheduleNotification(title: "ZIG SuperWallet", body: "Your recent transaction has been processed. $\(ReduceWalletAmount.debitAmount) has been debited from your wallet.")
                        self.successHandler?(response?.WalletEnableStatus ?? false,jsonObject)
                        self.dismiss(animated: true)
                    }
                    else{
                        self.hideLoader()
                        self.buyButton.isEnabled = true
                        self.dismiss(animated: true)
                        let jsonObject: [String: Any] = [
                            "statusCode" : 4102,
                            "message" : "\(response?.Message ?? "")",
                        ]
                        self.successHandler?(response?.WalletEnableStatus ?? false,jsonObject)
                    }
                }
                else{
                    self.hideLoader()
                    self.buyButton.isEnabled = true
                    let jsonObject: [String: Any] = [
                        "statusCode" : 4102,
                        "message" : "\(response?.Message ?? "")"
                    ]
                    self.failureHandler?(success,jsonObject)
                    self.dismiss(animated: true)
                }
            }
        }
        else{
            let jsonObject: [String: Any] = [
                "statusCode" : 2001,
                "message" : "ZIGSDK - No internet Connection"
            ]
            self.failureHandler?(false,jsonObject)
        }
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func hideLoader()
    {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    func showLoader()
    {
        DispatchQueue.main.async {
            self.activityIndicator.style = .medium
            self.activityIndicator.backgroundColor = .white
            self.activityIndicator.color = .black
            self.activityIndicator.alpha = 0.7
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
}
