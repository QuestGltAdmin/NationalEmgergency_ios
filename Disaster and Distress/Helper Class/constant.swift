//
//  constant.swift
//  WashApp
//
//  Created by Alok Agrawal on 12/01/17.
//  Copyright © 2017 Quest GLT. All rights reserved.
//

import Foundation
import UIKit

class Constant {
    static var totalItem: CGFloat = 22
    
    static let column: CGFloat = 4
    
    static let minLineSpacing: CGFloat = 0
    static let minItemSpacing: CGFloat = 0
    
    static let offset: CGFloat = 0 // TODO: for each side, define its offset
    static func getItemHeight(boundHeight: CGFloat) -> CGFloat {
        
        return boundHeight/4
    }
    static func getItemWidth(boundWidth: CGFloat) -> CGFloat {
        
        let totalWidth = boundWidth - (offset + offset) - ((column - 1) * minItemSpacing)
        
        return totalWidth / column
    }
}

class Constants {
//    func GetModelToDic(Model:HomeDDKClass) -> [String:Any]
//    {
//        let dic = ["credential_id":Model.credential_id!, "name":Model.name!,"ddkcode":Model.ddkcode!, "passphrase":Model.passphrase!, "second_passphrase":Model.second_passphrase!, "referal_link":Model.referal_link!, "wallet_id":Model.wallet_id!, "notes":Model.notes!, "user_id":Model.user_id!, "created_by":Model.created_by!, "updated_at":Model.updated_at!, "created_at":Model.created_at!, "deleted":Model.deleted!, "deleted_at":Model.deleted_at!, "test_data":Model.test_data!, "deleted_by":Model.deleted_by!, "status":Model.status!] as [String : Any]
//       
//         return dic;
//    }
    
    
   
    // MARK: Server Information
    
    static let baseUrl: String = "http://location-tracker-XXXX.mybluemix.net"
    
    // MARK: App Settings
    
     let locationDisplayCount = 100
     let minMetersLocationAccuracy : Double = 25
     let minMetersLocationAccuracyBackground : Double = 100
     let minMetersBetweenLocations : Double = 15
     let minMetersBetweenLocationsBackground : Double = 100
     let minSecondsBetweenLocations : Double = 15
     let initialMapZoomRadiusMiles : Double = 5
     let offlineMapRadiusMiles: Double = 5
     let placeRadiusMeters: Double = (2.5 * Constants.metersPerMile)
    
    static let metersPerMile = 1609.34
    
    // MARK: Map Providers
    
    static let mapProviders = ["MapKit"]
    //static let mapProviderDefaultStyleIds: [String:String] = ["MapKit":HomeScreen.mapDefaultStyleId]
    
    typealias DemoJhud = (_ obj:AnyObject?, _ success:Bool?,_ OtherStatus:NSString?) -> Void
    static let sharedConstants = Constants()
    // MARK: List of Constants
    
    static let APP_ALERT_TITLE = "Swift Constants"
    static let SAMPLE_MESSAGE = "The alert is working !!"
    let screenSize: CGRect = UIScreen.main.bounds
    // Stake
   
    func Check_From_CurrentStake(Value:Double,CurrentAmount:Double)->Bool {
        //        var getAmount:Double = Value
        //        getAmount = getAmount * Double(KGetAmonut_To_Multiply)
        //
        //        var getAmount_Current:Double = CurrentAmount
        //        getAmount_Current = getAmount_Current * Double(KGetAmonut_To_Multiply)
        
        if Value <= CurrentAmount{
            return true
        }else
        {
            return false
        }
    }
    //MARK: - KETH
    func ChangeStakeAmountInDouble(Value:Double,total_frozen_amt:String)->Double {
        var getAmt:String = total_frozen_amt
        if getAmt == ""
        {
            getAmt = "0"
        }
        let total_frozen_amt1 = Double(getAmt)
        
        var getAmount:Double = Value
        getAmount = (getAmount + total_frozen_amt1!)/100000000
        return getAmount
    }
    
    func CheckMinAmount(Value:Double,total_frozen_amt:String)->Bool {
        var getAmt:String = total_frozen_amt
        if getAmt == ""
        {
            getAmt = "0"
        }
        let total_frozen_amt1 = Double(getAmt)
        //        var getAmount:Double = Value
        //        getAmount = getAmount * Double(KGetAmonut_To_Multiply)
        var getAmount_10000:Double = 10000
        getAmount_10000 = (getAmount_10000 - total_frozen_amt1!)/100000000
        if Value >= getAmount_10000{
            return true
        }
        else{
            return false
        }
    }
   
