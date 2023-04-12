//
//  editProfileVC.swift
//  Zega Cookware
//
//  Created by Mohit on 22/10/19.
//  Copyright © 2019 Questglt. All rights reserved.
//

import UIKit
import ZKProgressHUD
class editProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PopUpVCDelegate {

    @IBOutlet weak var lastName: DesignableUITextField!
    @IBOutlet weak var firstName: DesignableUITextField!
    @IBOutlet weak var scontinueBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!

    @IBOutlet weak var titileLbl: DisolveTransitionLbl!
    @IBOutlet weak var editProfile: UIImageView!
    var userDict = NSDictionary()

    var checkPage: String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        if checkPage == "edit"
       {
           titileLbl.TextIS = "My Profile"
           scontinueBtn.setTitle("Submit".uppercased(), for: .normal)
           backBtn.isHidden = false

       }else{
           titileLbl.TextIS = "Complete Your Profile"
           scontinueBtn.setTitle("CONTINUE", for: .normal)
           backBtn.isHidden = true

       }
         editProfile.image = #imageLiteral(resourceName: "userProfileImage")
        if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) != nil)
        {
           userDict = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) as! NSDictionary
            HitToGetProfile(setString: "")

        }else
        {
            editProfile.image = #imageLiteral(resourceName: "userProfileImage")
            firstName.text = ""
            lastName.text = ""
        }
 
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name:UIApplication.willEnterForegroundNotification, object: nil)

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
    @IBAction func continueAction(_ sender: Any) {
       
        HitToEditProfile()
    }
    func HitToGetProfile(setString:String) {

            let WebDict:[String:Any]  = [
                               "id":userDict["_id"]!,
                            
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
                                if setString.count == 0
                                {

                                    let replaced = indexKeyedDictionary(fromArray: Data?["data"] as! [String : Any])
                                    self.userDict = replaced as! NSDictionary
                                    DataPersistence.sharedDataPersistenceInterface.saveValueInDefaults(self.userDict, storeKey: kHasUserData)
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "plotGet"), object: nil)
                                    if self.checkExist(parameter:"image")
                                    {
                                      let getPath = "\(APIURLProfile)/"
                                      let url = "\(getPath)\(GetImageCorrect(ImageURL: checkStringNull(checkData:self.userDict["image"]!)))"
                                      let downloadURL: NSURL = NSURL(string: url)!
                                      self.editProfile.af_setImage(withURL: downloadURL as URL)
                                    }else{
                                         self.editProfile.image = #imageLiteral(resourceName: "userProfileImage")
                                    }
                                     if self.checkExist(parameter:"firstName")
                                     {
                                      self.firstName.text = "\(self.userDict["firstName"]!)"
                                     }
                                      if self.checkExist(parameter:"lastName")
                                      {
                                          self.lastName.text = "\(self.userDict["lastName"]!)"
                                      }
                                       

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
    func HitToEditProfile() {

       
        if (firstName.text?.isEmpty)! {
             customWarningAlert(Controller: self, title: show_Alert, Message: "Please enter your First Name", btn1title: Msgok)
        }else
        if (lastName.text?.isEmpty)! {
              customWarningAlert(Controller: self, title: show_Alert, Message: "Please enter your Last Name", btn1title: Msgok)
        }else
        {
            ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: SetGIFName, withExtension: SetGIFType), gifSize: SetGIFSize)
            ZKProgressHUD.setBackgroundColor(.clear)
           
            var Replyimage = editProfile.image

            var imageData: Data = Data()
            if Replyimage == nil {
//                img_type = "no"
                Replyimage = nil
                imageData = Data()
            }else{
//                  img_type = "yes"
                imageData = Replyimage!.pngData()!
            }
            let WebDict:[String:Any]  = [
                               "fname":firstName.text!,
                               "lname":lastName.text!,
                               "image":Replyimage,
                               "id":userDict["_id"]!
                           ]
            print(WebDict)
            WebService().Post_AUTH_Profile1(controller: "profile/\(userDict["_id"]!)",imageData:imageData,values: WebDict, strImageKey: "image") { (Data, Status,otherStatus) in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    ZKProgressHUD.dismiss()
                    if Status == true
                    {
                        if(Data?["status"] as! Int) == 1
                        {
                             self.view.endEditing(true)
                            self.HitToGetProfile(setString:Data?["msg"] as! String)
                           
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
    @IBAction func UploadAction(_ sender: UIButton) {
           let optionMenu = UIAlertController(title: nil, message:NSLocalizedString("Choose Option", comment:"Choose Option") , preferredStyle: .actionSheet)
        
           let saveAction = UIAlertAction(title:NSLocalizedString("Take a Picture", comment:"Take a Picture"), style: .default, handler:
               
               {
                   (alert: UIAlertAction!) -> Void in
                   
                   self.getCamera()
                   
           })
           let deleteAction = UIAlertAction(title: NSLocalizedString("Select from Gallery", comment:"Select from Gallery"), style: .default, handler:
           {
               (alert: UIAlertAction!) -> Void in
               self.getGallery()
               
           })
           let cancelAction = UIAlertAction(title:"Cancel" , style: .cancel, handler:
           {
               (alert: UIAlertAction!) -> Void in
               
           })
           
           optionMenu.addAction(deleteAction)
           optionMenu.addAction(saveAction)
           optionMenu.addAction(cancelAction)
           if let popoverController = optionMenu.popoverPresentationController {
               popoverController.sourceView = self.view
               popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
               popoverController.permittedArrowDirections = []
           }
           self.present(optionMenu, animated: true, completion: nil)
       }
    // MARK:UploadImage
       @objc func getCamera()  {
           
           let myPickerController = UIImagePickerController()
           myPickerController.delegate = self ;
           myPickerController.allowsEditing = true
           myPickerController.sourceType = UIImagePickerController.SourceType.camera
           self.present(myPickerController, animated: true, completion: nil)
       }
      
       @objc func getGallery() {
           
           let myPickerController = UIImagePickerController()
           myPickerController.delegate = self ;
           myPickerController.allowsEditing = true
           myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
           self.present(myPickerController, animated: true, completion: nil)
           
       }
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
                  }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.backToViewController(vc: self)
    }
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let picURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
//               let imgData = PHAsset.fetchAssets(withALAssetURLs: [picURL], options: nil)
//               let asset = imgData.firstObject
//               lblImageName.text = (asset?.value(forKey: "filename")) as? String
           }
    
           var  imagenow = UIImage()
           imagenow = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
           
           if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//               lblImageName.text = " \("Image Uploaded")!"
               editProfile.image = pickedImage
           }
           dismiss(animated: true, completion: nil)
       }
       func PopUpManager(checkType status: String, AlertType: String)  {
                 print(status)
                 if status != "cancel"
                 {
                   if AlertType == "dynamic"
                   {
                        if checkPage != "edit"
                        {
                          
                               
                               AppDelegate.sharedAppDelegateInterface.GetHomePage()
                        }

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
