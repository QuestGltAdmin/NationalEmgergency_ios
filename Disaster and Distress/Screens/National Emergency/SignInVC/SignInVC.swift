//
//  SignInVC.swift
//  Zega Cookware
//
//  Created by Ayushi on 15/07/19.
//  Copyright © 2019 Questglt. All rights reserved.
//

import UIKit
import ZKProgressHUD
import SwiftKeychainWrapper
class SignInVC: UIViewController,PopUpVCDelegate,UITextFieldDelegate,PincodeVCDelegate {
    func didFinishPincodeView(_ recorderViewController: PincodeVC, str: String) {
        print(recorderView.pincodeDict)
        if str == "Ok"
        {
           Country.text = "\(recorderView.pincodeDict["country_name_en"] as! String) (\(recorderView.pincodeDict["country_code"] as! String))"
          countryCode = "\(recorderView.pincodeDict["country_code"] as! String)"
        }
    }
    
  
    @IBOutlet weak var Country: DesignableUITextField!
    @IBOutlet weak var nameTxt: DesignableUITextField!
     @IBOutlet weak var btnSavePw: UIButton!
    @objc var recorderView: PincodeVC!
    var countryCode = ""

   
    var PageManage = ""
    var SavePassword = ""
    var getCountryArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
       
        HitToGetProfile()
        nameTxt.text = ""
//        if SavePassword == "SavePassword"{
//            //ForReterive
////            let retrievedPassword: String? = KeychainWrapper.standard.string(forKey: "userPassword")
//            passwordTxt.text = retrievedPassword
//        }else {
//            passwordTxt.text = ""
//        }
      
    }
    func HitToGetProfile() {

            
            ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: SetGIFName, withExtension: SetGIFType), gifSize: SetGIFSize)
            ZKProgressHUD.setBackgroundColor(.clear)
          
        WebService().Post_AUTH(controller: "getCode", values: [:]) { (Data, Status,otherStatus) in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                               ZKProgressHUD.dismiss()
                    if Status == true
                    {
                        if(Data?["status"] as! Int) == 1
                        {
                            if let getDic: NSArray = (Data?["data"] as! NSArray)
                            {
                                self.getCountryArray = getDic
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
    @IBAction func selectYourCountry(_ sender: Any) {
        if self.getCountryArray.count != 0
        {
            AddCountryPicker()
        }
    }
    
    func AddCountryPicker()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        recorderView = (storyboard.instantiateViewController(withIdentifier: "PincodeVC") as! PincodeVC)
        recorderView.delegate = self
        recorderView.createRecorder()
        recorderView.view.backgroundColor = UIColor.clear
        recorderView.modalTransitionStyle = .crossDissolve
        recorderView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        recorderView.getArray = self.getCountryArray
        recorderView.viewTypeIS = "Select Country Code"
        self.present(recorderView, animated: true, completion: nil)
        recorderView.startRecording()

        
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.backToViewController(vc: self)
    }
    @IBAction func ForgotAction(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassword") as! SignInVC
        VC.PageManage = "ForgotPassword"
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBAction func SignInAction(_ sender: Any) {
        if PageManage == "ForgotPassword"
        {
             HitToForGot()
        }else{
             HitToSignin()
        }
       
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
   
    func HitToForGot()
    {
        
        if (nameTxt.text?.isEmpty)! {
            customWarningAlert(Controller: self, title: show_Alert, Message: NEmailAlert, btn1title: Msgok)
           
        }else if !ValidationVC().isValidEmail(testStr: nameTxt.text!){
            customWarningAlert(Controller: self, title: show_Alert, Message: NEmailValidAlert, btn1title: Msgok)
          
        }else
        {
            ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: SetGIFName, withExtension: SetGIFType), gifSize: SetGIFSize)
            ZKProgressHUD.setBackgroundColor(.clear)
            let WebDict:[String:Any] = [
                    "user_email":nameTxt.text!,
                    "device_token":App_Device_Token!,
                    "device_type":"ios",
                ]
           
            print(WebDict)
            WebService().Post_AUTH(controller: "forgot-password", values: WebDict) { (Data, Status,otherStatus) in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    ZKProgressHUD.dismiss()
                    if Status == true
                    {
                        let dic = Data as! NSDictionary
                        if(Data?["status"] as! Int) == 1
                        {
                            getPopUpAlertAction(Controller: self,titleImage: #imageLiteral(resourceName: "forgot"), title: show_Alert, titleSubHead1: "", titleSubHead2: dic["msg"] as! String, details:"", btn1title: Msgok, btn2title: "",IsCancelBtnHidden: true)
                            //                        AlertMessgage(Controller: self, Title: "", Messgae: dic["msg"] as! String, completionHandler: { (status) in
                            //                            if status == true{
                            //                                self.navigationController?.popViewController(animated: true)
                            //                            }
                            //                        })
                        }
                        else {
                            customWarningAlert(Controller: self, title: show_Alert, Message: dic["msg"] as! String, btn1title: Msgok)
                            
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
    }
    func HitToSignin() {
        
        if (nameTxt.text?.isEmpty)! {
             customWarningAlert(Controller: self, title: show_Alert, Message: NPhoneAlert, btn1title: Msgok)
        }else
//            if !ValidationVC().isvalidatePhoneNumber(value: nameTxt.text!){
//             customWarningAlert(Controller: self, title: show_Alert, Message: NPhoneValidAlert, btn1title: Msgok)
//          
//        }else
            if btnSavePw.tag == 0 {
             customWarningAlert(Controller: self, title: show_Alert, Message: NTermAndConditionAlert, btn1title: Msgok)
        }else
        {
            ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: SetGIFName, withExtension: SetGIFType), gifSize: SetGIFSize)
            ZKProgressHUD.setBackgroundColor(.clear)
            let WebDict:[String:Any]  = [
                    "contact":nameTxt.text!,
                    "device_token":App_Device_Token!,
                    "device_type":"ios",
                    "conCode":countryCode
                ]
            print(WebDict)
            WebService().Post_AUTH(controller: "login", values: WebDict) { (Data, Status,otherStatus) in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    ZKProgressHUD.dismiss()
                    if Status == true
                    {
                        if(Data?["status"] as! Int) == 1
                        {
                            if let getDic: NSDictionary = (Data?["data"] as! NSDictionary)
                            {
                                self.view.endEditing(true)
                                let VC = self.storyboard?.instantiateViewController(withIdentifier: "OTPScreen") as! OTPScreen
                                VC.logindic = getDic
                              self.navigationController?.pushViewController(VC, animated: true)
                            }
//                            UserDefaults.standard.removeObject(forKey: "SavePassword")
//                            let replaced = indexKeyedDictionary(fromArray: Data?["user_result"] as! [String : Any])
//                        DataPersistence.sharedDataPersistenceInterface.saveValueInDefaults(replaced as! NSDictionary, storeKey: kHasUserData)
//                            if (dic["devices_list"] as! NSArray).count != 0
//                            {
//                                let devices_list = indexKeyedDictionary(fromArray:  ((dic["devices_list"] as! NSArray)[0] as! [String : Any]))
//                            DataPersistence.sharedDataPersistenceInterface.saveValueInDefaults(devices_list as! NSDictionary, storeKey: kHasManageDevice)
//                            }
                           
                         
                            //AppDelegate.sharedAppDelegateInterface.GetHomePage()
                            
                            
                            //                        AlertMessgage(Controller: self, Title: "", Messgae: dic["msg"] as! String, completionHandler: { (status) in
                            //                            if status == true{
                            ////                                AppDelegate.sharedAppDelegateInterface.GetFirstPageVC()
                            //
                            //
                            //                            }
                            //                        })
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
    }
    
    @IBAction func termAction(_ sender: Any) {
        guard let url = URL(string: "http://zegacookware.extreme.org.in/zega_cookware/login") else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func privacyAction(_ sender: Any) {
        guard let url = URL(string: "http://zegacookware.extreme.org.in/zega_cookware/login") else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func SavePwAction(_ sender: UIButton) {
       
        if sender.tag == 0
        {
            sender.setImage(#imageLiteral(resourceName: "check-box"), for: .normal)
            sender.tag = 1
        }else
        {
            sender.setImage(#imageLiteral(resourceName: "check-box-empty"), for: .normal)
//            do {
//                try keychain.remove("password")
//            } catch let error {
//                print("error: \(error)")
//            }
            //let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: "userPassword")
            sender.tag = 0
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension NSMutableAttributedString {

    public func setAsLink(textToFind:String, linkURL:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
          // self.addAttribute(.underlineColor, value: KBLUEColor, range: foundRange)
            return true
        }
        return false
    }
}
