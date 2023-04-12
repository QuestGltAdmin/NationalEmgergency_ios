//
//  CountDownTimerVC.swift
//  Zega Cookware
//
//  Created by Mohit on 09/10/19.
//  Copyright © 2019 Questglt. All rights reserved.
//

import UIKit
import ZKProgressHUD
var defaultDuration : Double = 6

class CountDownTimerVC: UIViewController,CompleteTimerDelegate {
    var userDic = NSDictionary()
    var rippleView = SMRippleView()
    @IBOutlet weak var viewAnimation: UIView!
    @IBOutlet weak var lableTimer: MZTimerLabel!
    let getLocation = LocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name:UIApplication.willEnterForegroundNotification, object: nil)

     }
    @objc func appMovedToForeground() {
        if Reachability.isConnectedToNetwork() != true {
            showOfflinePage(Controller: self)
        }else
        {
                 lableTimer.timerType = MZTimerLabelTypeTimer
                 let fillColor = UIColor.white
                 lableTimer.layoutIfNeeded()
                 self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_gradient")!)

                 rippleView = SMRippleView(frame: CGRect.init(x: self.view.frame.origin.x+self.view.frame.size.width/2-lableTimer.frame.size.width/2, y: self.view.frame.origin.y+self.view.frame.size.height/2-lableTimer.frame.size.height/2, width: lableTimer.frame.size.width, height: lableTimer.frame.size.height), rippleColor: UIColor.clear, rippleThickness: 0.5, rippleTimer: 0.5, fillColor: fillColor, animationDuration: 3, parentFrame: self.view.frame)
                 rippleView.layoutIfNeeded()
                 self.view.addSubview(rippleView)
                 
                    lableTimer.setCountDownTime(defaultDuration)

         //           lableTimer.delegate = self
                    if defaultDuration > 60
                    {
                        lableTimer.timeFormat = "mm:ss"
                    }else
                    {
                        lableTimer.timeFormat = "ss"
                    }
                     self.lableTimer.isHidden = false
                     lableTimer.start { (ending) in
                     self.lableTimer.isHidden = true
                     self.lableTimer.pause()
                     self.lableTimer.reset()
                     print(LocationManager.sharedLocationManager.location?.coordinate.latitude)
                     self.HitMobileVerification()
             //           customCookingCompleteAlert(Controller: (AppDelegate.sharedAppDelegateInterface.navigationController?.visibleViewController)!, title: show_Alert, Message: "Cooking Complete".uppercased(), btn1title: MsgDone)
                    }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appMovedToForeground()
    }
    
    @IBAction func cancelOption(_ sender: Any) {
        rippleView.stopAnimation()
        rippleView.removeFromSuperview()
        self.lableTimer.pause()
        self.lableTimer.reset()
        self.dismiss(animated: true, completion: nil)
    }
    func HitMobileVerification()
    {
        var APIName = ""
        if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) == nil)
        {
            userDic = ["name":""]
        }else
        {
            userDic = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) as! NSDictionary
        }
        let getPr = LocationManager.sharedLocationManager.location?.coordinate
        let params : NSDictionary =
            ["lat":getPr!.latitude,
             "long":getPr!.longitude,
             "mobToken":App_Device_Token!,
             "user_id":"\(userDic["_id"]!)"]
        print(params)
        ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: SetGIFName, withExtension: SetGIFType), gifSize: SetGIFSize)
        ZKProgressHUD.setBackgroundColor(.clear)
        WebService.sharedWebService.Post_AUTH(controller: "help", values: (params as NSDictionary) as! [String : Any], completionHandler: { (Data, Status,otherStatus) in
            
            ZKProgressHUD.dismiss()
            if Status == true
            {
                if(Data?["status"] as! Int) == 1
                {
                    self.CheckAlert(title: "", Message: "", btn1title: "")
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
    func CheckAlert(title:String,Message:String,btn1title:String)
    {
        rippleView.stopAnimation()
        rippleView.removeFromSuperview()
        lableTimer.reset()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "helpGet"), object: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
       
       // PopUpVCView.checkData(titleImage:  #imageLiteral(resourceName: "check-mark"), title: Message, titleSubHead1: "", titleSubHead2: "", details: "", btn1title: btn1title, btn2title: "",typeOf:"cooking success", IsCancelBtn:true)
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

