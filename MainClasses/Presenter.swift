import Foundation
import UIKit

public class ZIGSDK {
    static var sdkversion = 1.0
    private let presenterImpl: PresenterDelegate
    private let onboardingImpl: OnboardingDelegate
    private let QRGenerationImpl : QRRequestDelegate
    private let stopRequestImpl: StopRequestDelegate
    private let sosRequestImpl : SosRequestDelegate
    private let TicketImpl : TicketValidationDelegate
    private let beacon : bearonRangingDelegate
    private let needPermission : needPermissionDelegate
    private let ValidationProtocol : receiverDelegate
    private let addSDKWallet : addWalletDelegate
    private let zigWalletPayment : walletPaymentDelegate
    private let zigWalletBalance : ZIGSuperWalletBalanceDelegate
    private let BuyTicketAction: BuyTicketDelegate
    private let addUserInfo: GetUserInfoDelegate
    private let transAction: TransactionDelegate
    private let getFare : GetFareDelegate
    public init() {
        self.presenterImpl = PresenterImpl()
        self.onboardingImpl = OnboardingPresenterImpl()
        self.stopRequestImpl = StopRequestpresenter()
        self.sosRequestImpl = sosRequest()
        self.TicketImpl = TicketMethods()
        self.beacon = QmVhdm9uUmFuZ2luZw()
        self.QRGenerationImpl = QRpresenter()
        self.needPermission = NeedPermisson()
        self.ValidationProtocol = receiverNotification()
        self.addSDKWallet = ZIGSuperWallet()
        self.zigWalletPayment = ZIGwalletPaytment()
        self.zigWalletBalance = ZIGSuperWalletBalance()
        self.BuyTicketAction = BuyTicketMethod()
        self.addUserInfo = userInfoMethod()
        self.transAction = TransactionClass()
        self.getFare = GetFareClass()
    }
    
    public func triggerAlert(title : String) {
        presenterImpl.showAlert(title : title)
    }
    public func onboarding(title: String = "", subtitle: String = "", buttonAcceptText: String = "", buttonCancelText: String = "",textColor: String = "",backgroundColors: String = "",imageResourceId : String = "", completion: @escaping (Bool, String?) -> Void) {
        onboardingImpl.startOnboarding(title: title, subtitle: subtitle, buttonTitle: buttonAcceptText, buttonTitle1: buttonCancelText,imgUrl : imageResourceId,backgroundColors: backgroundColors,textColor: textColor) { success, message in
            completion(success, message)
        }
    }
    
    public func QRganeration(ticketStatus : String,ticketId : String,expiryDate : String,totalCount : String,startColorHex : String,endColorHex : String,textColorHex : String,agencyName: String){
        QRGenerationImpl.QRgeneration(ticketStatus : ticketStatus,ticketId : ticketId,expiryDate : expiryDate,totalCount : totalCount,startColorHex : startColorHex,endColorHex : endColorHex,textColorHex : textColorHex, agencyName: agencyName)
    }
    
    public func sendRequest(title: String = "", subtitle: String = "", backgroundColors: String = "", messageSendToDevice : String,imageResourceId : String = "",titleTextColor: String = "",subtitleTextColor: String = "", completion: @escaping (Bool, String?) -> Void){
        stopRequestImpl.StopRequest(title: title, subtitle: subtitle, backroundColor: backgroundColors,message:messageSendToDevice,imgURL : imageResourceId,titleTextColor: titleTextColor,subtitleTextColor: subtitleTextColor){ success, message in
            completion(success, message)
        }
    }
    
    public func SosRequest(title: String = "", subtitle: String = "", backroundColor: String = "",textColor : String = "",message : String = "",imgURL : String = "", completion: @escaping (Bool, String?) -> Void){
        sosRequestImpl.SosRequest(title: title, subtitle: subtitle, backroundColor: backroundColor,textColor : textColor,message:message,imgURL : imgURL){ success, message in
            completion(success, message)
        }
    }
    public func needPermission(title: String = "", subtitle: String = "", description: String = "", noteTitle : String = "",noteDescription : String = "", permissionList: [PermissionItem] = [],completion: @escaping (Bool, String?) -> Void){
        needPermission.needPermisson(Title: title, subTitle: subtitle, description: description, noteTitle: noteTitle, noteDescription : noteDescription,permissionList: permissionList) { success, message in
            completion(success,message)
        }
    }
    
