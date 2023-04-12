//
//  OTPScreen.swift
//  KKOGWalletApp
//
//  Created by Alok Agrawal on 17/09/18.
//  Copyright © 2018 Quest GLT. All rights reserved.
//

import UIKit
import ZKProgressHUD
protocol OTPScreenDelegate : class {
    func didFinishOTPScreenView(_ recorderViewController: OTPScreen,str: String, ViewType:String)
}
class OTPScreen: UIViewController,UITextFieldDelegate,PopUpVCDelegate {
    open weak var delegate: OTPScreenDelegate?
    var OTPResendData = NSDictionary()
    var getPinStatus = ""
    @IBOutlet weak var TitleTxt: UILabel!
    var type_Main = ""
    var type_email = ""
    @IBOutlet weak var firstText: DesignableUITextField!
    @IBOutlet weak var SecoundText: DesignableUITextField!
    @IBOutlet weak var ThirdText: DesignableUITextField!
    @IBOutlet weak var FourthText: DesignableUITextField!
    
    @IBOutlet weak var otpTimeBtn: UIButton!
    @IBOutlet weak var Phnoelb: UILabel!
    @IBOutlet weak var ThanksLbl: UILabel!
    @IBOutlet weak var OtpTimelbl: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var Enterlbl: UILabel!
    var userDict = NSDictionary()
    var ProfileOTP = Int()
    var logindic = NSDictionary()
    var type = ""
    var Page_type = ""
    var ThanksMsgMobile = ""
    var ThanksMsgMail = ""
    var ThanksMsgOfficialMail = ""
    
    
    var type_Of_Otp = ""
    var timer = Timer()
    var seconds = 60
    var isTimerRunning = false
    var userDic : NSDictionary = NSDictionary()
    var official_email = ""
    var profile_type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(official_email)
        otpTimeBtn.isHidden = true
        otpTimeBtn.underlineButton(text: "Resend OTP?")
        OtpTimelbl.isHidden = false
        Phnoelb.text = "We've sent an OTP on your number\n \(logindic["conCode"]!)\(logindic["contact"]!)"
        if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) == nil)
        {
            userDic = ["name":""]
        }else
        {
            userDic = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) as! NSDictionary
            
        }
        if type_Main == "Reg1"
        {
            resendOTP()
        }else
        {
            runTimer()
        }
        
        firstText.delegate = self
        SecoundText.delegate = self
        ThirdText.delegate = self
        FourthText.delegate = self
        
        firstText.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        SecoundText.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        ThirdText.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        FourthText.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        
    }
   
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        
        if seconds == 0
        {
             otpTimeBtn.isHidden = false
             timer.invalidate()
          
        }else
        {
            UIView.performWithoutAnimation {
                if seconds == 01
                {
                     otpTimeBtn.isHidden = false
                    OtpTimelbl.isHidden = true
                }
                OtpTimelbl.text = "\(timeString(time: TimeInterval(seconds)))"
               
            }
            
        }
        
    }
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i",minutes, seconds)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    @IBAction func resendAction(_ sender: Any) {
        OtpTimelbl.text = ""
        OtpTimelbl.isHidden = false
        firstText.text = ""
        SecoundText.text = ""
        ThirdText.text = ""
        FourthText.text = ""
         resendOTP()
       
    }
    func resendOTP()
    {
        var APIName = ""
    
        let params : NSDictionary =
            ["contact":"\(logindic["conCode"]!)\(logindic["contact"]!)"]
        print(params)
        ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: SetGIFName, withExtension: SetGIFType), gifSize: SetGIFSize)
        ZKProgressHUD.setBackgroundColor(.clear)
        WebService.sharedWebService.Post_AUTH(controller: "login", values: (params as NSDictionary) as! [String : Any], completionHandler: { (Data, Status,otherStatus) in
            
            ZKProgressHUD.dismiss()
            if Status == true
            {
                
                let dic = Data as! NSDictionary
                if(Data?["status"] as! Int) == 1
                {
                    if let getDic: NSDictionary = (Data?["data"] as! NSDictionary)
                    {
                        
                       customWarningAlert(Controller: self, title: show_Alert, Message: "OTP has been successfully sent to your registered mobile number.", btn1title: Msgok)

                       self.logindic = getDic
                       self.timer.invalidate()
                       self.seconds = 60
                       self.runTimer()
                      
                       self.otpTimeBtn.isHidden = true
                    }
                   
                }else
                {
                   customWarningAlert(Controller: self, title: show_Alert, Message: Data?["msg"] as! String, btn1title: Msgok)
                    
                }
                
                
            }else
            {
                if let othervalues : String = otherStatus
                    
                {
                    customWarningAlert(Controller: self, title: show_Alert, Message: othervalues, btn1title: Msgok)
                    
                }else
                {
                    
                    customWarningAlert(Controller: self, title: show_Alert, Message: Data?["msg"] as! String, btn1title: Msgok)
                    
                }
            }
        })
        
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  (text?.utf16.count)! >= 1{
            switch textField{
            case firstText:
                SecoundText.becomeFirstResponder()
            case SecoundText:
                ThirdText.becomeFirstResponder()
            case ThirdText:
                FourthText.becomeFirstResponder()
            case FourthText:
                FourthText.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case firstText:
                firstText.becomeFirstResponder()
            case SecoundText:
                firstText.becomeFirstResponder()
            case ThirdText:
                SecoundText.becomeFirstResponder()
            case FourthText:
                ThirdText.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text?.count == 1 {
            textField.text = ""
        }
        
        if (textField == firstText) || (textField == SecoundText) || (textField == ThirdText) ||  (textField == FourthText){
            
            if (firstText.text == "") || (SecoundText.text == "") || (ThirdText.text == "") || (FourthText.text == "")
            {
            }
            else {
            }
        }
        
        return true
        
    }
    @IBAction func BackAction(_ sender: Any) {
        if Page_type == "popup"
        {
            delegate?.didFinishOTPScreenView(self, str: "cancel", ViewType: "")
            self.dismiss(animated: true, completion: nil)
        }else
        {
            
            _ = navigationController?.popViewController(animated: true)
        }
        
        
    }
    @IBAction func NextAction(_ sender: Any) {
       
            if  (firstText.text?.isEmpty)! &&
                (SecoundText.text?.isEmpty)! &&
                (ThirdText.text?.isEmpty)! &&
                (FourthText.text?.isEmpty)!
            {
                customWarningAlert(Controller: self, title: show_Alert, Message: "Enter OTP", btn1title: Msgok)
                
            }else if  (firstText.text?.isEmpty)! ||
                (SecoundText.text?.isEmpty)! ||
                (ThirdText.text?.isEmpty)! ||
                (FourthText.text?.isEmpty)!
            {
                customWarningAlert(Controller: self, title: show_Alert, Message: "Enter valid OTP", btn1title: Msgok)
            }
//            }else if "\(firstText.text!)\(SecoundText.text!)\(ThirdText.text!)\(FourthText.text!)" != "\(logindic["otp"]!)" {
//                 customWarningAlert(Controller: self, title: show_Alert, Message: MsgOTPMATCH, btn1title: Msgok)
//
//
//            }
            else
            {
                HitMobileVerification()
               
            }
     }
    func HitMobileVerification()
    {
        var APIName = ""
    
        let params : NSDictionary =
            ["user_id":logindic["_id"]!,"otp":"\(firstText.text!)\(SecoundText.text!)\(ThirdText.text!)\(FourthText.text!)"]
        print(params)
        ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: SetGIFName, withExtension: SetGIFType), gifSize: SetGIFSize)
        ZKProgressHUD.setBackgroundColor(.clear)
        WebService.sharedWebService.Post_AUTH(controller: "otp", values: (params as NSDictionary) as! [String : Any], completionHandler: { (Data, Status,otherStatus) in
            
            ZKProgressHUD.dismiss()
            if Status == true
            {
                
                let dic = Data as! NSDictionary
                if(Data?["status"] as! Int) == 1
                {
                    self.HitToGetProfile()
                }else
                {
                    
                    customWarningAlert(Controller: self, title: show_Alert, Message: Data?["msg"] as! String, btn1title: Msgok)
                    
                }
                
                
            }else
            {
                if let othervalues : String = otherStatus
                    
                {
                    customWarningAlert(Controller: self, title: show_Alert, Message: othervalues, btn1title: Msgok)
                   
                    
                }else
                {
                    customWarningAlert(Controller: self, title: show_Alert, Message: Data?["msg"] as! String, btn1title: Msgok)
                    
                }
            }
        })
        
    }
    func HitToGetProfile() {

            let WebDict:[String:Any]  = [
                               "id":logindic["_id"]!,
                            
                           ]
                       print(WebDict)
            ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: SetGIFName, withExtension: SetGIFType), gifSize: SetGIFSize)
            ZKProgressHUD.setBackgroundColor(.clear)
          
            WebService().Post_AUTH(controller: "getProfile", values: WebDict) { (Data, Status,otherStatus) in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                               ZKProgressHUD.dismiss()
                    if Status == true
                    {
                        if(Data?["status"] as! Int) == 1
                        {
                            if let getDic: NSDictionary = (Data?["data"] as! NSDictionary)
                            {
                                let replaced = indexKeyedDictionary(fromArray: Data?["data"] as! [String : Any])
                                self.userDict = replaced as! NSDictionary
                                DataPersistence.sharedDataPersistenceInterface.saveValueInDefaults(self.userDict, storeKey: kHasUserData)
                                self.view.endEditing(true)
                                if !self.checkExist(parameter:"firstName") || !self.checkExist(parameter:"lastName")
                                {
                                    AppDelegate.sharedAppDelegateInterface.GeteditProfileVC()
                                    
                                }else {
                                     AppDelegate.sharedAppDelegateInterface.GetHomePage()
                                }
//                                if self.userDict["firstName"] as! String == "" || self.userDict["lastName"] as! String == ""
//                                {
//                                  AppDelegate.sharedAppDelegateInterface.GeteditProfileVC()
//
//                                }else
//                                {
//                                    AppDelegate.sharedAppDelegateInterface.GetHomePage()
//
//                                }

                            }
                        }
                        else {
                            customWarningAlert(Controller: self, title: show_Alert, Message: Data?["msg"] as! String, btn1title: Msgok)
                        }
                    }else
                    {
                        if let othervalues : String = otherStatus
                            
                        {
                            customWarningAlert(Controller: self, title: show_Alert, Message: otherStatus!, btn1title: Msgok)
                        }else
                        {
                            customWarningAlert(Controller: self, title: show_Alert, Message: Data?["msg"] as! String, btn1title: Msgok)
                            
                        }
                    }
                })
                
            }
        
    }
    func checkExist(parameter:String) -> Bool
    {
        if let firstName = self.userDict[parameter]
        {
            if (firstName as! String).count != 0
            {
                return true
            }
        }
        return false
    }
   func PopUpManager(checkType status: String, AlertType: String) {
       if status != "cancel"
       {
           if AlertType != "alert"
           {
               self.navigationController?.popViewController(animated: true)
           }
       }
   }
 }