    func alertMessage(title: String,message: String) {
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButton(withTitle: Msgok)
        alert.tintColor = KBLUEColor
        alert.show()
    }

    // for Category
    static var totalItem: Int = 1
    static var CategorySelection: Int = 0
    static let column: CGFloat = 4
    static let column1: CGFloat = 0
    static let minLineSpacing: CGFloat = 1.0
    static let minItemSpacing: CGFloat = 1.0
    
    static let offset: CGFloat = 1.0 // TODO: for each side, define its offset
    
    static func getItemWidth(boundWidth: CGFloat) -> CGFloat {
        
        let totalWidth = boundWidth - (offset + offset) - ((column - 1) * minItemSpacing)
        
        return totalWidth / column
    }
    
    // for Table
    static var totalItem_table: Int = 1
    static var CategorySelection_table: Int = 0
    static let column_table: CGFloat = 1
    
    static let minLineSpacing_table: CGFloat = 1
    static let minItemSpacing_table: CGFloat = 1
    
    static let offset_table: CGFloat = 5.0 // TODO: for each side, define its offset
    
    static func getItemWidth_table(boundWidth_table: CGFloat) -> CGFloat {
        
        let totalWidth_table = boundWidth_table - (offset_table + offset_table) - ((column_table - 1) * minItemSpacing_table)
        
        return totalWidth_table / column_table
    }
  
}
extension UIColor {
    class func hexColor(hex: String, alpha: CGFloat)-> UIColor {
        var cString = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        if (cString.count != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha))
    }
}

extension Optional where Wrapped == String {
    
    var isBlank: Bool {
        return self.validate.count == 0
    }
    
    var validate: String {
        return self ?? ""
    }
    
}

extension String {
    
    func highlightWordsIn(highlightedWords: String, attributes: [[NSAttributedString.Key: Any]]) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: highlightedWords)
        let result = NSMutableAttributedString(string: self)
        
        for attribute in attributes {
            result.addAttributes(attribute, range: range)
        }
        
        return result
    }
}
extension String {
    func attributedStringWithColor(_ string: String, color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range = (string as NSString).range(of: string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        
        return attributedString
}
}


class AlwaysPresentAsPopover : NSObject, UIPopoverPresentationControllerDelegate {
    // `sharedInstance` because the delegate property is weak - the delegate instance needs to be retained.
    private static let sharedInstance = AlwaysPresentAsPopover()
    var BtnName: String?
    private override init() {
        super.init()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    static func configurePresentation(forController controller : UIViewController,BtnName:String) -> UIPopoverPresentationController {
        
        controller.modalPresentationStyle = .popover
        let presentationController = controller.presentationController as! UIPopoverPresentationController
        AlwaysPresentAsPopover.sharedInstance.BtnName = BtnName
        presentationController.delegate = AlwaysPresentAsPopover.sharedInstance
        return presentationController
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        //setAlphaOfBackgroundViews(alpha: 1)
        let notificationIdentifier: String = "didSelectTopButton"
        let key = ["type":"Dismiss","BtnName":BtnName!] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIdentifier), object: key)
        //delegate?.didFinishAlwaysPresentAsPopover(self, StatusOfPopover: "Dismiss")
        //dismiss(animated: true, completion: nil)
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        let notificationIdentifier: String = "didSelectTopButton"
        let key = ["type":"Present","BtnName":BtnName!] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIdentifier), object: key)
        //setAlphaOfBackgroundViews(alpha: 0.7)
        //delegate?.didFinishAlwaysPresentAsPopover(self, StatusOfPopover: "Present")
        //dismiss(animated: true, completion: nil)
    }
}
extension Double {
    func toStringFrom10(decimal: Int) -> String {
        let value = decimal < 0 ? 0 : decimal
        var string = String(format: "%.\(value)f", self)
        
        while string.last == "0" || string.last == "." {
            if string.last == "." { string = String(string.dropLast()); break}
            string = String(string.dropLast())
        }
        return string
    }
    func toString(decimal: Int = 18) -> String {
        let value = decimal < 0 ? 0 : decimal
        var string = String(format: "%.\(value)f", self)
        
        while string.last == "0" || string.last == "." {
            if string.last == "." { string = String(string.dropLast()); break}
            string = String(string.dropLast())
        }
        return string
    }
}
