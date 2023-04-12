//
//  PlotMeVC.swift
//  Zega Cookware
//
//  Created by Mohit on 21/10/19.
//  Copyright © 2019 Questglt. All rights reserved.
//

import UIKit
import ZKProgressHUD
class PlotMeVC: UIViewController,PopUpVCDelegate {
    @IBOutlet weak var nameTxt: DesignableUITextField!
    @IBOutlet weak var buildingName: DesignableUITextField!
    @IBOutlet weak var streetAdd: DesignableUITextField!
    @IBOutlet weak var noOfPeople: DesignableUITextField!
    @IBOutlet weak var contactNo: DesignableUITextField!
    var userDict = NSDictionary()

    
    var getLocation = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()

       if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) != nil)
       {
           userDict = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) as! NSDictionary
            var Name : String = ""

            if self.checkExist(parameter:"firstName")
            {
                Name = Name + "\(userDict["firstName"]!)"
            }
            if self.checkExist(parameter:"lastName")
            {
                Name = Name + " \(userDict["lastName"]!)"
            }
            var getNumber =  ""
            if self.checkExist(parameter:"conCode")
            {
                getNumber.append("\(userDict["conCode"]!)")
            }
            if self.checkExist(parameter:"contact")
            {
                getNumber.append("\(userDict["contact"]!)")
            }
            contactNo.text = "\(getNumber)"

            nameTxt.text = Name
       }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name:UIApplication.willEnterForegroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(getIndex), name: NSNotification.Name("plotSearch"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func appMovedToForeground() {
        if Reachability.isConnectedToNetwork() != true {
            showOfflinePage(Controller: self)
        }else
        {
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appMovedToForeground()
    }
    func checkExist(parameter:String) -> Bool
    {
        
        if let firstName = userDict[parameter]
        {
            if (firstName as! String).count != 0
            {
                return true
            }
        }
        return false
    }
    
    @objc func getIndex(notification: NSNotification)
    {
        let cellData = notification.object
        if let dataDict = cellData as? NSDictionary {
            if ((dataDict) != nil)
            {
                print(dataDict)
                getLocation = dataDict as! NSDictionary
                streetAdd.text = "\(getLocation["placename"]!)"
//                var addressString : String = ""
//               if getLocation["subLocality"] != nil {
//                   addressString = addressString + "\(getLocation["subLocality"]!)" + ", "
//
//               }
//               if getLocation["thoroughfare"] != nil {
//                   addressString = addressString + "\(getLocation["thoroughfare"]!)" + ", "
//
//               }
//               if getLocation["locality"] != nil {
//                   addressString = addressString + "\(getLocation["locality"]!)" + ", "
//               }
//               if getLocation["country"] != nil {
//                   addressString = addressString + "\(getLocation["country"]!)" + ", "
//
//               }
//               if getLocation["postalCode"] != nil {
//                   addressString = addressString + "\(getLocation["postalCode"]!)" + " "
//
//               }
//               if getLocation["subThoroughfare"] != nil {
//                      addressString = addressString + "\(getLocation["subThoroughfare"]!)" + " "
//               }
            }
        }
//        if let dataDict = cellData as? [String : Any] {
//            if ((dataDict) != nil)
//            {
//                print(dataDict)
//                getLocation = dataDict as! NSDictionary
//
//                var addressString : String = ""
//               if getLocation["subLocality"] != nil {
//                   addressString = addressString + "\(getLocation["subLocality"]!)" + ", "
//
//               }
//               if getLocation["thoroughfare"] != nil {
//                   addressString = addressString + "\(getLocation["thoroughfare"]!)" + ", "
//
//               }
//               if getLocation["locality"] != nil {
//                   addressString = addressString + "\(getLocation["locality"]!)" + ", "
//               }
//               if getLocation["country"] != nil {
//                   addressString = addressString + "\(getLocation["country"]!)" + ", "
//
//               }
//               if getLocation["postalCode"] != nil {
//                   addressString = addressString + "\(getLocation["postalCode"]!)" + " "
//
//               }
//               if getLocation["subThoroughfare"] != nil {
//                      addressString = addressString + "\(getLocation["subThoroughfare"]!)" + " "
//               }
//               print(addressString)
//               streetAdd.text = addressString
//            }
//        }
        
    }
    @IBAction func backAction(_ sender: Any) {
          self.navigationController?.backToViewController(vc: self)
      }
    @IBAction func searchBtn(_ sender: Any) {
          let VC = self.storyboard?.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC
          self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func plotMeAction(_ sender: Any) {
        HitToPlotMe()
    }
    func HitToPlotMe() {
       
       
        if (nameTxt.text?.isEmpty)! {
             customWarningAlert(Controller: self, title: show_Alert, Message: "Please enter your Full Name", btn1title: Msgok)
        }else
        if (contactNo.text?.isEmpty)! {
              customWarningAlert(Controller: self, title: show_Alert, Message: "Please enter your Mobile Number", btn1title: Msgok)
        }else if !ValidationVC().isvalidatePhoneNumber(value: contactNo.text!)
        {
             customWarningAlert(Controller: self, title: show_Alert, Message: NPhoneValidAlert, btn1title: Msgok)
         
//        }else if (buildingName.text?.isEmpty)! {
//              customWarningAlert(Controller: self, title: show_Alert, Message: "Please enter Buliding Name", btn1title: Msgok)
//        }else if (noOfPeople.text?.isEmpty)! {
//              customWarningAlert(Controller: self, title: show_Alert, Message: "Please enter Number of Peoples", btn1title: Msgok)
        }else if (streetAdd.text?.isEmpty)! {
              customWarningAlert(Controller: self, title: show_Alert, Message: "Please select street Address", btn1title: Msgok)
        }else
        {
            ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: SetGIFName, withExtension: SetGIFType), gifSize: SetGIFSize)
            ZKProgressHUD.setBackgroundColor(.clear)
            let WebDict:[String:Any]  = [
                    "name":nameTxt.text!,
                    "contact":contactNo.text!,
                    "lat":getLocation["latitude"]!,
                    "long":getLocation["longitude"]!,
                    "buildingName":buildingName.text!,
                    "streetAdd":streetAdd.text!,
                    "noOfPeople":noOfPeople.text!,
                    "device_token":App_Device_Token!,
                    "device_type":"ios",
                    "user_id":userDict["_id"]!
                ]
            print(WebDict)
            WebService().Post_AUTH(controller: "plotMe", values: WebDict) { (Data, Status,otherStatus) in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    ZKProgressHUD.dismiss()
                    if Status == true
                    {
                        if(Data?["status"] as! Int) == 1
                        {
                            if let getDic: NSDictionary = (Data?["data"] as! NSDictionary)
                            {
                                self.view.endEditing(true)
                                let replaced = indexKeyedDictionary(fromArray: getDic as? [String : Any])
                                DataPersistence.sharedDataPersistenceInterface.saveValueInDefaults(replaced! as NSDictionary, storeKey: kHasplotMe)
                            }
                         
                          getPopUpAlertAction(Controller: self,titleImage: #imageLiteral(resourceName: "check-mark"), title: Data?["msg"] as! String, titleSubHead1: "", titleSubHead2: "", details:"", btn1title: Msgok, btn2title: "",IsCancelBtnHidden: true)
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
    func PopUpManager(checkType status: String, AlertType: String) {
        if AlertType == "action"
        {
           NotificationCenter.default.post(name: Notification.Name(rawValue: "plotGet"), object: nil)
           self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                  
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
