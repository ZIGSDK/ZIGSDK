


import UIKit

class paymentViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    var windowUIvi: UIWindow?
    @IBOutlet weak var carddetailsview: UIView!
    @IBOutlet var customerName: UITextField!
    @IBOutlet var customerCardno: UITextField!
    @IBOutlet var expireDate: UITextField!
    @IBOutlet var cvvnumber: UITextField!
    @IBOutlet var closeButton: UIButton!
  
    @IBOutlet weak var alertOk: UIButton!
    @IBOutlet weak var alertCancel: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var alertDescription: UILabel!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var customerCardnoLabel: UILabel!
    @IBOutlet var expireDateLabel: UILabel!
    @IBOutlet var cvvnumberLabel: UILabel!
//    @IBOutlet var JCBView: UIImageView!
//    @IBOutlet var DineClubView: UIImageView!
//    @IBOutlet var visaImageView: UIImageView!
//    @IBOutlet var masterImageView: UIImageView!
//    @IBOutlet var americanExpressView: UIImageView!
//    @IBOutlet var discoverView: UIImageView!
    @IBOutlet var savePaymentButton: UIButton!
//    @IBOutlet var paymentBackView: UIView!
    @IBOutlet var makePaymentButton: UIButton!
    var successHandler: ((Bool, [String: Any]?) -> Void)?
    var failureHandler: ((Bool, [String: Any]?) -> Void)?

    var bottomView = UIView()
    let addTickeValue: NSMutableArray = []
    var firstTextfield = UITextField()
    var secondTextfield = UITextField()
    var thirdTextfield = UITextField()
    var okayButton = UIButton()
    var LivepaymentBool = Bool()
    var ta_tokenGlobal = NSString()
    var waitingLoader = UIImageView()
