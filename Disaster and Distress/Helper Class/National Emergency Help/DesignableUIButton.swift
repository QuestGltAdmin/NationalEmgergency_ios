//
//  DesignableUIButton.swift
//  Zega Cookware
//
//  Created by Mohit on 19/07/19.
//  Copyright © 2019 Questglt. All rights reserved.
//
//9827034790
import UIKit
//import ObjectiveC

// Declare a global var to produce a unique address as the assoc object handle
var disabledColorHandle: UInt8 = 0
var highlightedColorHandle: UInt8 = 0
var setbg: UInt8 = 0
var selectedColorHandle: UInt8 = 0
@IBDesignable

final class CustomButton: UIButton {
    
    override public var isHighlighted: Bool {
        didSet {
            
            self.adjustsImageWhenHighlighted = false
            self.tintColor = .clear
            self.tintColor = isHighlighted ? UIColor.hexColor(hex: "a4a3a3", alpha: 1.0) : UIColor.hexColor(hex: "4A4748", alpha: 1.0)
            print(self.tintColor.cgColor)
        }
    }
 
}

extension UIButton {
    // https://stackoverflow.com/questions/14523348/how-to-change-the-background-color-of-a-uibutton-while-its-highlighted
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }
 
    @IBInspectable
    var disabledColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &disabledColorHandle) as? UIColor {
                self.letterSpace = 1.76
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    @IBInspectable
    var highlightedColor1: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &highlightedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    @IBInspectable
    var setBgColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &setbg) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .normal)
                objc_setAssociatedObject(self, &setbg, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .normal)
                objc_setAssociatedObject(self, &setbg, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    @IBInspectable
    var highlightedColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &highlightedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    @IBInspectable
    var selectedColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &selectedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    @IBInspectable
    var letterSpace: CGFloat {
    set {
    
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = titleLabel?.attributedText {
            attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: titleLabel!.text ?? "")
            titleLabel?.text = nil
            }
        
            attributedString.addAttribute(NSAttributedString.Key.kern,
            value: newValue,
            range: NSRange(location: 0, length: attributedString.length))
            setAttributedTitle(attributedString, for: .normal)
        
        }
    
        get {
        if let currentLetterSpace = titleLabel?.attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
        return currentLetterSpace
        }
        else {
        return 0
        }
        }
    }
    
}