    public func zigAddTicket(TotalAmount: Double, TicketDetails: [[String: Any]], completion: @escaping(Bool,String) -> Void) {
        TicketImpl.addTickets(TotalAmount: TotalAmount, TicketDetails: TicketDetails) { success, message in
            completion(success, message)
        }
    }
    public func zigGetTicket(completion:@escaping(Bool,[[String: Any]])->Void){
        TicketImpl.GetTicket { success, message in
            completion(success,message)
        }
    }
    public func zigActivateTicket(ticketId:Int,completion:@escaping(Bool,[[String: Any]])->Void){
        TicketImpl.ActivateTicket(ticketId: ticketId) { success, message in
            completion(success,message)
        }
    }
    public func zigInit(authKey : String,enableLog : Bool = true,completion: @escaping (Bool, String?) -> Void){
        beacon.ZIGSDKInit(authKey: authKey,enableLog: enableLog) {  success, message in
            completion(success,message)
        }
    }
    public func receiverMessage(completion: @escaping ([String: Any]) -> Void){
        ValidationProtocol.registerForMessages { success in
            completion(success)
        }
    }
    
    public func zigCreditWallet(walletTitle: String = "",buttonText: String = "", userId: Int, userName: String, creditAmount: Double = 0.0,setBrandColour : String = "",paymentMode:paymentType,completion: @escaping (Bool, ([String: Any])) -> Void)
    {
        addSDKWallet.zigCreditWallet(walletTitle: walletTitle,buttonText: buttonText, userId: userId, userName: userName, paymentMode: paymentMode, creditAmount: creditAmount,setBrandColour : setBrandColour){ success, message in
            completion(success,message)
        }
    }
    
    public func zigSuperWalletPayment(walletTitle: String = "",buttonText: String = "", userId: Int, userName: String, debitAmount: Double,purpose: String,setBrandColour : String = "",completion: @escaping (Bool, ([String: Any])?) -> Void){
        zigWalletPayment.zigSuperwalletPayment(walletTitle: walletTitle, buttonText: buttonText,userId: userId, userName: userName, debitAmount: debitAmount,purpose: purpose,setBrandColour : setBrandColour) { success, message in
            completion(success,message)
        }
    }
    
    public func zigGetWallet(UserID: Int,completion: @escaping (Bool,([String: Any])) -> Void){
        zigWalletBalance.zigGetWallet(userId: UserID) { success, message in
            completion(success,message)
        }
    }
    
    public func zigBuyTicket(agencyId: Int,userName: String,userId: Int,completion: @escaping(Bool,String) -> Void){
        BuyTicketAction.buyTicket(agencyId: agencyId,userName: userName,userId: userId) { success, message in
            completion(success,message)
        }
    }
    
    public func zigAddUserInfo(AuthKey: String, UserId: Int, UserName: String, EmailId: String, completion: @escaping(Bool,String) -> Void){
        addUserInfo.UserInfo(authKey: AuthKey, userId: UserId, userName: UserName, EmailId: EmailId) { Success, Message in
            completion(Success,Message)
        }
    }
    public func zigTransaction(userId: Int,completion: @escaping (Bool,([[String: Any]])) -> Void){
        transAction.zigTransaction(userId: userId) { success, message in
            completion(success,message)
        }
    }
    public func zigGetFare(authKey: String,completion: @escaping (Bool,([[String: Any]]))-> Void){
        getFare.getFare(authkey: authKey) { success, Message in
            completion(success,Message)
        }
    }
}
extension Notification.Name {
    public static let didReceiveMessage = Notification.Name("didReceiveMessage")
}
