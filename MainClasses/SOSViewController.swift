//
//  SOSViewController.swift
//  SwiftFramework
//
//  Created by apple on 30/03/24.
//

import UIKit
import CoreLocation
import AVFoundation
import CocoaMQTT
class SOSViewController: UIViewController,CLLocationManagerDelegate,AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var sosCurrentLocationImg: UIImageView!
    @IBOutlet weak var sosCurrentLocation: UILabel!
    @IBOutlet weak var sosImg: UIImageView!
    @IBOutlet weak var sosImgView: UIView!
    @IBOutlet weak var sosSubTitle: UILabel!
    @IBOutlet weak var sosTitle: UILabel!
    var successHandler: ((Bool, String?) -> Void)?
    var failureHandler: ((Bool, String?) -> Void)?
    static var title = ""
    static var subtitle = ""
    static var mainImage = ""
    static var backroundColor = ""
    static var beaconMessage = ""
    static var textColor = ""
    static var beaconfound : Bool = false
    static var boolCheck = ""
    static var messageCheck = 0
    static var imageUrl = ""
    let geocoder = CLGeocoder()
    var synth = AVSpeechSynthesizer()
    var locationManager = CLLocationManager()
    let receiver = receiverNotification()
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupUI()
        if QmVhdm9uUmFuZ2luZw.beaconCheck{
            SoSandStopFeature()
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.dismissViewController()
                self.failureHandler?(false,"No Active device near you")
            }
        }
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        overrideUserInterfaceStyle = .light
    }
    
    func SetupUI()
    {
        SOSViewController.title = SOSViewController.title.isEmpty ? "SOS Request" : SOSViewController.title
        SOSViewController.subtitle = SOSViewController.subtitle.isEmpty ? "Your SOS request has been delivered to the driver" : SOSViewController.subtitle
        SOSViewController.textColor = SOSViewController.textColor.isEmpty ? "#FFFFFF" : SOSViewController.textColor
        SOSViewController.backroundColor = SOSViewController.backroundColor.isEmpty ? "#FF0000" : SOSViewController.backroundColor
        SOSViewController.mainImage = "SosRequest"
        SOSViewController.imageUrl = SOSViewController.imageUrl.isEmpty ? "https://www.zed.digital/img/app/sos.png" : SOSViewController.imageUrl
        sosTitle.text = SOSViewController.title
        sosSubTitle.text = SOSViewController.subtitle
        sosTitle.textColor = UIColor(hex: SOSViewController.textColor)
        sosSubTitle.textColor = UIColor(hex: SOSViewController.textColor)
        sosCurrentLocation.textColor = UIColor(hex: SOSViewController.textColor)
        view.backgroundColor = UIColor(hex:SOSViewController.backroundColor )
        sosImgView.backgroundColor = UIColor(hex: SOSViewController.backroundColor)
        sosImg.backgroundColor = UIColor(hex: SOSViewController.backroundColor)
        sosCurrentLocationImg.backgroundColor = UIColor(hex: SOSViewController.backroundColor)
        sosCurrentLocationImg.tintColor = UIColor(hex:SOSViewController.textColor)
        loadImage(from: SOSViewController.imageUrl) { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.sosImg.image = image
            } else {
                
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                
                return
            }
            if let placemark = placemarks?.first {
                let formattedAddress = "\(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
                self.sosCurrentLocation.text = formattedAddress
            } else {
            
            }
        }
    }
    func SoSandStopFeature(){
        if isReachable(){
            let dataString = SOSViewController.beaconMessage
            let message = CocoaMQTTMessage(topic:"\(beaconLogData.macaddress)/nfc" , string: dataString)
            CocoaMQTTManager.shared.publish(message: message) { success, ackMessage, id in
                if success {
                    
                    SDKViewModel.sharedInstance.limitchange(count: 1, userid: userDetails.UserId, typeValidate: StopViewController.beaconMessage, ticketID: "300", ValidationMode: QmVhdm9uUmFuZ2luZw.validationMode, BatteryHealth: "\(benchMarkData.batteryPercent)", MobileModel: "\(benchMarkData.phoneModel)", TypeMobile: "iOS", ConfigAPITime: benchMarkData.cofigApiResponseTime, ValidationDistance: beaconLogData.validationFeetDistance, ibeaconStatus: "3", ConfigForegroundFeet: beaconLogData.beaconValidationFeet, TimeTaken: QmVhdm9uUmFuZ2luZw.totalValidationtime, clientId: userDetails.clientId, UserName: userDetails.userName) { response, success in
                        if success{
                            let jsonObject: [String: Any] = [
                                "TicketId" : "SOS Request",
                                "Message" : "Your SOS request has been delivered to the driver"
                            ]
                            self.receiver.senderFunction(jsonObject: jsonObject)
                            self.successHandler?(success,"Message sent successfully")
                            Trigger().scheduleNotification(title: "SOS", body: "Your SOS request has been delivered to the driver")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                self.dismissViewController()
                                let text = "Your SOS request has been delivered to the driver succesfully."
                                let utterance = AVSpeechUtterance(string: text)
                                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                                utterance.rate = 0.5
                                self.synth.speak(utterance)
                                if response?.Message == "OK" && response?.LimitStatus == true && response?.BalanceLimit ?? 0 > 0 {
                                }
                                else {
                                    self.stopRangingBeacons()
                                }
                            }
                        }
                        else {
                            
                        }
                    }
                }else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        self.failureHandler?(success,"mqtt message delivery failed:\(ackMessage ?? "")")
                        self.dismissViewController()
                    }
                }
            }
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.failureHandler?(false,"SOS request not Send to beacon,Because no internet connection")
                self.dismissViewController()
            }
        }
    }
    public func stopRangingBeacons() {
        stopFunction()
    }

    private func stopFunction() {
        let clientIdentifier = "Validationbeacon"
        guard let uuid = UUID(uuidString: MqttValidationData.uuid) else {
            return
        }
        
        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: clientIdentifier)
        locationManager.stopRangingBeacons(in: beaconRegion)
        locationManager.stopMonitoring(for: beaconRegion)
    }
    func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func BackAct(_ sender: Any) {
        dismissViewController()
    }
    
}
