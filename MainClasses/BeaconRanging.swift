//
//  BeaconRanging.swift
//  SwiftFramework
//
//  Created by apple on 29/03/24.
//

import Foundation
import CoreLocation
import RealmSwift
import Alamofire
import UserNotifications
import BackgroundTasks
import AVFoundation
import CocoaMQTT
class QmVhdm9uUmFuZ2luZw:NSObject, bearonRangingDelegate, CLLocationManagerDelegate,AVSpeechSynthesizerDelegate {
    static var illegalCheck = 0
    var currentlat = 0.0
    var currentLong = 0.0
    var blePermissionValue = "false"
    var locationPermissionValue = "false"
    var realmTotal = 0
    var activeTicketCount = 0
    var newTicketCount = 0
    var validateTicketCount = 0
    var macAddress = "04:e9:e5:16:f6:3d"
    var validationflag = ""
    let realm = try! Realm()
    let present = TicketMethods()
    var synth = AVSpeechSynthesizer()
    static var beaconStatus = 0
    static var macAddress = ""
    static var major = 0
    static var minor = 0
    static var beaconCheck = false
    static var beaconBool = false
    static var userLimitBool = false
    static var limited = 0
    static var logEnable = true
    static var locationManager = CLLocationManager()
    private var beaconRegion: CLBeaconRegion!
    var mqttManager : CocoaMQTTManager?
    var rssiValues: [RssiData] = []
    static var timer: Timer!
    static var iBeaconList = [IBeaconToll]()
    static var validationMode = false
    static var batteryPercentage = 0
    static var fastLaneBeacon = 540
    static var slowLaneBeacon = 780
    static var mqttValidationStart = 0
    static var mqttValidationEnd = 0
    static var totalValidationtime = 0
    static var beverageMajor = 0
    let receiver = receiverNotification()
    var inOutConfigList = [InOutConfig]()
    var sendOutDataTimer: Timer?
    override init() {
        super.init()
        setupLocationManager()
    }
    private func setupLocationManager() {
        QmVhdm9uUmFuZ2luZw.locationManager.delegate = self
        QmVhdm9uUmFuZ2luZw.locationManager.requestWhenInUseAuthorization()
        QmVhdm9uUmFuZ2luZw.locationManager.allowsBackgroundLocationUpdates = true
        QmVhdm9uUmFuZ2luZw.locationManager.showsBackgroundLocationIndicator = true
        QmVhdm9uUmFuZ2luZw.locationManager.pausesLocationUpdatesAutomatically = false
    }
    internal func ZIGSDKInit(authKey : String, enableLog : Bool = false,completion: @escaping (Bool, String?) -> Void) {
        let startTime = DispatchTime.now()
        if isReachable(){
            SDKViewModel.sharedInstance.configApi(authKey: authKey) { response, success in
                if success{
                    let endTime = DispatchTime.now()
                    let responseTimeNanos = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                    let responseMilleSeconds = responseTimeNanos / 1_000_000
                    let responseSeconds = Double(responseTimeNanos) / 1_000_000_000
                    benchMarkData.cofigApiResponseTime = Int(responseMilleSeconds)
                    userDetails.clientId = response?.clientId ?? 0
                    userDetails.clientName = response?.clientName ?? ""
                    userDetails.AuthKey = authKey
                    sdkLog.shared.printLog(message: "ZEDSDK initialized successfully")
                    if response?.message != "Invalid Token"{
                        QmVhdm9uUmFuZ2luZw.slowLaneBeacon = response?.SlowLaneMajor ?? 0
                        QmVhdm9uUmFuZ2luZw.fastLaneBeacon = response?.FastLaneMajor ?? 0
                        if response?.LimitStatus ?? false{
                            if response?.validationLimit ?? 0 != 0{
                                // beacon details
                                TicketMethods.sharedInstance.deleteAllTickets { success, responce in
                                    if success{
                                        TicketMethods.sharedInstance.GetTicket { success, responsevalue in
                                            if success{
                                                QmVhdm9uUmFuZ2luZw.locationManager.startUpdatingLocation()
                                                QmVhdm9uUmFuZ2luZw.locationManager.showsBackgroundLocationIndicator = true
                                                QmVhdm9uUmFuZ2luZw.locationManager.allowsBackgroundLocationUpdates = true
                                                QmVhdm9uUmFuZ2luZw.locationManager.pausesLocationUpdatesAutomatically = false
                                                QmVhdm9uUmFuZ2luZw.locationManager.requestAlwaysAuthorization()
                                                QmVhdm9uUmFuZ2luZw.logEnable = enableLog
                                                QmVhdm9uUmFuZ2luZw.userLimitBool = response?.LimitStatus ?? false
                                                QmVhdm9uUmFuZ2luZw.limited = response?.validationLimit ?? 0
                                                QmVhdm9uUmFuZ2luZw.beaconStatus = response?.ibeacon_Status ?? 0
                                                QmVhdm9uUmFuZ2luZw.beverageMajor = response?.Beveragemajor ?? 0
                                                
                                                //Mqtt Details
                                                MqttValidationData.userName = response?.mqttUserName ?? ""
                                                MqttValidationData.password = response?.mqttPassword ?? ""
                                                MqttValidationData.userid = response?.clientId ?? 0
                                                MqttValidationData.mqttHostUrl = response?.MqttUrl ?? ""
                                                MqttValidationData.mqttPort = response?.mqttPortNumber ?? 1833
                                                MqttValidationData.personalUserName = response?.clientName ?? ""
                                                MqttValidationData.distance = response?.distance ?? ""
                                                MqttValidationData.txPower = response?.tx_power ?? ""
                                                MqttValidationData.uuid = response?.beaconUuid ?? ""
                                                
                                                //Features Status.
                                                featureStatus.beverageValidation = response?.Beveragestatus ?? false
                                                featureStatus.tollValidation = response?.Tollstatus ?? false
                                                featureStatus.WalletEnableStatus = response?.WalletEnableStatus ?? false
                                                featureStatus.TicketValidationStatus = response?.TicketValidationStatus ?? false
                                                
                                                // userdetails
                                                
                                                
                                                if featureStatus.TicketValidationStatus || featureStatus.beverageValidation || featureStatus.tollValidation{
                                                    let tollArray = response?.tollBeaconList ?? []
                                                    if tollArray.count > 0 {
                                                        QmVhdm9uUmFuZ2luZw.iBeaconList.removeAll()
                                                        for tollData in tollArray {
                                                            QmVhdm9uUmFuZ2luZw.iBeaconList.append(IBeaconToll(name: tollData.name ?? "", laneType: tollData.laneType ?? "", major: tollData.major ?? 0, minor: tollData.minor ?? 0, deviceID: tollData.deviceID ?? "", mqttMac: tollData.mqttMac ?? "", validationFeetiOS: Double(tollData.validationFeetiOS ?? Int(0.0)), MeasureValueiOS: tollData.MeasureValueiOS ?? 0, beaconA_ID: tollData.deviceID ?? ""))
                                                        }
                                                        guard CLLocationManager.isRangingAvailable() else {
                                                            sdkLog.shared.printLog(message: "Beacon ranging is not available.")
                                                            return
                                                        }
                                                        self.mqttManager = CocoaMQTTManager.shared
                                                        self.startScanning()
                                                        completion(success,"Your Ticket Feature has been Enabled")
                                                    }
                                                    else {
                                                        completion(false,"MAC address was not found, please contact admin to add MAC address with error code 1001")
                                                        sdkLog.shared.printLog(message: "MAC address was not found, please contact admin to add MAC address with error code 1001")
                                                    }
                                                }
                                                else if featureStatus.WalletEnableStatus{
                                                    completion(true,"Your Wallet Feature has been Enabled")
                                                }
                                                else{
                                                    completion(false,"All features are Blocked Contact Admin")
                                                }
                                            }
                                            else{
                                                QmVhdm9uUmFuZ2luZw.userLimitBool = false
                                                completion(success,"Your limit has been exceeded. Please contact the admin")
                                                PresenterImpl().showAlert(title: "Your limit has been exceeded. Please contact the admin")
                                            }
                                        }
                                    }
                                    else{
                                        completion(false, "Something went wrong")
                                    }
                                    
                                }
                            }
                            else{
                                QmVhdm9uUmFuZ2luZw.userLimitBool = false
                                completion(success,"Your limit has been exceeded. Please contact the admin")
                                PresenterImpl().showAlert(title: "Your limit has been exceeded. Please contact the admin")
                            }
                        }
                        else{
                            QmVhdm9uUmFuZ2luZw.userLimitBool = false
                            completion(success,"Your limit has been exceeded. Please contact the admin")
                            PresenterImpl().showAlert(title: "Your limit has been exceeded. Please contact the admin")
                        }
                    }
                    else{
                        completion(success,"Security key is invalid or unauthorized, please contact admin")
                        PresenterImpl().showAlert(title: "Security key is invalid or unauthorized, please contact admin")
                    }
                }
                else{
                    print("API Failed======>")
                    let endTime = DispatchTime.now()
                    let responseTimeNanos = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                    let responseMilleSeconds = responseTimeNanos / 1_000_000
                    let responseSeconds = Double(responseTimeNanos) / 1_000_000_000
                    benchMarkData.cofigApiResponseTime = Int(responseMilleSeconds)
                    sdkLog.shared.printLog(message: "Security key is invalid or unauthorized, please contact admin")
                    completion(success,"Security key is invalid or unauthorized, please contact admin")
                    PresenterImpl().showAlert(title: "Security key is invalid or unauthorized, please contact admin")
                }
            }
        }
        else{
            completion(false,"No internet Connection!")
        }
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.stopSendingOutData()
    }
    func startScanning(){
        let clientIdentifiler = "Validationbeacon"
        print("MqttValidationData.uuid---->",MqttValidationData.uuid)
        let uuid = UUID(uuidString:MqttValidationData.uuid)!
        self.beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: clientIdentifiler)
        QmVhdm9uUmFuZ2luZw.locationManager.startRangingBeacons(in: self.beaconRegion)
    }
    public static func stopRangingBeacons() {
        let clientIdentifier = "Validationbeacon"
        guard let uuid = UUID(uuidString: MqttValidationData.uuid) else {
            print("Invalid UUID string")
            return
        }
        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: clientIdentifier)
        QmVhdm9uUmFuZ2luZw.locationManager.stopRangingBeacons(in: beaconRegion)
    }
    internal func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let loc = manager.location?.coordinate
        currentlat = loc?.latitude ?? 0.0
        currentLong = loc?.longitude ?? 0.0
        sdkLog.shared.printLog(message: "Scan found nearby devices")
        print("BeaconData====>",beacons)
        if beacons.count > 0{
            for beacon in beacons {
                updateDistance(beacon.proximity, locationCo: loc!, RssiValue: beacon.rssi, Meterint: beacon.accuracy, major: Int(truncating: beacon.major), Minor: Int(truncating: beacon.minor), proximityVle: beacon.proximity.rawValue, uuid: "\(beacon.uuid)")
                beaconLogData.rssi = "\(beacon.rssi)"
                beaconLogData.uuid = "\(beacon.uuid)"
                beaconLogData.minor = "\(Int(truncating: beacon.minor))"
                beaconLogData.major = "\(Int(truncating: beacon.major))"
                beaconLogData.proximity = "\(beacon.proximity.rawValue)"
                beaconLogData.range = "far"
                beaconLogData.bleValue = "\(blePermissionValue)"
                beaconLogData.locationValue = "\(locationPermissionValue)"
            }
        }
        else{
            QmVhdm9uUmFuZ2luZw.beaconCheck = false
            QmVhdm9uUmFuZ2luZw.beaconBool = false
            sdkLog.shared.printLog(message: "Scan failed to find nearby devices ")
        }
    }
    private func updateDistance(_ distance: CLProximity,locationCo:CLLocationCoordinate2D,RssiValue:Int,Meterint:Double,major:Int,Minor:Int,proximityVle : Int,uuid : String) {
        beaconLogData.rssi = "\(RssiValue)"
        beaconLogData.proximity = "\(proximityVle)"
        beaconLogData.bleValue = blePermissionValue
        beaconLogData.locationValue = locationPermissionValue
        if featureStatus.tollValidation {
            if RssiValue != 0 {
                let distance = calculateDistance(rssi: RssiValue, measurePower: self.ZmluZE1lYXN1cmVWYWx1ZQ(minor: Minor) ?? 0, txPower: Double(MqttValidationData.txPower) ?? 0.0, configDistance: Double(MqttValidationData.distance) ?? 0.0) //=======> Calculate a Distance
                
                let beaconInfo = RssiData(rssi: RssiValue, major: major, minor: Minor, distance: distance, uuid: uuid) // =====> Stored RSSI data into one array.
                QmVhdm9uUmFuZ2luZw.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    // var totalTicketCountForMQTT = 1
                    if !self.rssiValues.isEmpty {
                        var backup = self.rssiValues
                        self.rssiValues.removeAll()
                        self.Y2FsY3VsYXRlVG9sbHM(scanResultList: backup) { scanResultFinal in
                            let fastLaneData = scanResultFinal.filter { $0.lane == "FAST LANE" && $0.distance <= $0.validationFeet && $0.distance != 0.0 }
                            let shortestFastLaneData = fastLaneData.min(by: { $0.distance < $1.distance }) // find nearest beacon using distance
                            
                            let slowLaneData = scanResultFinal.filter { $0.lane != "FAST LANE" && $0.distance <= $0.validationFeet && $0.distance != 0.0 }
                            let shortestSlowLaneData = slowLaneData.min(by: { $0.distance < $1.distance }) // find nearest beacon using distance
                            
                            
                            var scanResultFinalCut: RssiDataToll? = nil
                            if let mac = shortestSlowLaneData?.mac, !mac.isEmpty {
                                scanResultFinalCut = shortestSlowLaneData
                            } else if let mac = shortestFastLaneData?.mac, !mac.isEmpty {
                                scanResultFinalCut = shortestFastLaneData
                            }
                            if scanResultFinalCut != nil {
                                beaconLogData.range = "far"
                                beaconLogData.major = "\(scanResultFinalCut?.major ?? 0)"
                                beaconLogData.minor = "\(scanResultFinalCut?.minor ?? 0)"
                                beaconLogData.uuid = "\(scanResultFinalCut?.uuid ?? "")"
                                beaconLogData.macaddress = "\(scanResultFinalCut?.mac ?? "")"
                                beaconLogData.validationFeetDistance = Int(scanResultFinalCut?.distance ?? 0.0)
                                beaconLogData.beaconValidationFeet = "\(scanResultFinalCut?.validationFeet ?? 0)"
                                self.ticketCounter()
                            }
                            backup.removeAll()
                        }
                    } else {
                        print("rssiValues is empty, nothing to process")
                    }
                }
                self.rssiValues.append(beaconInfo)
            }
            else {
                print("toll1233: no rssi")
            }
        }
        else {
            switch distance {
            case .unknown:
                QmVhdm9uUmFuZ2luZw.beaconCheck = false
                QmVhdm9uUmFuZ2luZw.beaconBool = false
                print("BeconFounding-unknown=====>",QmVhdm9uUmFuZ2luZw.beaconCheck)
            case .far:
                QmVhdm9uUmFuZ2luZw.beaconCheck = true
                print("BeconFounding-Far=====>",QmVhdm9uUmFuZ2luZw.beaconCheck)
                if QmVhdm9uUmFuZ2luZw.beaconStatus == 3{
                    print("BeaconList=====>",QmVhdm9uUmFuZ2luZw.iBeaconList)
                    for list in QmVhdm9uUmFuZ2luZw.iBeaconList{
                        if major == 102 && Minor == list.minor{
                            print("Beverage Validation",major,Minor,QmVhdm9uUmFuZ2luZw.beaconStatus)
                            beaconLogData.macaddress = list.mqttMac
                        }
                        else if major == list.major && Minor == list.minor{
                            print("TicketValidation=====>far1=======>",major,Minor,QmVhdm9uUmFuZ2luZw.beaconStatus)
                            beaconLogData.macaddress = list.mqttMac
                            ticketCounter()
                        }
                        else{
                            print("TicketValidation=====>far109=======>",major,Minor,QmVhdm9uUmFuZ2luZw.beaconStatus)
                        }
                    }
                }
            case .near:
                QmVhdm9uUmFuZ2luZw.beaconCheck = true
                print("BeconFounding-Near=====>",QmVhdm9uUmFuZ2luZw.beaconCheck)
                if QmVhdm9uUmFuZ2luZw.beaconStatus == 2 {
                    for list in QmVhdm9uUmFuZ2luZw.iBeaconList{
                        if major == 102{
                            print("Beverage Validation",major,Minor,QmVhdm9uUmFuZ2luZw.beaconStatus)
                            beaconLogData.macaddress = list.mqttMac
                        }
                        else if major == 100{
                            if major == list.major && Minor == list.minor{
                                print("TicketValidation=====>Near=======>",major,Minor,QmVhdm9uUmFuZ2luZw.beaconStatus)
                                beaconLogData.macaddress = list.mqttMac
                                ticketCounter()
                            }
                        }
                    }
                }
            case .immediate:
                QmVhdm9uUmFuZ2luZw.beaconCheck = true
                print("BeconFounding-Immediate=====>",QmVhdm9uUmFuZ2luZw.beaconCheck)
                if QmVhdm9uUmFuZ2luZw.beaconStatus == 1{
                    for list in QmVhdm9uUmFuZ2luZw.iBeaconList{
                        if major == 102{
                            print("Beverage Validation",major,Minor,QmVhdm9uUmFuZ2luZw.beaconStatus)
                            beaconLogData.macaddress = list.mqttMac
                        }
                        else if major == 100{
                            if major == list.major && Minor == list.minor{
                                print("TicketValidation=====>immediate=======>",major,Minor,QmVhdm9uUmFuZ2luZw.beaconStatus)
                                beaconLogData.macaddress = list.mqttMac
                                ticketCounter()
                            }
                        }
                    }
                }
                break
            @unknown default:
                QmVhdm9uUmFuZ2luZw.beaconBool = false
                QmVhdm9uUmFuZ2luZw.beaconCheck = false
                stopSendingOutData()
                break
            }
        }
    }
    func Y2FsY3VsYXRlVG9sbHM(scanResultList: [RssiData], callback: @escaping ([RssiDataToll]) -> Void) {
        do {
            var fastLaneResults = [RssiData]()
            var slowLaneResults = [RssiData]()
            //   var bevereageResults = [RssiData]()
            fastLaneResults.removeAll()
            slowLaneResults.removeAll()
            for rssiData in scanResultList {
                if rssiData.distance != 0.0 {
                    if rssiData.major == QmVhdm9uUmFuZ2luZw.fastLaneBeacon {
                        fastLaneResults.append(rssiData)
                    } else if rssiData.major == QmVhdm9uUmFuZ2luZw.slowLaneBeacon {
                        slowLaneResults.append(rssiData)
                    }
                    //                    else if rssiData.major == QmVhdm9uUmFuZ2luZw.beverageMajor {
                    //                        bevereageResults.append(rssiData)
                    //                    }
                }
            }
            var findShortestSlowLane = ZmluZExvd2VzdEF2ZXJhZ2VEaXN0YW5jZVJzc2lEYXRh(rssiList: slowLaneResults)
            var findShortestFastlane = ZmluZExvd2VzdEF2ZXJhZ2VEaXN0YW5jZVJzc2lEYXRh(rssiList: fastLaneResults)
            //  var beverageShortestLane = ZmluZExvd2VzdEF2ZXJhZ2VEaXN0YW5jZVJzc2lEYXRh(rssiList: bevereageResults)
            
            if findShortestSlowLane == nil {
                findShortestSlowLane = RssiDataToll(major: 100, minor: 0, distance: 200.0, mac: "", lane: "", validationFeet: 0, uuid: "",tollBeaconID: "")
            }
            
            if findShortestFastlane == nil {
                findShortestFastlane = RssiDataToll(major: 100, minor: 0, distance: 200.0, mac: "", lane: "", validationFeet: 0, uuid: "",tollBeaconID: "")
            }
            //
            //            if beverageShortestLane == nil {
            //                beverageShortestLane = RssiDataToll(major: 100, minor: 0, distance: 200.0, mac: "", lane: "", validationFeet: 0, uuid: "",tollBeaconID: "")
            //            }
            //
            
            let fastSlowList = [findShortestSlowLane!, findShortestFastlane!]
            callback(fastSlowList)
            
        } catch {
            
        }
    }
    
    func ZmluZExvd2VzdEF2ZXJhZ2VEaXN0YW5jZVJzc2lEYXRh(rssiList: [RssiData]) -> RssiDataToll? {
        let groupedByMinor = Dictionary(grouping: rssiList, by: { $0.minor })
        var averagedList = [RssiDataToll]()
        for (minor, dataList) in groupedByMinor {
            let averageDistance = dataList.reduce(0.0) { $0 + $1.distance } / Double(dataList.count)
            if let beacon = QmVhdm9uUmFuZ2luZw.iBeaconList.first(where: { $0.minor == minor }) {
                averagedList.append(RssiDataToll(
                    major: beacon.major,
                    minor: minor,
                    distance: averageDistance,
                    mac: beacon.mqttMac,
                    lane: beacon.name,
                    validationFeet: beacon.validationFeetiOS, uuid: "",
                    tollBeaconID: beacon.beaconA_ID
                ))
            }
            else{
                
            }
        }
        return averagedList.min(by: { $0.distance < $1.distance })
    }
    
    func ZmluZE1lYXN1cmVWYWx1ZQ(minor: Int) -> Int? {
        let findMeasure = QmVhdm9uUmFuZ2luZw.iBeaconList.first { $0.minor == minor }
        return findMeasure?.MeasureValueiOS
    }
    
    func calculateDistance(rssi: Int, measurePower: Int, txPower: Double, configDistance: Double) -> Double {
        if rssi < 0 {
            let iRssi = abs(rssi)
            let iMeasurePower = abs(measurePower)
            let power = (Double(iRssi) - Double(iMeasurePower)) / (txPower * 2.0)
            let distance = pow(10.0, power) * configDistance
            return distance
        }
        else{
            return 300
        }
    }
    func ticketCounter() {
        activeTicketCount = 0
        newTicketCount = 0
        realmTotal = 0
        validateTicketCount = 0
        var isAppInBackground: Bool {
            return UIApplication.shared.applicationState == .background
        }
        
        self.startScanning()
        QmVhdm9uUmFuZ2luZw.validationMode = isAppInBackground
        let TicketRealm = self.realm.objects(TicketRealmMethod.self)
        let activateTicket = self.realm.objects(TicketRealmMethod.self).filter("TicketStatus == 2")
        let validateTicket = self.realm.objects(TicketRealmMethod.self).filter("TicketStatus == 3")
        let newTicket = self.realm.objects(TicketRealmMethod.self).filter("TicketStatus == 1")
        activeTicketCount = activateTicket.count
        validateTicketCount = validateTicket.count
        newTicketCount = newTicket.count
        realmTotal = TicketRealm.count
        print("TicketValidation=====>far3=======>",QmVhdm9uUmFuZ2luZw.beaconStatus,activeTicketCount,validateTicketCount,newTicketCount)
        QmVhdm9uUmFuZ2luZw.mqttValidationStart = 0
        QmVhdm9uUmFuZ2luZw.mqttValidationEnd = 0
        QmVhdm9uUmFuZ2luZw.mqttValidationStart = Date().inMiliSeconds()
        
        if activeTicketCount == 0 && validateTicketCount == 0 && newTicketCount > 0{
            validationflag = "Autovalidation"
            QmVhdm9uUmFuZ2luZw.beaconCheck = true
            QmVhdm9uUmFuZ2luZw.beaconBool = true
            TicketVerityAuto()
        }
        else if activeTicketCount == 0 && validateTicketCount == 0 && newTicketCount == 0 {
            print("Illegal Data=====>")
            if QmVhdm9uUmFuZ2luZw.illegalCheck == 0 {
                QmVhdm9uUmFuZ2luZw.illegalCheck += 1
                validationflag = "Illegal"
                QmVhdm9uUmFuZ2luZw.beaconCheck = true
                QmVhdm9uUmFuZ2luZw.beaconBool = true
                print("Illegal Data1=====>")
                TicketIllegal()
            }
            else{
                QmVhdm9uUmFuZ2luZw.beaconCheck = true
                QmVhdm9uUmFuZ2luZw.beaconBool = true
            }
        }
        else{
            validationflag = "Validate"
            print("Validation1--->")
            QmVhdm9uUmFuZ2luZw.beaconCheck = true
            QmVhdm9uUmFuZ2luZw.beaconBool = true
            TicketValidation()
        }
    }
    func TicketIllegal(){
        if isReachable(){
            if validationflag == "Illegal" {
                print("Illegal Data2=====>")
                QmVhdm9uUmFuZ2luZw.checkbattery()
                self.inOutConfigList.removeAll()
                let date = GetcurrentDate(dateformat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                let config = InOutConfig(
                    routeId: "Illegal",
                    ticketId: 0,
                    message: "Illegal",
                    latitude: "\(self.currentlat)",
                    longitude: "\(self.currentLong)",
                    beaconId: beaconLogData.macaddress,
                    clientId: userDetails.clientId,
                    date: date,
                    userId: UserDefaults.standard.integer(forKey: "userId"),
                    accessToken: UserDefaults.standard.string(forKey: "AuthKey") ?? "",
                    isBibo: false,
                    isDriver: false,
                    tripId: "4",
                    Username: userDetails.userName,
                    EmailID: userDetails.emailId
                )
                self.inOutConfigList.append(config)
                let dataString = "301001"
                let message = CocoaMQTTMessage(topic:"\(beaconLogData.macaddress)/nfc" , string: dataString)
                CocoaMQTTManager.shared.publish(message: message) { success, ackMessage, id in
                    if success {
                        print("Illegal Data3=====>")
                        let jsonObject: [String: Any] = [
                            "TicketId" : "Illegal",
                            "Message" : "Successfully validate a Illegal Entry"
                        ]
                        self.receiver.senderFunction(jsonObject: jsonObject)
                        QmVhdm9uUmFuZ2luZw.mqttValidationEnd = Date().inMiliSeconds()
                        QmVhdm9uUmFuZ2luZw.totalValidationtime = QmVhdm9uUmFuZ2luZw.mqttValidationEnd - QmVhdm9uUmFuZ2luZw.mqttValidationStart
                        TicketViewModel.sharedInstance.ValidateTicket(ConfigList: self.inOutConfigList) { response, success in
                            if success{
                                print("ZIG-SDK-Illigal-Sended====>")
                            }
                            else{
                                print("ZIG-SDK-Illigal-Not-Sended====>")
                            }
                        }
                        
                        SDKViewModel.sharedInstance.limitchange(count: 1, userid: userDetails.UserId, typeValidate: "Illegal", ticketID: " ", ValidationMode: QmVhdm9uUmFuZ2luZw.validationMode, BatteryHealth: "\(benchMarkData.batteryPercent)", MobileModel: "\(benchMarkData.phoneModel)", TypeMobile: "iOS", ConfigAPITime: benchMarkData.cofigApiResponseTime, ValidationDistance: beaconLogData.validationFeetDistance, ibeaconStatus: "3", ConfigForegroundFeet: beaconLogData.beaconValidationFeet, TimeTaken: QmVhdm9uUmFuZ2luZw.totalValidationtime, clientId: userDetails.clientId, UserName: userDetails.userName) { response, success in
                            if success {
                                Trigger().scheduleNotification(title: "Illegal Entry", body: "You do not have any active tickets, Please buy a new ticket")
                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "Illegal", bundle: Bundle(for: OnboardingPresenterImpl.self))
                                    let illegalViewController = storyboard.instantiateViewController(withIdentifier: "IllegalViewController") as! IllegalViewController
                                    if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                                        illegalViewController.modalPresentationStyle = .fullScreen
                                        rootViewController.present(illegalViewController, animated: true, completion: nil)
                                    }
                                }
                                self.startScanning()
                                let text = "You do not have any active tickets, Please buy a new ticket"
                                SpeechSynthesizer.shared.speak(text: text)
                                
                                Api.sharedInstance.TicketLog(ticketID: "", Name: "", typeValidation: "Illegal", ibeaconStatus: "\(QmVhdm9uUmFuZ2luZw.beaconStatus)", sdkVersion: "1.0")
                                
                                if response?.Message == "OK" && response?.LimitStatus ?? false {
                                    self.startScanning()
                                }
                                else {
                                    QmVhdm9uUmFuZ2luZw.stopRangingBeacons()
                                    QmVhdm9uUmFuZ2luZw.beaconBool = false
                                    QmVhdm9uUmFuZ2luZw.timer?.invalidate()
                                    QmVhdm9uUmFuZ2luZw.timer = nil
                                    QmVhdm9uUmFuZ2luZw.userLimitBool = false
                                    PresenterImpl().showAlert(title: "Your limit has been exceeded. Please contact the admin")
                                }
                            }
                            else {
                                
                            }
                        }
                    }
                    else {
                        
                    }
                }
            }
        }
        else{
            let jsonObject: [String: Any] = [
                "Message" : "No Internet Connection"
            ]
            self.receiver.senderFunction(jsonObject: jsonObject)
        }
    }
    func TicketValidation(){
        if isReachable(){
            var dataString = ""
            var ticketId = ""
            var ticketCount = 0
            var agencyName = ""
            var TotalTicket = ""
            let date = GetcurrentDate(dateformat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            QmVhdm9uUmFuZ2luZw.checkbattery()
            let obj = self.realm.objects(TicketRealmMethod.self).filter("TicketStatus == 2")
            var value : Bool = false
            if realmTotal > 0 && validationflag == "Validate"{
                for realmdata in obj{
                    let NewTicketTicket_CountWithZero = String(format: "%03d", realmdata.Ticketcount);
                    dataString = "201\(NewTicketTicket_CountWithZero)#kamalesh#0#\(realmdata.TicketId)#03-20-2024 16:50#03-20-2024 19:50"
                    ticketId = "\(realmdata.TicketId)"
                    ticketCount = realmdata.Ticketcount
                    agencyName = "\(realmdata.RouteId)"
                }
                if dataString.isEmpty == false{
                    if isReachable(){
                        self.inOutConfigList.removeAll()
                        for realmdata in obj{
                            let config = InOutConfig(
                                routeId: realmdata.RouteId,
                                ticketId: realmdata.TicketId,
                                message: "IN",
                                latitude: "\(self.currentlat)",
                                longitude: "\(self.currentLong)",
                                beaconId: beaconLogData.macaddress,
                                clientId: userDetails.clientId,
                                date: date,
                                userId: UserDefaults.standard.integer(forKey: "userId"),
                                accessToken: UserDefaults.standard.string(forKey: "AuthKey") ?? "",
                                isBibo: false,
                                isDriver: false,
                                tripId: "4",
                                Username: userDetails.userName,
                                EmailID: userDetails.emailId
                            )
                            self.inOutConfigList.append(config)
                            
                            self.present.TicketStatusChange(ticketId: realmdata.TicketId, newIsActiveStatus: 3, completion: { success, response in
                                if success{
                                    value = true
                                }
                                else{
                                    value = false
                                }
                            })
                            ticketCount = realmdata.Ticketcount
                        }
                        let message = CocoaMQTTMessage(topic:"\(beaconLogData.macaddress)/nfc" , string: dataString)
                        CocoaMQTTManager.shared.publish(message: message) { success, ackMessage, id in
                            if success {
                                let jsonObject: [String: Any] = [
                                    "TicketId" : "\(ticketId)",
                                    "Message" : "Your Ticket Validated Successfully"
                                ]
                                self.receiver.senderFunction(jsonObject: jsonObject)
                                
                                QmVhdm9uUmFuZ2luZw.mqttValidationEnd = Date().inMiliSeconds()
                                
                                QmVhdm9uUmFuZ2luZw.totalValidationtime = QmVhdm9uUmFuZ2luZw.mqttValidationEnd - QmVhdm9uUmFuZ2luZw.mqttValidationStart
                                
                                TicketViewModel.sharedInstance.ValidateTicket(ConfigList: self.inOutConfigList) { response, success in
                                    if success{
                                        print("ZIG-SDK-OUT-Data=====>")
                                        self.startSendingOutDataEvery30Seconds { success, message in
                                            if success{
                                                print("ZIG-SDK-OUT-Sended---->",message)
                                            }
                                            else{
                                                print("ZIG-SDK-OUT-Not-Sended---->",message)
                                            }
                                        }
                                    }
                                    else{
                                        print("IN-Not-Data-Sended---->", response as Any)
                                    }
                                }
                                
                                
                                SDKViewModel.sharedInstance.limitchange(count: ticketCount, userid: userDetails.UserId, typeValidate: "Ticket", ticketID: "\(ticketId)", ValidationMode: QmVhdm9uUmFuZ2luZw.validationMode, BatteryHealth: "\(benchMarkData.batteryPercent)", MobileModel: "\(benchMarkData.phoneModel)", TypeMobile: "iOS", ConfigAPITime: benchMarkData.cofigApiResponseTime, ValidationDistance: beaconLogData.validationFeetDistance, ibeaconStatus: "3", ConfigForegroundFeet: beaconLogData.beaconValidationFeet, TimeTaken: QmVhdm9uUmFuZ2luZw.totalValidationtime, clientId: userDetails.clientId, UserName: userDetails.userName) { response, success in
                                    if success {
                                        
                                        Trigger().scheduleNotification(title: "Ticket Validate", body: "Your Ticket #\(ticketId) Validated Successfully")
                                        
                                        QRViewController.ticketStatus = "VALIDATE"
                                        QRViewController.ticketId = ticketId
                                        QRViewController.ticketExpiry = "#03-20-2024 16:50"
                                        QRViewController.startColor = "#96e6a1"
                                        QRViewController.endColor = "#009688"
                                        QRViewController.textColor = "#E53638"
                                        QRViewController.totalCount = "\(ticketCount)"
                                        QRViewController.agencyName = agencyName
                                        self.redirectToQRPage { success in
                                            if success{
                                                let text = "Your Ticket #\(ticketId) has been Validated Successfully"
                                                SpeechSynthesizer.shared.speak(text: text)
                                                if response?.Message == "OK" && response?.LimitStatus ?? false {
                                                    self.startScanning()
                                                }
                                                else {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                                        QmVhdm9uUmFuZ2luZw.stopRangingBeacons()
                                                        QmVhdm9uUmFuZ2luZw.beaconBool = false
                                                        QmVhdm9uUmFuZ2luZw.timer?.invalidate()
                                                        QmVhdm9uUmFuZ2luZw.timer = nil
                                                        QmVhdm9uUmFuZ2luZw.userLimitBool = false
                                                        PresenterImpl().showAlert(title: "Your limit has been exceeded. Please contact the admin")
                                                    }
                                                }
                                            }
                                            else{
                                                print("QR code failed")
                                            }
                                        }
                                    }
                                    else{
                                        print("Limit Api failed")
                                    }
                                }
                                
                            }
                            else {
                                Trigger().scheduleNotification(title: "Ticket Validate", body: "Your Ticket #\(ticketId) Not Validated")
                            }
                        }
                    }
                    else{
                        PresenterImpl().showAlert(title: "No internet connection")
                    }
                }
            }
        }
        else{
            let jsonObject: [String: Any] = [
                "Message" : "No Internet Connection"
            ]
            self.receiver.senderFunction(jsonObject: jsonObject)
        }
    }
    
    func TicketVerityAuto(){
        if isReachable(){
            var dataString = ""
            var ticketId = ""
            var ticketCount = 0
            var agencyName = ""
            let date = GetcurrentDate(dateformat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            QmVhdm9uUmFuZ2luZw.checkbattery()
            let obj = self.realm.objects(TicketRealmMethod.self).filter("TicketStatus == 1")
            var value: Bool = false
            if newTicketCount > 0 && validationflag == "Autovalidation" {
                ticketId = "\(obj[0].TicketId)"
                ticketCount = obj[0].Ticketcount
                agencyName = "\(obj[0].RouteId)"
                let NewTicketTicket_CountWithZero = String(format: "%03d", obj[0].Ticketcount)
                dataString = "201\(NewTicketTicket_CountWithZero)#kamalesh#0#\(obj[0].TicketId)#03-20-2024 16:50#03-20-2024 19:50"
                if !dataString.isEmpty {
                    if isReachable(){
                        self.inOutConfigList.removeAll()
                        let config = InOutConfig(
                            routeId: obj[0].RouteId,
                            ticketId: obj[0].TicketId,
                            message: "IN",
                            latitude: "\(self.currentlat)",
                            longitude: "\(self.currentLong)",
                            beaconId: beaconLogData.macaddress,
                            clientId: userDetails.clientId,
                            date: date,
                            userId: UserDefaults.standard.integer(forKey: "userId"),
                            accessToken: UserDefaults.standard.string(forKey: "AuthKey") ?? "",
                            isBibo: false,
                            isDriver: false,
                            tripId: "4",
                            Username: userDetails.userName,
                            EmailID: userDetails.emailId
                        )
                        self.inOutConfigList.append(config)
                        ticketCount = obj[0].Ticketcount
                        self.present.TicketStatusChange(ticketId: obj[0].TicketId, newIsActiveStatus: 3) { success, Message in
                            if success{
                                value = true
                            }
                            else{
                                value = false
                            }
                        }
                        let message = CocoaMQTTMessage(topic:"\(beaconLogData.macaddress)/nfc" , string: dataString)
                        CocoaMQTTManager.shared.publish(message: message) { success, ackMessage, id in
                            if success {
                                let jsonObject: [String: Any] = [
                                    "TicketId" : "\(ticketId)",
                                    "Message" : "Your Ticket Validated Successfully"
                                ]
                                self.receiver.senderFunction(jsonObject: jsonObject)
                                QmVhdm9uUmFuZ2luZw.mqttValidationEnd = Date().inMiliSeconds()
                                QmVhdm9uUmFuZ2luZw.totalValidationtime = QmVhdm9uUmFuZ2luZw.mqttValidationEnd - QmVhdm9uUmFuZ2luZw.mqttValidationStart
                                
                                TicketViewModel.sharedInstance.ValidateTicket(ConfigList: self.inOutConfigList) { response, success in
                                    if success{
                                        print("ZIG-SDK-OUT-Data=====>")
                                        self.startSendingOutDataEvery30Seconds { success, message in
                                            if success{
                                                print("ZIG-SDK-OUT-Sended---->",message)
                                            }
                                            else{
                                                print("ZIG-SDK-OUT-Not-Sended---->",message)
                                            }
                                        }
                                    }
                                    else{
                                        print("IN-Not-Data-Sended---->", response as Any)
                                    }
                                }
                                SDKViewModel.sharedInstance.limitchange(count: ticketCount, userid: userDetails.UserId, typeValidate: "Ticket", ticketID: "\(ticketId)", ValidationMode: QmVhdm9uUmFuZ2luZw.validationMode, BatteryHealth: "\(benchMarkData.batteryPercent)", MobileModel: "\(benchMarkData.phoneModel)", TypeMobile: "iOS", ConfigAPITime: benchMarkData.cofigApiResponseTime, ValidationDistance: beaconLogData.validationFeetDistance, ibeaconStatus: "3", ConfigForegroundFeet: beaconLogData.beaconValidationFeet, TimeTaken: QmVhdm9uUmFuZ2luZw.totalValidationtime, clientId: userDetails.clientId, UserName: userDetails.userName) { response, success in
                                    if success {
                                        Trigger().scheduleNotification(title: "Ticket Validate", body: "Your Ticket #\(ticketId) Validated Successfully")
                                        QRViewController.ticketStatus = "VALIDATE"
                                        QRViewController.ticketId = ticketId
                                        QRViewController.ticketExpiry = "#03-20-2024 16:50"
                                        QRViewController.startColor = "#96e6a1"
                                        QRViewController.endColor = "#009688"
                                        QRViewController.textColor = "#E53638"
                                        QRViewController.totalCount = "\(ticketCount)"
                                        QRViewController.agencyName = agencyName
                                        self.redirectToQRPage { success in
                                            if success{
                                                Api.sharedInstance.TicketLog(ticketID: ticketId, Name: "kamalesh", typeValidation: "AutoValidation", ibeaconStatus: "\(QmVhdm9uUmFuZ2luZw.beaconStatus)", sdkVersion: "1.0")
                                                let text = "Your Ticket #\(ticketId) has been Validated Successfully"
                                                SpeechSynthesizer.shared.speak(text: text)
                                                if response?.Message == "OK" && response?.LimitStatus ?? false {
                                                    self.startScanning()
                                                }
                                                else {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                                        QmVhdm9uUmFuZ2luZw.beaconBool = false
                                                        QmVhdm9uUmFuZ2luZw.stopRangingBeacons()
                                                        QmVhdm9uUmFuZ2luZw.timer?.invalidate()
                                                        QmVhdm9uUmFuZ2luZw.timer = nil
                                                        QmVhdm9uUmFuZ2luZw.userLimitBool = false
                                                        PresenterImpl().showAlert(title: "Your limit has been exceeded. Please contact the admin")
                                                    }
                                                }
                                            }
                                            else{
                                                print("QR code failed")
                                            }
                                        }
                                        
                                    }
                                    else{
                                        print("Limit api Failed")
                                    }
                                }
                            }
                            else {
                                Trigger().scheduleNotification(title: "Ticket Validate", body: "Your Ticket #\(ticketId) has not Validated")
                            }
                        }
                    }
                    else{
                        PresenterImpl().showAlert(title: "No internet connection")
                    }
                }
            }
        }
        else{
            let jsonObject: [String: Any] = [
                "Message" : "No Internet Connection"
            ]
            self.receiver.senderFunction(jsonObject: jsonObject)
        }
    }
    func sendOutData(completion:@escaping(Bool,String)->Void){
        if isReachable(){
            self.inOutConfigList.removeAll()
            let TicketRealm = self.realm.objects(TicketRealmMethod.self).filter("TicketStatus == 3")
            let date = GetcurrentDate(dateformat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            for realmdata in TicketRealm{
                let config = InOutConfig(
                    routeId: realmdata.RouteId,
                    ticketId: realmdata.TicketId,
                    message: "OUT",
                    latitude: "\(self.currentlat)",
                    longitude: "\(self.currentLong)",
                    beaconId: beaconLogData.macaddress,
                    clientId: userDetails.clientId,
                    date: date,
                    userId: UserDefaults.standard.integer(forKey: "userId"),
                    accessToken: UserDefaults.standard.string(forKey: "AuthKey") ?? "",
                    isBibo: false,
                    isDriver: false,
                    tripId: "4",
                    Username: userDetails.userName,
                    EmailID: userDetails.emailId
                )
                self.inOutConfigList.append(config)
            }
            TicketViewModel.sharedInstance.ValidateTicket(ConfigList: self.inOutConfigList) { response, success in
                if success{
                    print("IN-Data-Sended---->", response as Any)
                }
                else{
                    print("IN-Not-Data-Sended---->", response as Any)
                }
            }
        }
        else{
            let jsonObject: [String: Any] = [
                "Message" : "No Internet Connection"
            ]
            self.receiver.senderFunction(jsonObject: jsonObject)
        }
    }
    func redirectToQRPage(completion:@escaping(Bool)->Void) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "QRGenerator", bundle: Bundle(for: QRpresenter.self))
            guard let loginViewController = storyboard.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController else {
                print("Failed to instantiate QRViewController")
                return
            }
            loginViewController.modalPresentationStyle = .fullScreen
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootViewController = window.rootViewController {
                completion(true)
                rootViewController.present(loginViewController, animated: true, completion: nil)
            } else {
                completion(false)
                print("RootViewController not found")
            }
        }
    }
    public static func checkbattery(){
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        if batteryLevel >= 0.0 {
            benchMarkData.batteryPercent = Int(batteryLevel * 100)
            self.batteryPercentage = Int(batteryLevel * 100)
        } else {
            print("Unable to determine battery level.")
        }
    }
    func GetcurrentDate(dateformat:String)-> String{
        let Timestamp = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateformat
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        let utctimeStamp = dateFormatter.string(from: Timestamp)
        
        return utctimeStamp
    }
    func startSendingOutDataEvery30Seconds(completion:@escaping(Bool,String)->Void) {
        sendOutDataTimer?.invalidate()
        sendOutDataTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true, block: { _ in
            self.sendOutData { success, message in
                if success {
                    completion(true,"OutDataSended")
                } else {
                    completion(false,"OutDataNotSended")
                }
            }
        })
    }
    func stopSendingOutData() {
        sendOutDataTimer?.invalidate()
        sendOutDataTimer = nil
    }
}
