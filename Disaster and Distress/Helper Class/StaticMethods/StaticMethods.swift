//
//  StaticMethods.swift
//  Zega Cookware
//
//  Created by Ayushi on 15/07/19.
//  Copyright © 2019 Questglt. All rights reserved.
//

import UIKit


extension UINavigationController {
    func backToViewController(vc: Any) {
        self.popViewController(animated: true)
    }
//    func backToViewController(vc: Any) {
//        // iterate to find the type of vc
//        for element in viewControllers as Array {
//            if "\(type(of: element)).Type" == "\(type(of: (vc as AnyObject)))" {
//                self.popToViewController(element, animated: true)
//                break
//            }
//        }
//    }
    func popViewController(animated: Bool, completion: @escaping () -> ()) {
        popViewController(animated: animated)
        
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}

func checkStringNull(checkData:Any) -> String
{
    guard let id = checkData as? String else {
        return ""
    }
    return id
}

func changeStringToInt(checkData:Any) -> Int
{
    guard let id = checkData as? Int else {
        return 0
    }
    return id
}
func checkFloatForIngredent(checkData:String,count:Int) -> String
{
   
    guard let id = Float(checkData) as? Float else {
        return checkData as! String
    }
    
    return "\(Float(checkData)! * Float(count))"
    
}

func changeStringToFloat(checkData:Any) -> Float
{
    guard let id = checkData as? Float else {
        return 0.0
    }
    return id
}

func changeNSDictionaryNull(checkData:Any) -> NSDictionary
{
    guard let id = checkData as? NSDictionary else {
        return [:]
    }
    return id
}
func changeNSArrayNull(checkData:Any) -> NSArray
{
    guard let id = checkData as? NSArray else {
        return []
    }
    return id
}
func startCookingAction1(Controller:UIViewController,TypeIs:String,ISDragable:Bool)
{
    //    var PopUpVCView: CheckStatusVC!
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    CheckStatusVCTimer = (storyboard.instantiateViewController(withIdentifier: "CheckStatusVC") as! CheckStatusVC)
//    Controller.present(CheckStatusVCTimer, animated: true, completion: nil)
//    if ISDragable == true
//    {
//        CheckStatusVCTimer.runTimer()
//    }
    
}

func getPopUpAlert(Controller:UIViewController,title:String,titleSubHead1:String,titleSubHead2:String,details:String,btn1title:String,btn2title:String)
{
    var PopUpVCView: PopUpVC!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC)
    PopUpVCView.delegate = Controller as! PopUpVCDelegate
    PopUpVCView.modalTransitionStyle = .crossDissolve
    PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    Controller.present(PopUpVCView, animated: true, completion: nil)
    PopUpVCView.checkData(title: title, titleSubHead1: titleSubHead1, titleSubHead2: titleSubHead2, details: details, btn1title: btn1title, btn2title: btn2title, typeOf:"alert", IsCancelBtn:true)
}
func getPopUpAlert(Controller:UIViewController,titleImage:UIImage,title:String,titleSubHead1:String,titleSubHead2:String,details:String,btn1title:String,btn2title:String)
{
    var PopUpVCView: PopUpVC!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC)
    PopUpVCView.delegate = Controller as! PopUpVCDelegate
    PopUpVCView.modalTransitionStyle = .crossDissolve
    PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    Controller.present(PopUpVCView, animated: true, completion: nil)
    PopUpVCView.checkData(titleImage: titleImage, title: title, titleSubHead1: titleSubHead1, titleSubHead2: titleSubHead2, details: details, btn1title: btn1title, btn2title: btn2title,typeOf:"alert", IsCancelBtn:true)
}
func customWarningAlert(Controller:UIViewController,title:String,Message:String,btn1title:String)
{
    var PopUpVCView: PopUpVC!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC)
    PopUpVCView.delegate = Controller as! PopUpVCDelegate
    PopUpVCView.modalTransitionStyle = .crossDissolve
    PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    Controller.present(PopUpVCView, animated: true, completion: nil)
    PopUpVCView.checkData(titleImage:  #imageLiteral(resourceName: "warning-1"), title: Message, titleSubHead1: "", titleSubHead2: "", details: "", btn1title: btn1title, btn2title: "",typeOf:"alert", IsCancelBtn:true)
}
func customWarningSuccessAlert(Controller:UIViewController,title:String,Message:String,btn1title:String)
{
    var PopUpVCView: PopUpVC!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC)
    PopUpVCView.delegate = Controller as! PopUpVCDelegate
    PopUpVCView.modalTransitionStyle = .crossDissolve
    PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    Controller.present(PopUpVCView, animated: true, completion: nil)
    PopUpVCView.checkData(titleImage:  #imageLiteral(resourceName: "check-mark"), title: Message, titleSubHead1: "", titleSubHead2: "", details: "", btn1title: btn1title, btn2title: "",typeOf:"success alert", IsCancelBtn:true)
}
func customHeatupSuccess(Controller:UIViewController,title:String,Message:String,btn1title:String)
{
    var PopUpVCView: PopUpVC!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC)
    PopUpVCView.delegate = Controller as! PopUpVCDelegate
    PopUpVCView.modalTransitionStyle = .crossDissolve
    PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    Controller.present(PopUpVCView, animated: true, completion: nil)
    PopUpVCView.checkData(titleImage:  #imageLiteral(resourceName: "check-mark"), title: Message, titleSubHead1: "", titleSubHead2: "", details: "", btn1title: btn1title, btn2title: "",typeOf:"heatup success", IsCancelBtn:true)
}
func customHeatupBrouse(Controller:UIViewController,title:String,Message:String,btn1title:String)
{
    var PopUpVCView: PopUpVC!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC)
    PopUpVCView.delegate = Controller as! PopUpVCDelegate
    PopUpVCView.modalTransitionStyle = .crossDissolve
    PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    Controller.present(PopUpVCView, animated: true, completion: nil)
    PopUpVCView.checkData(titleImage:  #imageLiteral(resourceName: "check-mark"), title: Message, titleSubHead1: "", titleSubHead2: "", details: "", btn1title: btn1title, btn2title: "",typeOf:"heatup brouse", IsCancelBtn:true)
}
func customCookingCompleteAlert(Controller:UIViewController,title:String,Message:String,btn1title:String)
{
    var PopUpVCView: PopUpVC!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC)
    PopUpVCView.delegate = Controller as! PopUpVCDelegate
    PopUpVCView.modalTransitionStyle = .crossDissolve
    PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    Controller.present(PopUpVCView, animated: true, completion: nil)
    PopUpVCView.checkData(titleImage:  #imageLiteral(resourceName: "check-mark"), title: Message, titleSubHead1: "", titleSubHead2: "", details: "", btn1title: btn1title, btn2title: "",typeOf:"cooking success", IsCancelBtn:true)
}
func getPopUpAlertAction(Controller:UIViewController,titleImage:UIImage,title:String,titleSubHead1:String,titleSubHead2:String,details:String,btn1title:String,btn2title:String,IsCancelBtnHidden:Bool)
{
    var PopUpVCView: PopUpVC!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC)
    PopUpVCView.delegate = Controller as! PopUpVCDelegate
    PopUpVCView.modalTransitionStyle = .crossDissolve
    PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    Controller.present(PopUpVCView, animated: true, completion: nil)
    PopUpVCView.checkData(titleImage: titleImage, title: title, titleSubHead1: titleSubHead1, titleSubHead2: titleSubHead2, details: details, btn1title: btn1title, btn2title: btn2title,typeOf:"action",IsCancelBtn:IsCancelBtnHidden)
}

func getPopUpAlertAction(Controller:UIViewController,titleImage:UIImage,title:String,titleSubHead1:String,titleSubHead2:String,details:String,btn1title:String,btn2title:String,IsCancelBtnHidden:Bool,IsType:String)
{
    var PopUpVCView: PopUpVC!
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC)
    PopUpVCView.delegate = Controller as! PopUpVCDelegate
    PopUpVCView.modalTransitionStyle = .crossDissolve
    PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    Controller.present(PopUpVCView, animated: true, completion: nil)
    PopUpVCView.checkData(titleImage: titleImage, title: title, titleSubHead1: titleSubHead1, titleSubHead2: titleSubHead2, details: details, btn1title: btn1title, btn2title: btn2title,typeOf:IsType,IsCancelBtn:IsCancelBtnHidden)
}

class StaticMethods: NSObject {

}
