//
//  DataPersistence.swift
//
//  Created by Suprem Vanam on 21/12/15.
//  Copyright © 2015 Suprem Vanam. All rights reserved.


import Foundation
import UIKit
import NVActivityIndicatorView

// Mark


let activityData = ActivityData()
let App_Device_Token = (UIApplication.shared.delegate! as! AppDelegate).DeviceToken == nil ? "" : (UIApplication.shared.delegate! as! AppDelegate).DeviceToken

func indexKeyedDictionary1(fromArray array: [String : Any]?) -> [AnyHashable : Any]? {
    var prunedDictionary: [AnyHashable : Any] = [:]
    for getKey in (array?.keys)!
    {
        if !(array![getKey] is NSNull) {
            prunedDictionary[getKey] = array?[getKey]
        }
    }
    
    return prunedDictionary
}
func indexKeyedDictionary(fromArray array: [String : Any]?) -> [AnyHashable : Any]? {
    var prunedDictionary: [AnyHashable : Any] = [:]
    for getKey in (array?.keys)!
    {
        if !(array![getKey] is NSNull) {
            
            if let translations = array![getKey] as? [String : Any]? {
                var prunedDictionary1: [AnyHashable : Any] = [:]
                for getKey1 in (translations?.keys)!
                {
                    if !(translations![getKey1] is NSNull) {
                        prunedDictionary1[getKey1] = translations?[getKey1]
                    }
                }
                if prunedDictionary1.count != 0
                {
                    prunedDictionary[getKey] = prunedDictionary1
                }
                
            }else{
                prunedDictionary[getKey] = array?[getKey]
            }
        }
        
    }
    
    return prunedDictionary
}
func GetImageCorrect(ImageURL:String) -> String
{
    if ImageURL == ""
    {
        return ImageURL
    }else
    {
        return ImageURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
}
let kMapsAPIKey = "AIzaSyBIJp-bTcgi44dwg6EuhLxRNjIG79d1hXc"//"//AIzaSyDc7RVvuHDRkoiYKjPpHNS0yf_XgtyJrGM" "AIzaSyChkd9sNOt38pQN4LpLTv8HWXT-mJUI8Sc"
var CurrentAddress:String?
var CurrentDeviceToken:String = ""
// loader
let SetGIFName = "loading"
let SetGIFType = "gif"
let SetGIFSize: CGFloat = 75
let ContactNumber:UInt64 = 9669663356

// APIURL
var MainURL = "http://3.129.81.143/"//http://194.42.126.38:3007/"//http://ddhelpapp.net/"//http://192.168.1.210:3900/"
////http://125.99.189.250:3900/" Production
//"http://192.168.1.210:3900/" Development
var APIURL:String = "\(MainURL)"
var APIURLProfile:String = "\(MainURL)/uploads"
var BaseURL:String = "\(MainURL)/api/baseurl"
var category_image:String = "\(MainURL)public/uploads/category_image/"
var recepie_image:String = "\(MainURL)public/uploads/recepie_image/"
var APILanguage:String = "https://www.googleapis.com/language/translate/v2?key=AIzaSyDKvMz3VIGboqJZAIUyIJomdfIQFN83wwE"

// All purpose
let NlockOK = NSLocalizedString("OK", comment:"OK")
//let NLockConnection = NSLocalizedString("Make sure your device is connected to the internet.".localized(), comment:"Make sure your device is connected to the internet.".localized())
let NlockNoRecordFound = NSLocalizedString("No Record Found", comment:"No Record Found")
//let NlockMessage = NSLocalizedString("Message".localized(), comment:"Message".localized())
let NPullToRefresh = NSLocalizedString("Pull to refresh", comment:"Pull to refresh")

let kIS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
let kSCREEN_X = UIScreen.main.bounds.origin.x
let kSCREEN_Y = UIScreen.main.bounds.origin.y
let kSCREEN_WIDTH = UIScreen.main.bounds.size.width
let kSCREEN_HEIGHT = UIScreen.main.bounds.size.height

let kSCREEN_MAX_LENGTH = max(kSCREEN_WIDTH, kSCREEN_HEIGHT)
let kSCREEN_MIN_LENGTH = min(kSCREEN_WIDTH, kSCREEN_HEIGHT)

let kIS_IPHONE_4_OR_LESS = (kIS_IPHONE && kSCREEN_MAX_LENGTH < 568.0)
let kIS_IPHONE_5 = (kIS_IPHONE && kSCREEN_MAX_LENGTH == 568.0)
let kIS_IPHONE_5S = (kIS_IPHONE && kSCREEN_MAX_LENGTH == 568.0)
let kIS_IPHONE_SE = (kIS_IPHONE && kSCREEN_MAX_LENGTH == 568.0)
let kIS_IPHONE_6 = (kIS_IPHONE && kSCREEN_MAX_LENGTH == 667.0)
let kIS_IPHONE_6P = (kIS_IPHONE && kSCREEN_MAX_LENGTH == 736.0)
let kIS_IPHONE_10P = (kIS_IPHONE && kSCREEN_MAX_LENGTH == 812.0)
let kIS_IPHONE_10Max = (kIS_IPHONE && kSCREEN_MAX_LENGTH == 896.0)
let kIS_IPHONE_11Max = (kIS_IPHONE && kSCREEN_MAX_LENGTH == 896.0)
let kIS_IPHONE_8 = (kIS_IPHONE && kSCREEN_MAX_LENGTH == 667.0 && kSCREEN_WIDTH == 375)
//var NLockConnection = "Make sure your device is connected to the internet."
// userDefault
//var NlockMessage = "Message"
let kHasUserData = "userdata"
let kHasplotMe = "plotMe"

let kHasManageDevice = "ManageDevice"

var KHasAccidentDict:NSDictionary = NSDictionary()


// colors
let KBlackColor = UIColor.black
let KWhiteColor = UIColor.white
let KBGColor = UIColor.hexColor(hex: "FFFFFF", alpha: 1.0)
let KBLUEColor = UIColor.hexColor(hex: "073A93", alpha: 1.0)
let LightGray = UIColor.hexColor(hex: "EDEDED", alpha: 1.0)


public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 3, height: 3)) {
        //        let rect = CGRect(origin: .zero, size: size)
        
        //        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        //        color.setFill()
        //        UIRectFill(rect)
        //        let image = UIGraphicsGetImageFromCurrentImageContext()
        //
        //        UIGraphicsEndImageContext()
        //
        //        guard let cgImage = image?.cgImage else { return nil }
        //        self.init(cgImage: cgImage)
        
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        ctx.setFillColor(color.cgColor)
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.setLineWidth(10)
        ctx.fillEllipse(in: rect)
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        guard let cgImage = img.cgImage else { return nil }
        self.init(cgImage: cgImage)
        
    }
}

