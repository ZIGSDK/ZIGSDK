//
//  AddWalletViewController.swift
//  SwiftFramework
//
//  Created by Ashok on 05/09/24.
//

import UIKit

class AddWalletViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var paymentInfoView: UIView!
    
    @IBOutlet weak var infoAmount: UILabel!
    @IBOutlet weak var infoTotal: UILabel!
    @IBOutlet weak var infoTitle: UILabel!
    
    @IBOutlet weak var newCardView: UIButton!
    
    @IBOutlet weak var payBtn: NSLayoutConstraint!
    @IBOutlet weak var cvvTextfield: UIView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var saveCardView: UIView!
    
    @IBOutlet weak var CardDelete: UIButton!
    @IBOutlet weak var cvvNumber: UITextField!
    
    
    
    @IBOutlet weak var paybtn: UIButton!
    @IBOutlet weak var cancelImg: UIImageView!
    @IBOutlet weak var fieldView: UIView!
    @IBOutlet weak var amountCollection: UICollectionView!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var brandTitle: UILabel!
    let activityIndicator = UIActivityIndicatorView()
    var amountArray = ["10.00","15.00","20.00","50.00","100.00","1000.00"]
    
    static var brandTitle = ""
    static var payTitle = ""
    static var clientName = ""
    static var clientId = 0
    static var userID = 0
    static var userName = ""
    static var creditAmount = 0.0
    static var setBrandColour  = ""
    var successHandler: ((Bool, [String: Any]?) -> Void)?
    var failureHandler: ((Bool, [String: Any]?) -> Void)?
    var savedCardDetails = false
    var cancelBool = false
    var XcardType = ""
    var saveCardCheck = true
    var removeCheck = false
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setUpUI()
        amountCollection.register(UINib(nibName: "AddWallet",bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: "AddWalletCollectionViewCell")
        let cardDetails = cardDeatils()
        savedCardDetails = cardDetails.isEmpty
       // print("cardDetails----->",cardDetails)
        paymentInfoView.isHidden = true
        newCardView.isHidden = true
        saveCardView.isHidden = true
    }
    func setUpUI(){
        AddWalletViewController.brandTitle = AddWalletViewController.brandTitle.isEmpty ? "Add funds to SuperWallet" :  AddWalletViewController.brandTitle
        AddWalletViewController.payTitle = AddWalletViewController.payTitle.isEmpty ? "Pay" : AddWalletViewController.payTitle
        AddWalletViewController.setBrandColour = AddWalletViewController.setBrandColour.isEmpty ? "#E00F12" : AddWalletViewController.setBrandColour
        
        fieldView.layer.borderWidth = 2
        fieldView.layer.borderColor = UIColor.black.cgColor
        fieldView.layer.cornerRadius = 5
        //amountField.keyboardType = .numberPad
        amountField.delegate = self
        disableCopyPaste(for: amountField)
        disableCopyPaste(for: cvvNumber)
        paybtn.backgroundColor = UIColor(hex: AddWalletViewController.setBrandColour)
        
        brandTitle.text = AddWalletViewController.brandTitle
        paybtn.setTitle(AddWalletViewController.payTitle, for: .normal)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cancelImg.addGestureRecognizer(tapGesture)
        
        paybtn.layer.cornerRadius = paybtn.frame.height/2
        let bundle = Bundle(for: ZIGSDK.self)
        let image = UIImage(named: "checkbox_in", in: bundle, compatibleWith: nil)
        checkBoxBtn.setImage(image, for: .normal)
        checkBoxBtn.addTarget(self, action: #selector(savedCardCheck), for: .touchUpInside)
        newCardView.isUserInteractionEnabled = false
        newCardView.alpha = 0.6
        cvvNumber.layer.borderWidth = 1
        cvvNumber.layer.borderColor = UIColor.black.cgColor
        cvvNumber.layer.cornerRadius = 5
        cvvNumber.placeholder = "CVV"
        cvvNumber.tag = 102
        cvvNumber.delegate = self
    }
    
    @IBAction func payAction(_ sender: Any) {
        if isReachable(){
            if amountField.text?.count ?? 0 > 0 {
                if savedCardDetails {
                    let cardDetails = cardDeatils()
                    if cardDetails.userData?["paymentStatus"] as! Int == 0 && !paymentMethod.paymentMode {
                        XcardType = cardDetails.userData?["cardType"] as! String
                        paymentInfoView.isHidden = false
                        newCardView.isHidden = false
                        saveCardView.isHidden = false
                        cancelBool = true
                        addCardImage()
                        cardNumber.text = cardDetails.userData?["cardNumber"] as? String
                        if let amountText = amountField.text?.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces),
                           let creditAmount = Double(amountText) {
                            let amountValue = String.init(format: "%.2f", creditAmount)
                            infoAmount.text = "$ \(amountValue)"
                        } else {
                            
                        }
                    }
                    else if cardDetails.userData?["paymentStatus"] as! Int == 1 && paymentMethod.paymentMode {
                        XcardType = cardDetails.userData?["cardType"] as! String
                        paymentInfoView.isHidden = false
                        newCardView.isHidden = false
                        saveCardView.isHidden = false
                        cancelBool = true
                        addCardImage()
                        cardNumber.text = cardDetails.userData?["cardNumber"] as? String
                        if let amountText = amountField.text?.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces),
                           let creditAmount = Double(amountText) {
                            let amountValue = String.init(format: "%.2f", creditAmount)
                            infoAmount.text = "$ \(amountValue)"
                        } else {
                            
                        }
                    }
                    else{
                        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle(for: NeedPermisson.self))
                        let addWalletScreen = storyboard.instantiateViewController(withIdentifier: "paymentViewController") as! paymentViewController
                        addWalletScreen.successHandler = { success, message in
                            self.successHandler?(success,message)
                            self.dismiss(animated: true)
                        }
                        addWalletScreen.failureHandler = {  success, message in
                            self.failureHandler?(success,message)
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                        if let amountText = amountField.text?.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces),
                           let creditAmount = Double(amountText) {
                            paymentViewController.amount = creditAmount
                        } else {
                            // print("Failed to convert the string to a Double")
                        }
                        addWalletScreen.modalPresentationStyle = .fullScreen
                        self.present(addWalletScreen, animated: true, completion: nil)
                    }
                }
                else{
                    let storyboard = UIStoryboard(name: "Payment", bundle: Bundle(for: NeedPermisson.self))
                    let addWalletScreen = storyboard.instantiateViewController(withIdentifier: "paymentViewController") as! paymentViewController
                    addWalletScreen.successHandler = { success, message in
                        self.successHandler?(success,message)
                        self.dismiss(animated: true)
                    }
                    addWalletScreen.failureHandler = {  success, message in
                        self.failureHandler?(success,message)
                    }
                    if let amountText = amountField.text?.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces),
                       let creditAmount = Double(amountText) {
                        paymentViewController.amount = creditAmount
                    } else {
                    }
                    addWalletScreen.modalPresentationStyle = .fullScreen
                    self.present(addWalletScreen, animated: true, completion: nil)
                }
            }
            else{
                let alert = UIAlertController(title: "Enter the Amount", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
        else{
            let jsonObject: [String: Any] = [
                "Message" : "ZIGSDK-No internet connection"
            ]
            self.failureHandler?(false,jsonObject)
        }
    }
    func addCardImage(){
        if XcardType == "Visa"
        {
            let bundle = Bundle(for: ZIGSDK.self)
            let image = UIImage(named: "visa_icon", in: bundle, compatibleWith: nil)
            cardImg.image = image
        }
        else if XcardType == "Mastercard"
        {
            let bundle = Bundle(for: ZIGSDK.self)
            let image = UIImage(named: "mastercard_icon", in: bundle, compatibleWith: nil)
            cardImg.image = image
            
        }
        else if XcardType == "American Express"
        {
            let bundle = Bundle(for: ZIGSDK.self)
            let image = UIImage(named: "americanexpress_icon", in: bundle, compatibleWith: nil)
            cardImg.image = image
            
        }
        else if XcardType == "Discover"
        {
            let bundle = Bundle(for: ZIGSDK.self)
            let image = UIImage(named: "Discover", in: bundle, compatibleWith: nil)
            cardImg.image = image
        }
        else if XcardType == "JCB"
        {
            let bundle = Bundle(for: ZIGSDK.self)
            let image = UIImage(named: "JCB", in: bundle, compatibleWith: nil)
            cardImg.image = image
        }
        else if XcardType == "Diners Club"
        {
            let bundle = Bundle(for: ZIGSDK.self)
            let image = UIImage(named: "Diners Club", in: bundle, compatibleWith: nil)
            cardImg.image = image
        }
    }
    @objc func savedCardCheck()
    {
        if saveCardCheck == true
        {
            let bundle = Bundle(for: ZIGSDK.self)
            let image = UIImage(named: "checkbox_out", in: bundle, compatibleWith: nil)
            checkBoxBtn.setImage(image, for: .normal)
            saveCardCheck = false
            newCardView.isUserInteractionEnabled = true
            newCardView.alpha = 1
        }
        else
        {
            let bundle = Bundle(for: ZIGSDK.self)
            let image = UIImage(named: "checkbox_in", in: bundle, compatibleWith: nil)
            checkBoxBtn.setImage(image, for: .normal)
            saveCardCheck = true
            newCardView.isUserInteractionEnabled = false
            newCardView.alpha = 0.6
        }
    }
    @IBAction func payBtn(_ sender: Any) {
        if isReachable(){
            LoaderUtility.shared.showLoader(on: self.view)
            if removeCheck {
                let storyboard = UIStoryboard(name: "Payment", bundle: Bundle(for: NeedPermisson.self))
                let addWalletScreen = storyboard.instantiateViewController(withIdentifier: "paymentViewController") as! paymentViewController
                addWalletScreen.successHandler = { success, message in
                    self.successHandler?(success,message)
                    self.dismiss(animated: true)
                }
                addWalletScreen.failureHandler = {  success, message in
                    self.failureHandler?(success,message)
                }
                if let amountText = amountField.text?.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces),
                   let creditAmount = Double(amountText) {
                    paymentViewController.amount = creditAmount
                } else {
                }
                addWalletScreen.modalPresentationStyle = .fullScreen
                self.present(addWalletScreen, animated: true, completion: nil)
            }
            else{
                if cvvNumber.text?.isEmpty == false && cvvNumber.text?.count == 3 {
                    let cardDetails = cardDeatils()
                    if let amountText = amountField.text?.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces),
                       let creditAmount = Double(amountText) {
                        
                        let AmountCent = Int(paymentViewController.amount * 100)
                        let mercentId = LoaderUtility.shared.generateRandom17DigitNumber()
                        var key = ""
                        if cardDetails.userData?["paymentStatus"] as! Int == 0 && !paymentMethod.paymentMode {
                            key = cardDetails.userData?["token"] as? String ?? ""
                        }
                        else if cardDetails.userData?["paymentStatus"] as! Int == 1 && paymentMethod.paymentMode{
                            key = cardDetails.userData?["token"] as? String ?? ""
                        }
                        PaymentViewModel.sharedInstance.paymentGateWayToken(appName: userDetails.clientName, amount: "\(creditAmount)", token: key, cvvNumber: "\(cvvNumber.text ?? "")") { response, success in
                            if success{
                                if response?.xError ?? "" == ""{
                                   // print("PaymentGateway----->",response ?? "")
                                    ReferanceViewModel.sharedInstance.addReferance(Amount: AmountCent, Transcationtype: "Card", Currency: "USD", Txn_id: response?.xRefNum ?? "", Correlation_id: response?.xStatus ?? "", Bankmessage: "", Txnstatus: "false", Gatewayrespcode: "", Retrival_ref_no: "", Specialpayment: "iOS Payment", CardType: response?.xCardType ?? "", MaskedCardNumber: response?.xMaskedCardNumber ?? "", Txntag: "\(mercentId)", EmailID: userDetails.emailId, Phone: "", UserName: userDetails.userName, Userid: "\(userDetails.UserId)", Txn_ref_no: mercentId, Error_code: response?.xErrorCode ?? "", Error_description: response?.xError ?? "", Status_code: response?.xAuthCode ?? "", Fareid: "0", Wallet: true, AuthKey: userDetails.AuthKey) { responses, success in
                                        if success{
                                            if responses?.Message == "Ok"{
                                                WalletViewModel.sharedInstance.walletPaymentMethod(clientName: userDetails.clientName, clientId: userDetails.clientId, userId: userDetails.UserId, userName: userDetails.userName, creditAmount: creditAmount, debitAmount: 0.0, purpose: "Wallet Recharge", walletBool: true) { responseData, success in
                                                    if success{
                                                        if responseData?.WalletEnableStatus ?? false {
                                                            LoaderUtility.shared.hideLoader()
                                                            self.dismiss(animated: true)
                                                            let balanceAmount = String.init(format: "%.2f", responseData?.walletBalanceAmount ?? 0.0)
                                                            let jsonObject: [String: Any] = [
                                                                "Message" : "\(responseData?.Message ?? "")",
                                                                "userId" : "\(responseData?.userId ?? 0)",
                                                                "userName" : "\(responseData?.userName ?? "")",
                                                                "BalanceAmount" : "\(balanceAmount)"
                                                            ]
                                                            Trigger().scheduleNotification(title: "ZIGSuperWallet", body: "Congratulations! Your wallet has been credited with $\(AddWalletViewController.creditAmount).")
                                                            self.successHandler?(responseData?.WalletEnableStatus ?? false,jsonObject)
                                                        }
                                                        else
                                                        {
                                                            DispatchQueue.main.async {
                                                                self.dismiss(animated: true, completion: nil)
                                                            }
                                                            LoaderUtility.shared.hideLoader()
                                                            let jsonObject: [String: Any] = [
                                                                "Message" : "ZIGSDK-Payment Failed \(response?.xErrorCode ?? "") - \(response?.xError ?? "")"
                                                            ]
                                                            self.failureHandler?(false,jsonObject)
                                                        }
                                                    }
                                                    else{
                                                        DispatchQueue.main.async {
                                                            self.dismiss(animated: true, completion: nil)
                                                        }
                                                        LoaderUtility.shared.hideLoader()
                                                        let jsonObject: [String: Any] = [
                                                            "Message" : "ZIGSDK-Payment Failed \(response?.xErrorCode ?? "") - \(response?.xError ?? "")"
                                                        ]
                                                        self.failureHandler?(false,jsonObject)
                                                    }
                                                }
                                            }
                                            else{
                                                DispatchQueue.main.async {
                                                    self.dismiss(animated: true, completion: nil)
                                                }
                                                LoaderUtility.shared.hideLoader()
                                                let jsonObject: [String: Any] = [
                                                    "Message" : "ZIGSDK-Payment Failed \(response?.xErrorCode ?? "") - \(response?.xError ?? "")"
                                                ]
                                                self.failureHandler?(false,jsonObject)
                                            }
                                        }
                                        else{
                                            LoaderUtility.shared.hideLoader()
                                            DispatchQueue.main.async {
                                                self.dismiss(animated: true, completion: nil)
                                            }
                                            let jsonObject: [String: Any] = [
                                                "Message" : "ZIGSDK-Payment Failed \(response?.xErrorCode ?? "") - \(response?.xError ?? "")"
                                            ]
                                            self.failureHandler?(false,jsonObject)
                                        }
                                    }
                                }
                                else{
                                    LoaderUtility.shared.hideLoader()
                                    DispatchQueue.main.async {
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                    let jsonObject: [String: Any] = [
                                        "Message" : "ZIGSDK-Payment Failed \(response?.xErrorCode ?? "") - \(response?.xError ?? "")"
                                    ]
                                    self.failureHandler?(false,jsonObject)
                                }
                            }
                            else{
                                LoaderUtility.shared.hideLoader()
                                DispatchQueue.main.async {
                                    self.dismiss(animated: true, completion: nil)
                                }
                                let jsonObject: [String: Any] = [
                                    "Message" : "ZIGSDK-Payment Failed \(response?.xErrorCode ?? "") - \(response?.xError ?? "")"
                                ]
                                self.failureHandler?(false,jsonObject)
                            }
                        }
                    } else {
                        let jsonObject: [String: Any] = [
                            "Message" : "ZIGSDK-Something wnt wronf during payment"
                        ]
                        self.failureHandler?(false,jsonObject)
                        LoaderUtility.shared.hideLoader()
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                else{
                    LoaderUtility.shared.hideLoader()
                    let toast = ToastView(message: "Enter the CVV")
                    toast.showToast(inView: self.view)
                }
            }
        }
        else{
            let jsonObject: [String: Any] = [
                "Message" : "ZIGSDK-No internet connection"
            ]
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            self.failureHandler?(false,jsonObject)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amountArray.count
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        amountField.placeholder = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if amountField.text?.isEmpty ?? true {
            amountField.placeholder = "$ Enter an amount"
        }
        
        if cvvNumber.text?.isEmpty ?? true {
            cvvNumber.placeholder = "CVV"
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountField.resignFirstResponder()
        cvvNumber.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 102 {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            guard allowedCharacters.isSuperset(of: characterSet) else {
                return false
            }
            let currentText = cvvNumber.text ?? ""
            let newLength = currentText.count + string.count - range.length
            return newLength <= 3
        }
        else{
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            guard allowedCharacters.isSuperset(of: characterSet) else {
                return false
            }
            let currentText = amountField.text ?? ""
            let newLength = currentText.count + string.count - range.length
            return newLength <= 5
        }
    }
    private func disableCopyPaste(for textField: UITextField) {
        textField.addTarget(self, action: #selector(disableActions), for: .editingDidBegin)
    }
    
    @objc private func disableActions() {
        UIMenuController.shared.menuItems = nil
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddWalletCollectionViewCell", for: indexPath) as! AddWalletCollectionViewCell
        cell.listedAmount.text = "$ \(amountArray[indexPath.row])"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        amountField.text = "\(amountArray[indexPath.row])"
        amountField.resignFirstResponder()
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
    func cardDeatils() -> (userData: [String: Any]?, isEmpty: Bool) {
        if let userData = CustomUserDefaults.shared.object(forKey: "savedCardDetails") as? [String: Any] {
            return (userData, true)
        }
        else{
            return (nil, false)
        }
    }
    
    @IBAction func removeCardaction(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Card details", message: "Do you want delete details", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.removeCardDetails()
            self.removeCheck = true
            self.paymentInfoView.isHidden = true
            self.newCardView.isHidden = true
            self.saveCardView.isHidden = true
            self.cancelBool = false
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func removeCardDetails(){
        savedCardDetails = false
        CustomUserDefaults.shared.removeObject(forKey: "savedCardDetails")
    }
    @IBAction func newCardAction(_ sender: Any) {
        paymentInfoView.isHidden = false
        newCardView.isHidden = false
        saveCardView.isHidden = false
        let storyboard = UIStoryboard(name: "Payment", bundle: Bundle(for: NeedPermisson.self))
        let addWalletScreen = storyboard.instantiateViewController(withIdentifier: "paymentViewController") as! paymentViewController
        addWalletScreen.successHandler = { success, message in
            self.successHandler?(success,message)
            self.dismiss(animated: true)
        }
        addWalletScreen.failureHandler = {  success, message in
            self.failureHandler?(success,message)
        }
        if let amountText = amountField.text?.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces),
           let creditAmount = Double(amountText) {
            paymentViewController.amount = creditAmount
        } else {
        }
        addWalletScreen.modalPresentationStyle = .fullScreen
        self.present(addWalletScreen, animated: true, completion: nil)
    }
}
extension AddWalletViewController {
    @objc func imageTapped() {
        if cancelBool {
            paymentInfoView.isHidden = true
            newCardView.isHidden = true
            saveCardView.isHidden = true
            cancelBool = false
        }else
        {
            self.dismiss(animated: true)
        }
    }
}
