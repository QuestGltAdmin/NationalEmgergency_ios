//
//  OfflineViewController.swift
//  reachability-playground
//
//  Created by Neo Ighodaro on 28/10/2017.
//  Copyright © 2017 CreativityKills Co. All rights reserved.
//

import UIKit
import MessageUI

func showOfflinePage(Controller:UIViewController) -> Void {
    DispatchQueue.main.async {
        var PopUpVCView: OfflineViewController!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "OfflineViewController") as! OfflineViewController)
        PopUpVCView.modalTransitionStyle = .crossDissolve
        PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        Controller.present(PopUpVCView, animated: true, completion: nil)
    }
}
class OfflineViewController: UIViewController,MFMessageComposeViewControllerDelegate,PopUpVCDelegate {
    
    let network = NetworkManager.sharedInstance
    var userDict = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) != nil)
       {
          userDict = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) as! NSDictionary

       }
        if Reachability.isConnectedToNetwork() == true
        {
            self.showMainController()
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name:UIApplication.willEnterForegroundNotification, object: nil)
    }
    @objc func appMovedToForeground() {
        if Reachability.isConnectedToNetwork() == true
       {
           self.showMainController()
       }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func showMainController() -> Void {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func canSendText() -> Bool {
              return MFMessageComposeViewController.canSendText()
       }
       func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
           print(result)
           self.dismiss(animated: true) {
              if(result == MessageComposeResult.sent) {
                getPopUpAlertAction(Controller: self,titleImage: #imageLiteral(resourceName: "check-mark"), title: "Rescue Teams have been alerted and are on their way.", titleSubHead1: "", titleSubHead2: "", details:"", btn1title: Msgok, btn2title: "",IsCancelBtnHidden: true)
              }
             else if(result == MessageComposeResult.cancelled) {
               
             }else if(result == MessageComposeResult.failed) {
                customWarningAlert(Controller: self, title: show_Alert, Message: "Message haven't sent successfully. You can try again.", btn1title: Msgok)
                 
              }
               
           }
       }
    func displayMessageInterface() {
        if LocationManager.isLocationServicesEnabled()
        {
            print("asasadsdd")
            print(LocationServiceCheck)
            switch LocationServiceCheck {
               case .notDetermined:
                    customWarningAlert(Controller: self, title: show_Alert, Message: "Please enable your Location from the setting App.", btn1title: Msgok)
                   break
               case .restricted, .denied:
                   customWarningAlert(Controller: self, title: show_Alert, Message: "Please enable your Location from the setting App.", btn1title: Msgok)
                   break
               default:
                    let composeVC = MFMessageComposeViewController()
                    composeVC.messageComposeDelegate = self
                    
                    // Configure the fields of the interface.
                    composeVC.recipients = ["+1 242-426-8307"]// ["+1 242-426-8307"]
                    let getPr = LocationManager.sharedLocationManager.location?.coordinate
                    composeVC.body = "My name is \(userDict["firstName"]!) \(userDict["lastName"]!).\nMy contact number is \(userDict["conCode"]!)\(userDict["contact"]!)\nMy location is - https://maps.google.com/maps?q=\(getPr!.latitude),\(getPr!.longitude)"
                    // Present the view controller modally.
                    if MFMessageComposeViewController.canSendText() {
                        self.present(composeVC, animated: true, completion: nil)
                    } else {
                        print("Can't send messages.")
                    }
                   break
               }
            
        }else{
            customWarningAlert(Controller: self, title: show_Alert, Message: "Location services are not enabled.", btn1title: Msgok)
        }
     
    }
    func PopUpManager(checkType status: String, AlertType: String) {
           if AlertType == "action"
           {
                 
           }
       }
    @IBAction func oflineMessage(_ sender: Any) {
           displayMessageInterface()
       }
       
}