public extension UIImage {
    class func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
}

//MARK: - userDefault

let kHasVerifyType = "VerifyType"


var APIType:String = "Test" //"Live" or Test


func changeDateformate(strDate:String) -> String{
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
    let showDate = inputFormatter.date(from: strDate)
    inputFormatter.dateFormat = "MMM dd "
    let resultString = inputFormatter.string(from: showDate!)
    return "\(resultString)"
}
func changeTimeformate(EndTime:String) -> String{
    print(EndTime)
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "HH:mm"
    let showETime = inputFormatter.date(from: EndTime)
    inputFormatter.dateFormat = "h:mm a"
    inputFormatter.amSymbol = "AM"
    inputFormatter.pmSymbol = "PM"
    let resultStringETime = inputFormatter.string(from: showETime!)
    return "\(resultStringETime)"
}

func GetbackgroundImage(view:UIView) -> UIImage
{
    UIGraphicsBeginImageContext(view.frame.size)
    #imageLiteral(resourceName: "LoginBG").draw(in: view.bounds)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
func GetBannerImage(view:UIView) -> UIImage
{
    UIGraphicsBeginImageContext(view.frame.size)
    #imageLiteral(resourceName: "Background").draw(in: view.bounds)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

func getType(activityType:UIActivity.ActivityType) -> String
{
    print(activityType.rawValue)
    
    if (activityType.rawValue == "com.linkedin.LinkedIn.ShareExtension") {
        return "linkedIn"
    }else
        if (activityType.rawValue == "net.whatsapp.WhatsApp.ShareExtension") {
            return "whatsApp"
        }else
            if (activityType.rawValue == "com.google.Gmail.ShareExtension") {
                return "gmail"
            }else
                if (activityType == .postToFacebook) {
                    return "facebook"
                }else
                    if (activityType == .postToTwitter) {
                        return "twitter"
                    }else if (activityType == .postToWeibo) {
                        return "weibo"
                    }else
                        if (activityType == .message) {
                            return "message"
                        }else if (activityType == .mail) {
                            return "mail"
                        }else
                            if (activityType == .print) {
                                return "print"
                            }else if (activityType == .copyToPasteboard) {
                                return "copyToPasteboard"
                            }else
                                if (activityType == .assignToContact) {
                                    return "assignToContact"
                                }else
                                    if (activityType == .saveToCameraRoll) {
                                        return "saveToCameraRoll"
                                    }else
                                        if (activityType == .addToReadingList) {
                                            return "addToReadingList"
                                        }else if (activityType == .postToFlickr) {
                                            return "flickr"
                                        }else
                                            if (activityType == .postToVimeo) {
                                                return "vimeo"
                                            }else if (activityType == .postToTencentWeibo) {
                                                return "tencentWeibo"
                                            }else
                                                if (activityType == .airDrop) {
                                                    return "airDrop"
                                                }else if (activityType == .openInIBooks) {
                                                    return "openInIBooks"
                                                }else
                                                {
                                                    return activityType.rawValue
    }
    
}
//MARK:- UITableView Extension
extension UITableView {
    func reloadDataInMain() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func displayBackgroundText(text: String, fontStyle: String = "Montserrat-Regular", fontSize: CGFloat = 16.0) {
        let lbl = UILabel();
        
        if let headerView = self.tableHeaderView {
            lbl.frame = CGRect(x: 0, y: headerView.bounds.size.height, width: self.bounds.size.width, height: self.bounds.size.height - headerView.bounds.size.height)
        } else {
            lbl.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height);
        }
        lbl.text = text;
        lbl.textColor = .gray
        lbl.numberOfLines = 0;
        lbl.textAlignment = .center;
        lbl.font = UIFont(name: fontStyle, size:fontSize);
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
        backgroundView.addSubview(lbl);
        self.backgroundView = backgroundView;
    }
    func displayBackgroundTextFromHeader(text: String, fontStyle: String = "Montserrat-Regular", fontSize: CGFloat = 16.0) {
        let lbl = UILabel();
        
        if let headerView = self.tableHeaderView {
            lbl.frame = CGRect(x: 0, y: headerView.bounds.size.height + 20, width: self.bounds.size.width, height: self.bounds.size.height - headerView.bounds.size.height)
        } else {
            lbl.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height);
        }
        lbl.text = text;
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 0;
        lbl.textAlignment = .center;
        lbl.font = UIFont(name: fontStyle, size:fontSize);
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
        backgroundView.addSubview(lbl);
        self.backgroundView = backgroundView;
    }
    func removeBackgroundText() {
        self.backgroundView = nil
    }
}
//MARK: - DataPersistence Class
class DataPersistence : NSObject{
    @objc static let sharedDataPersistenceInterface = DataPersistence()
    
