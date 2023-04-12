//
//  addOptionsVC.swift
//  Zega Cookware
//
//  Created by Mohit on 09/10/19.
//  Copyright © 2019 Questglt. All rights reserved.
//

import UIKit
import ZKProgressHUD
class addOptionsVC: UIViewController,PopUpVCDelegate {
    var userDict = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
            if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) != nil)
              {
                  userDict = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) as! NSDictionary
              }
             
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editProfile(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "editProfileVC") as! editProfileVC
        VC.checkPage = "edit"
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func logoutAction(_ sender: Any) {
          var PopUpVCView: PopUpVC!
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC)
          PopUpVCView.delegate = self
          PopUpVCView.modalTransitionStyle = .crossDissolve
          PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
          self.present(PopUpVCView, animated: true, completion: nil)
          PopUpVCView.checkData(titleImage: #imageLiteral(resourceName: "warning-1"), title: "Logout", titleSubHead1: "", titleSubHead2: KLogoutAlert, details: "", btn1title: "Yes", btn2title: "No",typeOf:"dynamic",IsCancelBtn:true)
    }
    @IBAction func helpAlertAction(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CountDownTimerVC") as! CountDownTimerVC
        VC.modalPresentationStyle = .overFullScreen
        self.present(VC, animated: true, completion: nil)
    }
    @IBAction func PaymentAction(_ sender: Any) {
        //HitToGetProfile(setString: "")
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentAction") as! PaymentAction
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func plotMeAction(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PlotMeVC") as! PlotMeVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func HelpAlertHistoryAction(_ sender: Any) {
          let VC = self.storyboard?.instantiateViewController(withIdentifier: "HelpAlertHistory") as! HelpAlertHistory
          VC.pageType = "Help Alert History"
          self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    func PopUpManager(checkType status: String, AlertType: String)  {
        print(status)
        if status != "cancel"
        {
            if status != "No".uppercased() && status != "OK"
            {
                HitLogout()
                
            }else {
                //    self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func HitToGetProfile(setString:String) {
        
            let WebDict:[String:Any]  = [
                               "user_id":userDict["_id"]!,
                            
                           ]
                       print(WebDict)
            ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: SetGIFName, withExtension: SetGIFType), gifSize: SetGIFSize)
            ZKProgressHUD.setBackgroundColor(.clear)
          
            WebService().Post_AUTH(controller: "feeStatus", values: WebDict) { (Data, Status,otherStatus) in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                               ZKProgressHUD.dismiss()
                    if Status == true
                    {
                        if(Data?["status"] as! Int) == 1
                        {
                            if let getDic: NSDictionary = (Data?["data"] as! NSDictionary)
                            {
                                if (Data?["payment_status"] as! Int) == 1
                                {
                                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentChoose") as! PaymentChoose
                                    VC.paymenTData = ((getDic["payment_data"] as! NSArray)[0] as! NSDictionary)
                                    self.navigationController?.pushViewController(VC, animated: true)
                                }else
                                {
                                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentAction") as! PaymentAction
                                    self.navigationController?.pushViewController(VC, animated: true)
                                }
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
    func HitLogout() {
        DataPersistence.sharedDataPersistenceInterface.deleteKey(kHasUserData)
        DataPersistence.sharedDataPersistenceInterface.deleteKey(kHasplotMe)
        AppDelegate.sharedAppDelegateInterface.GetFirstPageVC()
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