var countGlobalMutableArray = NSMutableArray()
    @IBOutlet var stateAddress: UITextField!
    @IBOutlet var stateAddressLabel: UILabel!
    @IBOutlet var zipCode: UITextField!
    @IBOutlet var zipcodeLabel: UILabel!
    @IBOutlet var city: UITextField!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var state: UITextField!
    @IBOutlet var cityLabel: UILabel!
    var listArray = NSMutableArray()
    var savePaymentBool = true
    var timerEmail: Timer?
    static var amount = 0.0
    var myPickerView: UIPickerView!
    var pickerData = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    var UnqiueNumber = String()
    override func viewDidDisappear(_ animated: Bool) {
        //print(countGlobalMutableArray)
      //  ConfigFile.brewageArray = countGlobalMutableArray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    func setUpUI(){
        overrideUserInterfaceStyle = .light
        customerName.setLeftPaddingPoints(15)
        customerCardno.setLeftPaddingPoints(15)
        customerCardno.tag = 101
        expireDate.tag = 102
        stateAddress.tag = 104
        city.tag = 105
        state.tag = 106
        zipCode.tag = 107
        customerName?.addTarget(self, action: #selector(textFieldDidChange(textField:)),
            for: .editingChanged)
        cvvnumber?.addTarget(self, action: #selector(textFieldDidChange(textField:)),
            for: .editingChanged)
        customerCardno?.addTarget(self, action: #selector(textFieldDidChange(textField:)),
                                  for: .editingChanged)
        expireDate?.addTarget(self, action: #selector(textFieldDidChange(textField:)),
            for: .editingChanged)
        stateAddress?.addTarget(self, action: #selector(textFieldDidChange(textField:)),
            for: .editingChanged)
        city?.addTarget(self, action: #selector(textFieldDidChange(textField:)),
            for: .editingChanged)
        state?.addTarget(self, action: #selector(textFieldDidChange(textField:)),
            for: .editingChanged)
        zipCode?.addTarget(self, action: #selector(textFieldDidChange(textField:)),
            for: .editingChanged)

        customerName.delegate = self
        expireDate.delegate = self
        cvvnumber.delegate = self
        customerCardno.inputAccessoryView = createToolbar()
        expireDate.inputAccessoryView = createToolbar()
        cvvnumber.inputAccessoryView = createToolbar()
        zipCode.inputAccessoryView = createToolbar()
        stateAddress.delegate = self
        zipCode.delegate = self
        state.delegate = self
        city.delegate = self
        customerName.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        customerName.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        customerName.layer.shadowOpacity = 1.0
        customerName.layer.shadowRadius = 0.0
        customerName.layer.masksToBounds = false
        customerName.layer.cornerRadius = 4.0

        customerCardno.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        customerCardno.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        customerCardno.layer.shadowOpacity = 1.0
        customerCardno.layer.shadowRadius = 0.0
        customerCardno.layer.masksToBounds = false
        customerCardno.layer.cornerRadius = 4.0

        expireDate.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        expireDate.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        expireDate.layer.shadowOpacity = 1.0
        expireDate.layer.shadowRadius = 0.0
        expireDate.layer.masksToBounds = false
        expireDate.layer.cornerRadius = 4.0

        cvvnumber.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        cvvnumber.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cvvnumber.layer.shadowOpacity = 1.0
        cvvnumber.layer.shadowRadius = 0.0
        cvvnumber.layer.masksToBounds = false
        cvvnumber.layer.cornerRadius = 4.0

        stateAddress.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        stateAddress.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        stateAddress.layer.shadowOpacity = 1.0
        stateAddress.layer.shadowRadius = 0.0
        stateAddress.layer.masksToBounds = false
        stateAddress.layer.cornerRadius = 4.0

        zipCode.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        zipCode.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        zipCode.layer.shadowOpacity = 1.0
        zipCode.layer.shadowRadius = 0.0
        zipCode.layer.masksToBounds = false
        zipCode.layer.cornerRadius = 4.0

        state.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        state.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        state.layer.shadowOpacity = 1.0
        state.layer.shadowRadius = 0.0
        state.layer.masksToBounds = false
        state.layer.cornerRadius = 4.0

        city.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        city.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        city.layer.shadowOpacity = 1.0
        city.layer.shadowRadius = 0.0
        city.layer.masksToBounds = false
        city.layer.cornerRadius = 4.0


        makePaymentButton.layer.cornerRadius = 5
        makePaymentButton.layer.masksToBounds = true
        makePaymentButton.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        makePaymentButton.isUserInteractionEnabled = false
        
        backgroundView.isHidden = true
        
        alertView.isHidden = true
        alertOk.layer.cornerRadius = 20
        alertCancel.layer.cornerRadius = 20
        
        alertTitle.text = "This transaction will appear in your bank statement as \(userDetails.clientName)"
        savePaymentBool = true
        savePaymentButton.addTarget(self, action: #selector(savePaymentAction), for: .touchUpInside)
        customerCardno.delegate = self
    }
    @objc func doneClick() {
        state.resignFirstResponder()
    }
    @objc func cancelClick() {
        state.resignFirstResponder()
        city.becomeFirstResponder()
    }
    @objc func savePaymentAction()
    {
            if savePaymentBool == true
            {
                let bundle = Bundle(for: ZIGSDK.self)
                let image = UIImage(named: "checkbox_out", in: bundle, compatibleWith: nil)
                savePaymentButton.setImage(image, for: .normal)
                savePaymentBool = false
            }
            else
            {
                let bundle = Bundle(for: ZIGSDK.self)
                let image = UIImage(named: "checkbox_in", in: bundle, compatibleWith: nil)
                savePaymentButton.setImage(image, for: .normal)
                savePaymentBool = true
            }
    }
    @objc func textFieldDidChange(textField: UITextField) {
       // print("Payment TextField----->",textField)
        if textField.tag == 100
            {
            if (textField.text?.count)! > 0
                {
               // customerNameLabel.text = "Name on Card"
            }
            else
            {
                customerNameLabel.text = ""
            }
        }
        else if textField.tag == 101
            {
            if (textField.text?.count)! > 0
                {
               // customerCardnoLabel.text = "Credit card Number"
            }
            else
            {
                customerCardnoLabel.text = ""
            }
        }
        else if textField.tag == 102
            {
            if (textField.text?.count)! > 0
                {
               // expireDateLabel.text = "MM/YY"
            }
            else
            {
                expireDateLabel.text = ""
            }
        }
        else if textField.tag == 103
            {
            if (textField.text?.count)! > 0
                {
               // cvvnumberLabel.text = "CVV"
            }
            else
            {
                cvvnumberLabel.text = ""
            }
        }
        else if textField.tag == 104
            {
            if (textField.text?.count)! > 0
                {
                //stateAddressLabel.text = "Street Address"

            }
            else
            {
                stateAddressLabel.text = ""
            }

        }
        else if textField.tag == 105
            {
            if (textField.text?.count)! > 1
                {
               // cityLabel.text = "City"
            }
            else
            {
                cityLabel.text = ""
            }
        }
        else if textField.tag == 106
            {
            if (textField.text?.count)! > 1
                {
               // stateLabel.text = "State"
            }
            else
            {
                stateLabel.text = ""
            }
        }
        else if textField.tag == 107
            {
            if (textField.text?.count)! > 1
                {
                //zipcodeLabel.text = "ZIP"
            }
            else
            {
                zipcodeLabel.text = ""
            }
        }
        else if textField.tag == 300
            {
            if (textField.text?.count)! > 0
                {
                secondTextfield.becomeFirstResponder()
            }
        }
        else if textField.tag == 301
            {
            if (textField.text?.count)! > 0
                {
                thirdTextfield.becomeFirstResponder()

            }
            else
            {
                firstTextfield.becomeFirstResponder()
            }
        }
        else if textField.tag == 302
            {
            if (textField.text?.count)! > 0
                {
                thirdTextfield.resignFirstResponder()
            }
            else
            {
                secondTextfield.becomeFirstResponder()
            }
        }
        if firstTextfield.text != "" && secondTextfield.text != "" && thirdTextfield.text != ""
            {
            okayButton.isUserInteractionEnabled = true
        }
        if customerName.text?.isEmpty == false && customerCardno.text?.isEmpty == false && expireDate.text?.isEmpty == false && cvvnumber.text?.isEmpty == false && stateAddress.text?.isEmpty == false && zipCode.text?.isEmpty == false && state.text?.isEmpty == false && city.text?.isEmpty == false
            {
            makePaymentButton.backgroundColor = UIColor.red
            makePaymentButton.isUserInteractionEnabled = true
        }
        else
        {
            makePaymentButton.backgroundColor = UIColor.red.withAlphaComponent(0.6)
            makePaymentButton.isUserInteractionEnabled = false
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 106
            {
            self.pickUp(textField)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       // print("Payment field--->")
        if textField.tag == 101
        {
            if (textField.text?.count)! > 1
            {
                // customerCardnoLabel.text = "Credit card Number"
            }
            else
            {
                customerCardnoLabel.text = ""
                textField.rightView?.frame = CGRect(x: 0, y: 5, width: 0, height: 0)
                textField.rightViewMode = .never
            }
        }
        else if textField.tag == 102
        {
            if (textField.text?.count)! > 1
            {
                // expireDateLabel.text = "MM/YY"
            }
            else
            {
                expireDateLabel.text = ""
            }
        }
        else if textField.tag == 104
        {
            if (textField.text?.count)! > 1
            {
                //  stateAddressLabel.text = "Street Address"
            }
            else
            {
                stateAddressLabel.text = ""
            }
        }
        else if textField.tag == 105
        {
            if (textField.text?.count)! > 1
            {
                //  cityLabel.text = "City"
            }
            else
            {
                cityLabel.text = ""
            }
        }
        else if textField.tag == 106
        {
            if (textField.text?.count)! > 1
            {
                // stateLabel.text = "State"
            }
            else
            {
                stateLabel.text = ""
            }
        }
        else if textField.tag == 107
        {
            if (textField.text?.count)! > 1
            {
                // zipcodeLabel.text = "ZIP"
            }
            else
            {
                zipcodeLabel.text = ""
            }
        }
        if textField == customerCardno
        {
            if textField.text!.count == 1
            {
                if textField.text == "4"
                {
                    let bundle = Bundle(for: ZIGSDK.self)
                    if let image = UIImage(named: "visa_icon", in: bundle, compatibleWith: nil) {
                        let imageView = UIImageView(image: image)
                        imageView.translatesAutoresizingMaskIntoConstraints = false
                        textField.rightView = imageView
                        textField.rightViewMode = .always
                        
                        // Set constraints for imageView
                        NSLayoutConstraint.activate([
                            imageView.widthAnchor.constraint(equalToConstant: 40),
                            imageView.heightAnchor.constraint(equalToConstant: 40),
                        ])
                    }
                }
                else if textField.text == "5" || textField.text == "2"
                {
                    let bundle = Bundle(for: ZIGSDK.self)
                    if let image = UIImage(named: "mastercard_icon", in: bundle, compatibleWith: nil) {
                        let imageView = UIImageView(image: image)
                        imageView.translatesAutoresizingMaskIntoConstraints = false
                        textField.rightView = imageView
                        textField.rightViewMode = .always
                        
                        // Set constraints for imageView
                        NSLayoutConstraint.activate([
                            imageView.widthAnchor.constraint(equalToConstant: 40),
                            imageView.heightAnchor.constraint(equalToConstant: 40),
                        ])
                    }
                }
                else if textField.text == "6"
                {
                    let bundle = Bundle(for: ZIGSDK.self)
                    if let image = UIImage(named: "Discover", in: bundle, compatibleWith: nil) {
                        let imageView = UIImageView(image: image)
                        imageView.translatesAutoresizingMaskIntoConstraints = false
                        textField.rightView = imageView
                        textField.rightViewMode = .always
                        
                        // Set constraints for imageView
                        NSLayoutConstraint.activate([
                            imageView.widthAnchor.constraint(equalToConstant: 40),
                            imageView.heightAnchor.constraint(equalToConstant: 40),
                        ])
                    }
                    
                }
                else
                {
                    let bundle = Bundle(for: ZIGSDK.self)
                    if let image = UIImage(named: "visas_icon", in: bundle, compatibleWith: nil) {
                        let imageView = UIImageView(image: image)
                        imageView.translatesAutoresizingMaskIntoConstraints = false
                        textField.rightView = imageView
                        textField.rightViewMode = .always
                        
                        // Set constraints for imageView
                        NSLayoutConstraint.activate([
                            imageView.widthAnchor.constraint(equalToConstant: 40),
                            imageView.heightAnchor.constraint(equalToConstant: 40),
                        ])
                    }
                    
                }
            }
            if textField.text!.count == 2
            {
                if textField.text == "34" || textField.text == "37"
                {
                    let bundle = Bundle(for: ZIGSDK.self)
                    if let image = UIImage(named: "americanexpress_icon", in: bundle, compatibleWith: nil) {
                        let imageView = UIImageView(image: image)
                        imageView.translatesAutoresizingMaskIntoConstraints = false
                        textField.rightView = imageView
                        textField.rightViewMode = .always
                        
                        // Set constraints for imageView
                        NSLayoutConstraint.activate([
                            imageView.widthAnchor.constraint(equalToConstant: 40),
                            imageView.heightAnchor.constraint(equalToConstant: 40),
                        ])
                    }
                }
                else if textField.text == "35"
                {
                    let bundle = Bundle(for: ZIGSDK.self)
                    if let image = UIImage(named: "JCB", in: bundle, compatibleWith: nil) {
                        let imageView = UIImageView(image: image)
                        imageView.translatesAutoresizingMaskIntoConstraints = false
                        textField.rightView = imageView
                        textField.rightViewMode = .always
                        
                        // Set constraints for imageView
                        NSLayoutConstraint.activate([
                            imageView.widthAnchor.constraint(equalToConstant: 40),
                            imageView.heightAnchor.constraint(equalToConstant: 40),
                        ])
                    }
                }
                else if textField.text == "30" || textField.text == "36" || textField.text == "38" || textField.text == "39"
                {
                    let bundle = Bundle(for: ZIGSDK.self)
                    if let image = UIImage(named: "Diners Club", in: bundle, compatibleWith: nil) {
                        let imageView = UIImageView(image: image)
                        imageView.translatesAutoresizingMaskIntoConstraints = false
                        textField.rightView = imageView
                        textField.rightViewMode = .always
                        
                        // Set constraints for imageView
                        NSLayoutConstraint.activate([
                            imageView.widthAnchor.constraint(equalToConstant: 40),
                            imageView.heightAnchor.constraint(equalToConstant: 40),
                        ])
                    }
                }
            }
            if (textField.text?.count)! > 1
            {
                textField.rightView?.frame = CGRect(x: 0, y: 5, width: 30, height: 30)
                textField.rightViewMode = .always
            }
            else
            {
                textField.rightView?.frame = CGRect(x: 0, y: 5, width: 0, height: 0)
                textField.rightViewMode = .never
            }
            
            let maxLength = 19 // Maximum length including spaces for card format "1234 5678 9012 3456"
            guard let currentText = textField.text else { return false }
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let formattedText = newText.chunkFormatted()
            
            if formattedText.count > maxLength {
                return false
            }
            textField.text = formattedText
            if customerName.text?.isEmpty == false && textField.text?.isEmpty == false && expireDate.text?.isEmpty == false && cvvnumber.text?.isEmpty == false && stateAddress.text?.isEmpty == false && zipCode.text?.isEmpty == false && state.text?.isEmpty == false && city.text?.isEmpty == false
                {
                print("PaymentSystem---->",customerCardno)
                makePaymentButton.backgroundColor = UIColor.red
                makePaymentButton.isUserInteractionEnabled = true
            }
            else
            {
                makePaymentButton.backgroundColor = UIColor.red.withAlphaComponent(0.6)
                makePaymentButton.isUserInteractionEnabled = false
            }
            return false
        }
        else if textField == expireDate
        {
            
            
            let maxNumberOfCharacters = 4
            
            // only allow numerical characters
            guard string.compactMap({ Int(String($0)) }).count ==
                    string.count else { return false }
            
            let text = textField.text ?? ""
            
            if string.count == 0 {
                textField.text = String(text.dropLast()).exprieFormatted()
            }
            else {
                let newText = String((text + string)
                    .filter({ $0 != "/" }).prefix(maxNumberOfCharacters))
                textField.text = newText.exprieFormatted()
            }
            if customerName.text?.isEmpty == false && customerCardno.text?.isEmpty == false && textField.text?.isEmpty == false && cvvnumber.text?.isEmpty == false && stateAddress.text?.isEmpty == false && zipCode.text?.isEmpty == false && state.text?.isEmpty == false && city.text?.isEmpty == false
                {
                print("PaymentSystem---->",customerCardno)
                makePaymentButton.backgroundColor = UIColor.red
                makePaymentButton.isUserInteractionEnabled = true
            }
            else
            {
                makePaymentButton.backgroundColor = UIColor.red.withAlphaComponent(0.6)
                makePaymentButton.isUserInteractionEnabled = false
            }
            
            return false
        }
        else if textField == zipCode
        {
            let maxLength = 5
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if textField == cvvnumber
        {
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if textField.tag == 300
        {
            let maxLength = 1
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if textField.tag == 301
        {
            let maxLength = 1
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
        }
        else if textField.tag == 302
        {
            let maxLength = 1
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
        }
        else
        {
            return true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      //  stateLabel.text = "State"

        state.text = pickerData[row]
    }
    func setPaddingView(strImgname: String, txtField: UITextField) {
        let imageView = UIImageView(image: UIImage(named: strImgname))
        imageView.frame = CGRect(x: 0, y: 5, width: imageView.image!.size.width, height: imageView.image!.size.height)
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        paddingView.addSubview(imageView)
        txtField.leftViewMode = .always
        txtField.leftView = paddingView
    }
    func pickUp(_ textField: UITextField) {

        // UIPickerView
        self.myPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar

    }
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        return toolbar
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func proccedtopaybtn(_ sender: Any) {
        if isExpired(monthYear: expireDate.text ?? ""){
            backgroundView.isHidden = false
            alertView.isHidden = false
        }
        else{
            let alert = UIAlertController(title: "Enter the Correct ExpireDate", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func alertOk(_ sender: Any) {
        if isReachable(){
            alertView.isHidden = true
            backgroundView.isHidden = true
            LoaderUtility.shared.showLoader(on: self.view)
            var customerCardString = ""
            if customerCardno.text != ""
            {
                customerCardString = removeSpecialCharsFromString(text: customerCardno.text!)
            }
           // print("PaymentGateway----->",customerCardString)
            
            var customerExpireString = ""
            if customerCardno.text != ""
            {
                customerExpireString = removeSpecialCharsFromString(text: expireDate.text!)
            }
           // print("PaymentGateway----->",customerExpireString)
            let AmountCent = Int(paymentViewController.amount * 100)
            let mercentId = LoaderUtility.shared.generateRandom17DigitNumber()
            let amountValue = String.init(format: "%.2f", paymentViewController.amount)
            
            PaymentViewModel.sharedInstance.paymentGateWay(cardNumber: customerCardString, expriedNumber: customerExpireString, cvv: "\(cvvnumber.text!)", amount: "\(amountValue)", streetAddress: "\(stateAddress.text!)", zipCode: "\(zipCode.text!)", appName: userDetails.clientName, userName: userDetails.userName,holderName: "\(customerName.text!)") { respose, success in
                if success{
                    if respose?.xError ?? "" == ""{
                        if self.savePaymentBool {
                            var userData: [String: Any] = [:]
                            if paymentMethod.paymentMode {
                                userData = [
                                    "token": respose?.xToken ?? "",
                                    "referanceNumber": respose?.xRefNum ?? "",
                                    "cardType": respose?.xCardType ?? "",
                                    "cardNumber": respose?.xMaskedCardNumber ?? "",
                                    "paymentStatus": true
                                ]
                            }
                            else{
                                userData = [
                                    "token": respose?.xToken ?? "",
                                    "referanceNumber": respose?.xRefNum ?? "",
                                    "cardType": respose?.xCardType ?? "",
                                    "cardNumber": respose?.xMaskedCardNumber ?? "",
                                    "paymentStatus": false
                                ]
                            }
                            CustomUserDefaults.shared.set(userData, forKey: "savedCardDetails")
                        }
                        ReferanceViewModel.sharedInstance.addReferance(Amount: AmountCent, Transcationtype: "Card", Currency: "USD", Txn_id: respose?.xRefNum ?? "", Correlation_id: respose?.xStatus ?? "", Bankmessage: "", Txnstatus: "true", Gatewayrespcode: "", Retrival_ref_no: "", Specialpayment: "iOS Payment", CardType: respose?.xCardType ?? "", MaskedCardNumber: respose?.xMaskedCardNumber ?? "", Txntag: "\(mercentId)", EmailID: userDetails.emailId, Phone: "", UserName: userDetails.userName, Userid: "\(userDetails.UserId)", Txn_ref_no: mercentId, Error_code: respose?.xErrorCode ?? "", Error_description: respose?.xError ?? "", Status_code: respose?.xAuthCode ?? "", Fareid: "0", Wallet: true, AuthKey: userDetails.AuthKey) { responses, success in
                            if success{
                                if responses?.Message == "Ok"{
                                    WalletViewModel.sharedInstance.walletPaymentMethod(clientName: userDetails.clientName, clientId: userDetails.clientId, userId: userDetails.UserId, userName: userDetails.userName, creditAmount: paymentViewController.amount, debitAmount: 0.0, purpose: "Wallet Recharge", walletBool: true) { response, success in
                                        if success{
                                            if response?.WalletEnableStatus ?? false {
                                                LoaderUtility.shared.hideLoader()
                                                self.dismiss(animated: true)
                                                let balanceAmount = String.init(format: "%.2f", response?.walletBalanceAmount ?? 0.0)
                                                let jsonObject: [String: Any] = [
                                                    "Message" : "\(response?.Message ?? "")",
                                                    "userId" : "\(response?.userId ?? 0)",
                                                    "userName" : "\(response?.userName ?? "")",
                                                    "BalanceAmount" : "\(balanceAmount)"
                                                ]
                                                Trigger().scheduleNotification(title: "ZIGSuperWallet", body: "Congratulations! Your wallet has been credited with $\(AddWalletViewController.creditAmount).")
                                                self.successHandler?(response?.WalletEnableStatus ?? false,jsonObject)
                                            }
                                            else
                                            {
                                                LoaderUtility.shared.hideLoader()
                                                DispatchQueue.main.async {
                                                    self.dismiss(animated: true, completion: nil)
                                                }
                                                let jsonObject: [String: Any] = [
                                                    "Message" : "ZIGSDK-Payment Failed \(respose?.xErrorCode ?? "") - \(respose?.xError ?? "")"
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
                                                "Message" : "ZIGSDK-Payment Failed \(respose?.xErrorCode ?? "") - \(respose?.xError ?? "")"
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
                                        "Message" : "ZIGSDK-Payment Failed \(respose?.xErrorCode ?? "") - \(respose?.xError ?? "")"
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
                                    "Message" : "ZIGSDK-Payment Failed \(respose?.xErrorCode ?? "") - \(respose?.xError ?? "")"
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
                            "Message" : "ZIGSDK-Payment Failed \(respose?.xErrorCode ?? "") - \(respose?.xError ?? "")"
                        ]
                        self.failureHandler?(false,jsonObject)
                    }
                }
                else{
                    ReferanceViewModel.sharedInstance.addReferance(Amount: AmountCent, Transcationtype: "", Currency: "USD", Txn_id: respose?.xRefNum ?? "", Correlation_id: "", Bankmessage: respose?.xError ?? "", Txnstatus: "false", Gatewayrespcode: respose?.xErrorCode ?? "", Retrival_ref_no: "", Specialpayment: "iOS Payment", CardType: respose?.xCardType ?? "", MaskedCardNumber: respose?.xMaskedCardNumber ?? "", Txntag: "\(mercentId)", EmailID: userDetails.emailId, Phone: "", UserName: userDetails.userName, Userid: "\(userDetails.UserId)", Txn_ref_no: mercentId, Error_code: respose?.xErrorCode ?? "", Error_description: respose?.xError ?? "", Status_code: respose?.xAuthCode ?? "", Fareid: "0", Wallet: true, AuthKey: userDetails.AuthKey) { responses, success in
                        if success{
                            LoaderUtility.shared.hideLoader()
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                            let jsonObject: [String: Any] = [
                                "Message" : "ZIGSDK-Payment Failed \(respose?.xErrorCode ?? "") - \(respose?.xError ?? "")"
                            ]
                            self.failureHandler?(false,jsonObject)
                        }
                        else{
                            LoaderUtility.shared.hideLoader()
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                            let jsonObject: [String: Any] = [
                                "Message" : "ZIGSDK-Payment Failed \(respose?.xErrorCode ?? "") - \(respose?.xError ?? "")"
                            ]
                            self.failureHandler?(false,jsonObject)
                        }
                    }
                }
            }
        }
        else{
            let jsonObject: [String: Any] = [
                "Message" : "ZIGSDK-No internet connection"
            ]
            self.failureHandler?(false,jsonObject)
        }
    }
    @IBAction func alertCancle(_ sender: Any) {
        backgroundView.isHidden = true
        alertView.isHidden = true
    }
    func isExpired(monthYear: String) -> Bool {
        let today = Date()
        let calendar = Calendar.current

        let currentYear = calendar.component(.year, from: today) % 100
        let currentMonth = calendar.component(.month, from: today)
        let regex = #"^(0[1-9]|1[0-2])/(\d{2})$"#
        let matches = monthYear.range(of: regex, options: .regularExpression)
        guard matches != nil else { return false }
        let components = monthYear.split(separator: "/")
        guard components.count == 2,
              let month = Int(components[0]),
              let year = Int(components[1]) else {
            return false
        }
        guard (1...12).contains(month) else { return false }

        let maxValidYear = (calendar.component(.year, from: today) + 30) % 100
        guard year >= currentYear && year <= maxValidYear else { return false }
        if year > currentYear || (year == currentYear && month >= currentMonth) {
            return true
        }

        return false
    }
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars: Set<Character> =
        Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return String(text.filter { okayChars.contains($0) })
    }
    
}
extension String {
    func chunkFormatted(withChunkSize chunkSize: Int = 4,
        withSeparator separator: Character = "-") -> String {
        return filter { $0 != separator }.chunk(n: chunkSize)
            .map { String($0) }.joined(separator: String(separator))
    }
    func exprieFormatted(withChunkSize chunkSize: Int = 2,
        withSeparator separator: Character = "/") -> String {
        return filter { $0 != separator }.chunk(n: chunkSize)
            .map { String($0) }.joined(separator: String(separator))
    }
}
extension Collection {
    public func chunk(n: IndexDistance) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}


extension UIView {

    func startRotating(duration: CFTimeInterval = 3, repeatCount: Float = Float.infinity, clockwise: Bool = true) {

        if self.layer.animation(forKey: "transform.rotation.z") != nil {
            return
        }

        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        let direction = clockwise ? 1.0 : -1.0
        animation.toValue = NSNumber(value: .pi * 2 * direction)
        animation.duration = duration
        animation.isCumulative = true
        animation.repeatCount = repeatCount
        self.layer.add(animation, forKey: "transform.rotation.z")
    }

    func stopRotating() {

        self.layer.removeAnimation(forKey: "transform.rotation.z")

    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
