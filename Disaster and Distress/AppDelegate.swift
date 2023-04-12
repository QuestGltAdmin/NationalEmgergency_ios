//
//  AppDelegate.swift
//  Zega Cookware
//
//  Created by Ayushi on 13/07/19.
//  Copyright © 2019 Questglt. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FFToast
import UserNotifications
import Fabric
import GooglePlaces
import GoogleMaps
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,LocationManagerDelegate{
    var window: UIWindow?
    @objc var toast = FFToast()
    @objc var DeviceToken: NSString? = ""
    @objc var navigationController: UINavigationController? = nil
    @objc var mainStoryboard : UIStoryboard? = nil
    @objc static let sharedAppDelegateInterface = AppDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
       // Fabric.with([Crashlytics.self])
        IQKeyboardManager.shared.enable = true
        UIApplication.shared.applicationIconBadgeNumber = 0
        UITextField.appearance().tintColor = KBLUEColor
        mainStoryboard  = UIStoryboard(name: "Main", bundle: nil)
        navigationController = (self.window?.rootViewController as? UINavigationController)
        navigationController = mainStoryboard!.instantiateViewController(withIdentifier: kmainNavigationViewcontroller) as? UINavigationController
        navigationController?.viewControllers = [mainStoryboard!.instantiateViewController(withIdentifier: "SplashScreenVC")]
        self.registerPush()
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = KBLUEColor
            
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        _ = LocationManager.sharedLocationManager
                   LocationManager.shared.delegate = self
           //self.registerPush()
             GMSPlacesClient.provideAPIKey(kMapsAPIKey)
             GMSServices.provideAPIKey(kMapsAPIKey)
        return true
    }
   

    func locationManager(didChangeAuthorization status: CLAuthorizationStatus) {
        LocationServiceCheck = status
        print(LocationServiceCheck)
    }
    @objc func registerPush()
    {
        // iOS 10 support
        if #available(iOS 10, *) {
            
            let content = UNMutableNotificationContent()
            //content.subtitle = "Glad to help..."
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Ringtone.caf"))
            // content.attachments = [attachment]
            content.categoryIdentifier = "CustomSamplePush"
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(in: .current, from: Date())
            let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: true)
            
            //            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01,
            //                                                            repeats: true)
            let request = UNNotificationRequest(
                identifier: "randomImageName", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler:
                { (error) in
                    if let error = error {
                        print(error)
                        //completion(false)
                    } else {
                        //completion(true)
                    }
            })
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            //
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            UIApplication.shared.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
    }
    @available(iOS 10.0, *)
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        let Demo1: NSString = ((notification.request.content.userInfo["aps"]as! NSDictionary)["alert"] as! NSDictionary) ["title"] as! String as NSString
        let Demo2: NSString = ((notification.request.content.userInfo["aps"]as! NSDictionary)["alert"] as! NSDictionary)["body"] as! String as NSString
        UIApplication.shared.applicationIconBadgeNumber = (notification.request.content.userInfo["aps"]as! NSDictionary)["badge"] as! NSInteger
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: UIApplication.shared.applicationIconBadgeNumber)
        
        
        toast = FFToast.init(toastWithTitle: (Demo1 as String).uppercased(), message: (Demo2 as String).uppercased(), iconImage: #imageLiteral(resourceName: "SplashLOGO"))
        //            toast.toastBackgroundColor = UIColor(red:0.00, green:0.81, blue:0.44, alpha:1.0)
        toast.toastBackgroundColor = UIColor.white
        toast.titleTextColor = KBLUEColor
        toast.messageTextColor = KBlackColor
        toast.duration = 10
        toast.toastPosition = FFToastPosition(rawValue: 2)!
        toast.show({
            self.CheckValidity(CheckValidity:notification.request.content.userInfo["aps"]as! NSDictionary)
        })
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let Demo1: NSString = ((userInfo["aps"]as! NSDictionary)["alert"] as! NSDictionary) ["title"] as! String as NSString
        let Demo2: NSString = ((userInfo["aps"]as! NSDictionary)["alert"] as! NSDictionary)["body"] as! String as NSString
        
        UIApplication.shared.applicationIconBadgeNumber = (userInfo["aps"]as! NSDictionary)["badge"] as! NSInteger
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: UIApplication.shared.applicationIconBadgeNumber)
        
        toast = FFToast.init(toastWithTitle: (Demo1 as String).uppercased(), message: (Demo2 as String).uppercased(), iconImage: #imageLiteral(resourceName: "SplashLOGO"))
        //            toast.toastBackgroundColor = UIColor(red:0.00, green:0.81, blue:0.44, alpha:1.0)
        toast.toastBackgroundColor = UIColor.white
        toast.titleTextColor = KBLUEColor
        toast.messageTextColor = KBlackColor
        //            toast.toastType = FFToastType(rawValue: 2)!
        toast.duration = 10
        toast.toastPosition = FFToastPosition(rawValue: 2)!
        toast.show({
            self.CheckValidity(CheckValidity:userInfo["aps"]as! NSDictionary)
        })
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.CheckValidity(CheckValidity:NSDictionary())
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let Demo1: NSString = ((data["aps"]as! NSDictionary)["alert"] as! NSDictionary) ["title"] as! String as NSString
        let Demo2: NSString = ((data["aps"]as! NSDictionary)["alert"] as! NSDictionary)["body"] as! String as NSString
        print(Demo1)
        print(Demo2)
    //DataPersistence.sharedDataPersistenceInterface.saveValueInDefaults((UIApplication.shared.applicationIconBadgeNumber as Int as AnyObject), storeKey: kHasNotificationCount)
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: UIApplication.shared.applicationIconBadgeNumber)
        
        if application.applicationState == UIApplication.State.inactive {
            completionHandler(UIBackgroundFetchResult.newData)
            // UIApplication.shared.applicationIconBadgeNumber=0
            self.CheckValidity(CheckValidity:data["aps"]as! NSDictionary)
        }else if application.applicationState == UIApplication.State.background
        {
            completionHandler(UIBackgroundFetchResult.newData)
            //UIApplication.shared.applicationIconBadgeNumber=0
            self.CheckValidity(CheckValidity:data["aps"]as! NSDictionary)
        }else if application.applicationState == UIApplication.State.active
        {
            completionHandler(UIBackgroundFetchResult.newData)
//            UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
            toast = FFToast.init(toastWithTitle: (Demo1 as String).uppercased(), message: (Demo2 as String).uppercased(), iconImage: #imageLiteral(resourceName: "SplashLOGO"))
            toast.toastBackgroundColor = UIColor.white
            toast.titleTextColor = KBLUEColor
            toast.messageTextColor = KBlackColor
            //            toast.toastType = FFToastType(rawValue: 2)!
            toast.duration = 10
            toast.toastPosition = FFToastPosition(rawValue: 2)!
            toast.show({
                UIApplication.shared.applicationIconBadgeNumber = 0
//                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let loginPageView = mainStoryboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
//                loginPageView.fromNotification = "fromNotification1"
//                var rootViewController = self.window!.rootViewController as! UINavigationController
//                rootViewController.pushViewController(loginPageView, animated: true)
            })
        }
        // Print notification payload data
        print("Push notification received: \(data)")
    }
    @objc func CheckValidity(CheckValidity:NSDictionary)
    {
        UIApplication.shared.applicationIconBadgeNumber = 0
//        GetNotificationScreen()
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        DeviceToken = deviceTokenString as NSString?
        CurrentDeviceToken = deviceTokenString
        // Print it to console
        print("APNs device token: \(DeviceToken)")
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    @objc func GetIntroSlider() {
        
        //        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        //        statusBar.backgroundColor = UIColor.hexColor(hex: "ffffff", alpha: 1.0)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        mainStoryboard  = UIStoryboard(name: "Main", bundle: nil)
        navigationController = (self.window?.rootViewController as? UINavigationController)
        navigationController = mainStoryboard!.instantiateViewController(withIdentifier: kmainNavigationViewcontroller) as? UINavigationController
        
        navigationController?.viewControllers = [mainStoryboard!.instantiateViewController(withIdentifier: "IntroSliderVC")]
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    @objc func GeteditProfileVC() {
           //   let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
           //   statusBar.backgroundColor = UIColor.hexColor(hex: "ffffff", alpha: 1.0)
           self.window = UIWindow(frame: UIScreen.main.bounds)
           mainStoryboard  = UIStoryboard(name: "Main", bundle: nil)
           navigationController = (self.window?.rootViewController as? UINavigationController)
           navigationController = mainStoryboard!.instantiateViewController(withIdentifier: kmainNavigationViewcontroller) as? UINavigationController
           navigationController?.viewControllers = [mainStoryboard!.instantiateViewController(withIdentifier: "editProfileVC")]
           self.window?.rootViewController = navigationController
           self.window?.makeKeyAndVisible()
       }
    @objc func GetFirstPageVC() {
        //   let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        //   statusBar.backgroundColor = UIColor.hexColor(hex: "ffffff", alpha: 1.0)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        mainStoryboard  = UIStoryboard(name: "Main", bundle: nil)
        navigationController = (self.window?.rootViewController as? UINavigationController)
        navigationController = mainStoryboard!.instantiateViewController(withIdentifier: kmainNavigationViewcontroller) as? UINavigationController
        navigationController?.viewControllers = [mainStoryboard!.instantiateViewController(withIdentifier: "SignInVC")]
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
   
    @objc func GetHomePage() {
        //   let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        //   statusBar.backgroundColor = UIColor.hexColor(hex: "ffffff", alpha: 1.0)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        mainStoryboard  = UIStoryboard(name: "Main", bundle: nil)
        navigationController = (self.window?.rootViewController as? UINavigationController)
        navigationController = mainStoryboard!.instantiateViewController(withIdentifier: kmainNavigationViewcontroller) as? UINavigationController
        
        navigationController?.viewControllers = [mainStoryboard!.instantiateViewController(withIdentifier: "HomeVC")]

      //  addDragableButton(view: self.navigationController!.view)
//        let myButton = DragableButton()
//        self.navigationController!.view.addSubview(myButton)
//        myButton.addDraggability(withinView:  self.navigationController!.view)
//        myButton.addTarget(self, action:#selector(self.HeatingUp), for: .touchUpInside)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
  
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

import Foundation
import UIKit

//MARK: - Global variables
let kmainNavigationViewcontroller = "mainNavigationViewcontroller"

// MARK: - Class NavigationViewController
class  NavigationViewController:UINavigationController , UIGestureRecognizerDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    private func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension UIApplication {
    var visibleViewController : UIViewController? {
        return keyWindow?.rootViewController?.topViewController
    }
}

extension UIViewController {
    fileprivate var topViewController: UIViewController {
        switch self {
        case is UINavigationController:
            return (self as! UINavigationController).visibleViewController?.topViewController ?? self
        case is UITabBarController:
            return (self as! UITabBarController).selectedViewController?.topViewController ?? self
        default:
            return presentedViewController?.topViewController ?? self
        }
    }
}