    //Any Object can pass here to store.
    @objc func saveValueInDefaults(_ value: AnyObject,storeKey: String)  {
        UserDefaults.standard.set(value, forKey: storeKey)
        UserDefaults.standard.synchronize()
        
    }
    
    
    @objc func getValueForKey(_ storeKey:String) -> AnyObject? {
        if let value = UserDefaults.standard.object(forKey: storeKey) {
            return value as AnyObject?
        }
        return nil
    }
    @objc func deleteKey(_ storeKey:String) {
        UserDefaults.standard.removeObject(forKey: storeKey)
    }
}

import UIKit
import Foundation
import SystemConfiguration

class Reachability: NSObject {
    @objc class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}

import UIKit

class ValidationVC: NSObject {
    
    func getStrHTML(string:NSString) ->String
    {
        
        //var string = "<!DOCTYPE html> <html> <body> <h1>My First Heading</h1> <p>My first paragraph.</p> </body> </html>"
        var str = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: string.range(of: string as String))
        let hh = str.replacingOccurrences(of: " &quot;", with: "\n", options: .regularExpression, range: str.range(of: string as String))
        let Main = hh.replacingOccurrences(of: "&[^;]+;", with: "", options: .regularExpression, range: hh.range(of: string as String))
        
        str = str.withoutHtml
        
