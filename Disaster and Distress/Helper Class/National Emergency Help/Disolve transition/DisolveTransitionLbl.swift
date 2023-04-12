//
//  DesignableUIButton.swift
//  Zega Cookware
//
//  Created by Mohit on 19/07/19.
//  Copyright © 2019 Questglt. All rights reserved.
//

import UIKit
import ObjectiveC

// Declare a global var to produce a unique address as the assoc object handle
//var disabledColorHandle: UInt8 = 0
//var highlightedColorHandle: UInt8 = 0
//var selectedColorHandle: UInt8 = 0
open class CustomLabel : UILabel {
    @IBInspectable open var characterSpacing:CGFloat = 1 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text!)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: self.characterSpacing, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
        
    }
}
extension UILabel {
    
    @IBInspectable
    var letterSpace: CGFloat {
        set {
           
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }

            attributedString.addAttribute(NSAttributedString.Key.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))

            attributedText = attributedString
        }
        
        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
}

@IBDesignable
class CustomBlurView1: UIView {
    @IBInspectable var checkBlur: Bool = false
        {
        didSet {
            blurImage()
        }
    }
    func blurImage()
    {
        if checkBlur == true{
            //            var darkBlur:UIBlurEffect = UIBlurEffect()
            ////            self.alpha = CGFloat(Double(round(100*Double(1))/100))
            //            if #available(iOS 10.0, *) { //iOS 10.0 and above
            //                darkBlur = UIBlurEffect(style: UIBlurEffect.Style.prominent)//prominent,regular,extraLight, light, dark
            //            } else { //iOS 8.0 and above
            //                darkBlur = UIBlurEffect(style: UIBlurEffect.Style.extraLight) //extraLight, light, dark
            //            }
            let darkBlur = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
            
            darkBlur.setValue(40, forKey: "blurRadius")
            
            let blurView = UIVisualEffectView(effect: darkBlur)
            blurView.frame = self.frame //your view that have any objects
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.tintColor = KBGColor.withAlphaComponent(1)//UIColor.init(white: 1, alpha: 0.80)
            self.addSubview(blurView)
        }
    }
}
class CustomBlurView: UIView {
    @IBInspectable var checkBlur: Bool = false
        {
        didSet {
            blurImage()
        }
    }
    func blurImage()
    {
        if checkBlur == true{
//            var darkBlur:UIBlurEffect = UIBlurEffect()
////            self.alpha = CGFloat(Double(round(100*Double(1))/100))
//            if #available(iOS 10.0, *) { //iOS 10.0 and above
//                darkBlur = UIBlurEffect(style: UIBlurEffect.Style.prominent)//prominent,regular,extraLight, light, dark
//            } else { //iOS 8.0 and above
//                darkBlur = UIBlurEffect(style: UIBlurEffect.Style.extraLight) //extraLight, light, dark
//            }
            let darkBlur = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()

            darkBlur.setValue(20, forKey: "blurRadius")

            let blurView = UIVisualEffectView(effect: darkBlur)
            blurView.frame = self.frame //your view that have any objects
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.tintColor = KBGColor.withAlphaComponent(0.80)//UIColor.init(white: 1, alpha: 0.80)
            self.addSubview(blurView)
        }
    }
}
@IBDesignable
class DisolveTransitionLbl: UILabel {
    @IBInspectable var DisolveTransition: Bool = false
    {
        didSet {
            updateViewSpace()
        }
    }
    @IBInspectable var TextIS: String = ""
        {
        didSet {
            
        }
    }
  
    func updateViewSpace() {
        if DisolveTransition == true{
            UIView.transition(with: self, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                self.text = ""
            }, completion: { (finished: Bool) -> () in
                self.text = self.TextIS
            })
//            UIView.transition(from: self, to: self, duration: 0.8, options: [.transitionCrossDissolve]) { (status) in
//
//            }
//            UIView.animate(withDuration: 0.8, animations: {
//                self.alpha = 0.0
//            }, completion: {
//                (value: Bool) in
//                self.alpha = 1
//            })
        }
    }
}
