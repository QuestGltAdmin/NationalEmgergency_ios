//
//  SplashScreenVC.swift
//  Pacific Bazar
//


import UIKit
import Alamofire
import ZKProgressHUD

class SplashScreenVC: UIViewController{
    @objc var AppDele = AppDelegate()
    let ConstantsObject = Constants()
    var getPinStatus = ""
    
    @IBOutlet weak var logoImage: UIImageView!
    // @IBOutlet weak var splashLoader: UIImageView!
   // @IBOutlet weak var centerLogoV: UIView!
    //@IBOutlet weak var bgImage: UIImageView!
    
    var check_Not:String?
    override func viewDidLoad() {
        //         blurEffect()
        ZKProgressHUD.setMaskBackgroundColor(.clear)
        blur1()
        // myPerformeCode()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @objc func blur1() {
       logoImage.isHidden = false
       Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.myPerformeCode), userInfo: nil, repeats: false)
        
       
    }
    @objc func myPerformeCode() {
        logoImage.isHidden = true
        self.logoImage.stopAnimating()
       // AppDelegate.sharedAppDelegateInterface.GetIntroSlider()

        if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) == nil) {
             
             AppDelegate.sharedAppDelegateInterface.GetFirstPageVC()
        }else
        {
            
            if !self.checkExist(parameter:"firstName") || !self.checkExist(parameter:"lastName")
            {
               AppDelegate.sharedAppDelegateInterface.GeteditProfileVC()

            }else
            {
                AppDelegate.sharedAppDelegateInterface.GetHomePage()

            }
        }
        
    }
    func checkExist(parameter:String) -> Bool
       {
            var userDict : NSDictionary = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) as! NSDictionary
           if let firstName = userDict[parameter]
           {
               if (firstName as! String).count != 0
               {
                   return true
               }
           }
           return false
       }
}