        return Main
        
        
    }
    
    // Email Validation :
    @objc func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    // Email and phone Validation :
    @objc func isValidEmailAndPhone(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let PHONE_REGEX = "([0-9]{8,10})$"
        //let PHONE_REGEX = "(^(\"+?\"-? *[0-9]+)([,0-9 ]*)([0-9 ])*$)|(^ *$)"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: testStr)
        
        return emailTest.evaluate(with: testStr) || result
    }
    // Phone Number validation :
    @objc func isvalidatePhoneNumber(value: String) -> Bool {
        //let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        print(value.count)
        if value.count < 9 || value.count > 15 {
            return false
        }
        else{
            return true
        }
    }
    @objc func isvalidatePhoneNumber2(value: String) -> Bool {
        //let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        print(value.count)
        if value.count < 9{
            return false
        }
        else{
            return true
        }
       
    }
    // Phone Number validation :
    @objc func isvalidatePhoneNumber1(value: String) -> Bool {
        let PHONE_REGEX = "(([+]{1}|[0]{2}){0,1}+[1]{1}){0,1}+[ ]{0,1}+(?:[-( ]{0,1}[0-9]{3}[-) ]{0,1}){0,1}+[ ]{0,1}+[0-9]{2,3}+[0-9- ]{4,8}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    @objc func validatePhone(value: String) -> Bool {
        let PHONE_REGEX = "([0-9]{8,10})$"
        //let PHONE_REGEX = "(^(\"+?\"-? *[0-9]+)([,0-9 ]*)([0-9 ])*$)|(^ *$)"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    // Pincode validation :
    @objc func isValidPincode(value: String) -> Bool {
        if value.count == 6{
            return true
        }
        else{
            return false
        }
    }
    // Password validation :
    @objc func isValidPassword(value: String) -> Bool {
        if value.count >= 8{
            return true
        }
        else{
            return false
        }
    }
    
    @objc func isPasswordSame(password: String , confirmPassword : String) -> Bool {
        if password == confirmPassword{
            return true
        }
        else{
            return false
        }
    }
    
    
    // Password length validation : length should grater than 7.
    @objc func isPwdLenth(password: String , confirmPassword : String) -> Bool {
        if password.count <= 7 && confirmPassword.count <= 7{
            return true
        }
        else{
            return false
        }
    }
    
    
    
    @objc class func someTypeMethod() {
        // type method implementation goes here
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension String {
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
}
func changeformate(strDate:String) -> String{
  if strDate.count != 0 || strDate != "0000-00-00 00:00:00" || strDate != ""
  {
      let inputFormatter = DateFormatter()
      inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
  if changeDateFormate(checkData: inputFormatter.date(from: strDate))
  {
      let showDate = inputFormatter.date(from: strDate)
      inputFormatter.dateFormat = "dd/MM/yyyy | hh:mm a"
      if showDate != nil
      {
          let resultMM = inputFormatter.string(from: showDate!)
          let datetime  = resultMM
          return datetime
      }else
      {
          if strDate == "0000-00-00 00:00:00"
          {
              return ""
          }else{
              return strDate
          }
          
      }
      
  }else{
      inputFormatter.dateFormat = "yyyy-MM-dd"
      let showDate = inputFormatter.date(from: strDate)
      inputFormatter.dateFormat = "dd MMM, yyyy"
      if let state_name_en = showDate
      {
          let resultMM = inputFormatter.string(from: showDate!)
          let datetime  = resultMM
          return datetime
      }else
      {
          if strDate == "0000-00-00 00:00:00"
          {
              return ""
          }else{
              return strDate
          }
      }
  }
      
  }else{
      return strDate
  }
}
func changeDateFormate(checkData:Any) -> Bool
{
    guard let id = checkData as? NSDate else {
        return false
    }
    return true
}
