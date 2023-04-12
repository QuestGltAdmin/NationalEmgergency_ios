//
//  PaymentChoose.swift
//  Disaster and Distress
//
//  Created by Mohit on 07/02/20.
//  Copyright © 2020 Questglt. All rights reserved.
//

import UIKit

import ZKProgressHUD
import WebKit

class PaymentChoose: UIViewController,PopUpVCDelegate,WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    
   
    var clientToken = ""

    var userDict = NSDictionary()
    var paymenTData = NSDictionary()
    var RoadSideDic = SelectPaymentData(with: [:])
    var MedicalDic = SelectPaymentData(with: [:])
    @IBOutlet weak var serviceChargesLbl: UILabel!
    @IBOutlet weak var TransectionFeeLbl: UILabel!
    @IBOutlet weak var TotalLbl: UILabel!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var titleImg: UIImageView!
    
    var getServiceCharges = 0
    var getroadSideserviceCharges = 0
    var getTransectionFee = 0
    var getTransection_user_id = ""
    var getTotalCharges = 0
    var PaymentType = ""

    @IBOutlet weak var paymentName: UILabel!
    @IBOutlet weak var roadSideserviceCharges: UIStackView!
    @IBOutlet weak var roadSideChargesLbl: UILabel!
    
    @IBOutlet weak var backBg: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if paymenTData.count == 0
        {
            backBg.isHidden = true
                  if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) != nil)
                  {
                     userDict = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) as! NSDictionary
                  }
                  self.titleName.text = self.PaymentType
                  roadSideserviceCharges.isHidden = true
                  
                  switch self.PaymentType {
                  case "Medical Assistance":
                      paymentName.text =  "Medical Assistance Charges"
                      getroadSideserviceCharges = 0
                    self.titleImg.image = #imageLiteral(resourceName: "medical")
                  case "Roadside Assistance":
                      paymentName.text =  "Roadside Assistance Charges"
                      getroadSideserviceCharges = 0
                    self.titleImg.image = #imageLiteral(resourceName: "road-assitance")
                  default:
                      paymentName.text =  "Medical Assistance Charges"
                      roadSideserviceCharges.isHidden = false
                      self.titleImg.image = #imageLiteral(resourceName: "both")
                  }
                   HitToGetProfile(setString: "")
                 

                     
        }else{
            
            TotalLbl.text = "Charges: \(paymenTData["payment"]!)$\nTransaction Fee: \(paymenTData["transaction_fee"]!)$\nTotal Amount: \(paymenTData["total_amount"]!)$"
            if "\(paymenTData["medical_service_id"]!)" != "" &&  "\(paymenTData["roadside_service_id"]!)" != ""
            {
                titleName.text = "Both Services"
                self.titleImg.image = #imageLiteral(resourceName: "both")
            }else if "\(paymenTData["medical_service_id"]!)" == "" &&  "\(paymenTData["roadside_service_id"]!)" != ""
            {
                
                titleName.text = "Roadside Assistance"
                self.titleImg.image = #imageLiteral(resourceName: "road-assitance")
            }else
            {
                titleName.text = "Medical Assistance"
                self.titleImg.image = #imageLiteral(resourceName: "medical")
            }
            
        }
      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //HitAction()
        
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
                                if setString.count == 0
                                {
                                    self.backBg.isHidden = false
                                    self.getTransectionFee = Int("\(getDic["transaction_fee"]!)")!
                                    self.getTotalCharges = self.getServiceCharges + self.getTransectionFee + self.getroadSideserviceCharges
                                    self.serviceChargesLbl.text = "\(self.getServiceCharges) $"
                                    self.TransectionFeeLbl.text = "\(self.getTransectionFee) $"
                                    self.roadSideChargesLbl.text = "\(self.getroadSideserviceCharges) $"
                                    self.TotalLbl.text = "\(self.getTotalCharges) $"
                                    print(self.userDict)
                                   

                                }else{
                                   let replaced = indexKeyedDictionary(fromArray: Data?["data"] as! [String : Any])
                                   self.userDict = replaced as! NSDictionary
                                   DataPersistence.sharedDataPersistenceInterface.saveValueInDefaults(self.userDict, storeKey: kHasUserData)
                                   NotificationCenter.default.post(name: Notification.Name(rawValue: "plotGet"), object: nil)
                                   var PopUpVCView: PopUpVC!
                                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                   PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC)
                                  PopUpVCView.delegate = self
                                  PopUpVCView.modalTransitionStyle = .crossDissolve
                                  PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                                  self.present(PopUpVCView, animated: true, completion: nil)
                                  PopUpVCView.checkData(titleImage: #imageLiteral(resourceName: "check-mark"), title:setString , titleSubHead1: "", titleSubHead2: "", details: "", btn1title: "Ok", btn2title: "",typeOf:"dynamic",IsCancelBtn:true)
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
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func getPayment(APIName:String,amount:String,medical_id:String,roadside_id:String) {
           let WebDict:[String:Any]  = [
                         "user_id":userDict["_id"]!,
                         "medical_id":medical_id,
                         "roadside_id":roadside_id,
//                         "transaction_id":transaction_id,
                         "amount":amount,
                         "total_amount":"\(getTotalCharges)",
                         "transaction_fee":"\(getTransectionFee)"
                     ]
        
//                                          self.getTransectionFee = Int("\(getDic["transaction_fee"]!)")!
//                                          self.getTotalCharges = self.getServiceCharges + self.getTransectionFee + self.getroadSideserviceCharges
//                                          self.serviceChargesLbl.text = "\(self.getServiceCharges) $"
//                                          self.TransectionFeeLbl.text = "\(self.getTransectionFee) $"
//                                          self.roadSideChargesLbl.text = "\(self.getroadSideserviceCharges) $"
//                                          self.TotalLbl.text = "\(self.getTotalCharges) $"
        
        
            var PopUpVCView: PaypalVC!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PaypalVC") as! PaypalVC)
      
            let myURL = APIURL + APIName + "?medical_id=\(WebDict["medical_id"]!)&user_id=\(WebDict["user_id"]!)&amount=\(WebDict["amount"]!)&total_amount=\(WebDict["total_amount"]!)&roadside_id=\(WebDict["roadside_id"]!)&transaction_fee=\(WebDict["transaction_fee"]!)"
            PopUpVCView.APIURLIs = myURL
            PopUpVCView.modalTransitionStyle = .crossDissolve
            PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(PopUpVCView, animated: true, completion: nil)
//           WebService().Post_AUTH(controller: APIName, values: WebDict) { (Data, Status,otherStatus) in
//               DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//                   ZKProgressHUD.dismiss()
//                   if Status == true
//                   {
//                       if(Data?["status"] as! Int) == 1
//                       {
//                           var PopUpVCView: PaypalVC!
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PaypalVC") as! PaypalVC)
//                            PopUpVCView.APIURLIs =  "\(Data!["url"]!)"
//
//                           PopUpVCView.modalTransitionStyle = .crossDissolve
//                           PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
//                           self.present(PopUpVCView, animated: true, completion: nil)
//                       }
//                       else {
//
//
//                       }
//                   }else
//                   {
//                       if let othervalues : String = otherStatus
//
//                       {
//                           customWarningAlert(Controller: self, title: show_Alert, Message: otherStatus!, btn1title: Msgok)
//                       }else
//                       {
//                           customWarningAlert(Controller: self, title: show_Alert, Message: Data?["msg"] as! String, btn1title: Msgok)
//
//                       }
//                   }
//               })
         
//           }
           
       }
 
    
    @IBAction func payAction(_ sender: Any) {
//        let getTransection_id = ((dict!["response"] as! NSDictionary)["id"] as! String)
        switch self.PaymentType {
           case "Medical Assistance":
            getPayment(APIName: "getPayment_ios", amount: "\(MedicalDic.charges!)", medical_id: "\(MedicalDic.user_id!)", roadside_id: "")
           case "Roadside Assistance":
            getPayment(APIName: "getPayment_ios", amount: "\(RoadSideDic.charges!)", medical_id: "", roadside_id: "\(RoadSideDic.user_id!)")
           default:
            getPayment(APIName: "getPayment_ios", amount: "\(self.getServiceCharges + self.getroadSideserviceCharges)", medical_id:  "\(MedicalDic.user_id!)", roadside_id: "\(RoadSideDic.user_id!)")
       }
//        PaymentForBusiness(Product_ID: "\(NSDate().timeIntervalSince1970 * 1000)")
    }
     func PopUpManager(checkType status: String, AlertType: String)  {
                   print(status)
                   if status != "cancel"
                   {
                     if AlertType == "dynamic"
                     {
                         
                                 AppDelegate.sharedAppDelegateInterface.GetHomePage()
                         
                       }else {
                           //    self.navigationController?.popViewController(animated: true)
                       }

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
