//
//  DesignableUITextField.swift
//  KKOGWalletApp
//
//  Created by Alok Agrawal on 17/09/18.
//  Copyright © 2018 Quest GLT. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    
    @IBInspectable var borderColor: UIColor = UIColor.lightGray {
        didSet {
            setBottomBorder1()
        }
    }
    @IBInspectable var fontColor: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    @IBInspectable var linecolor: UIColor = UIColor.lightGray {
        didSet {
            setBottomBorder()
        }
    }
   
    @IBInspectable var leftPadding: CGFloat = 0
        {
        didSet {
            updateViewSpace()
        }
    }
    @IBInspectable var setLeftPadding: Bool = true {
        didSet {
            updateViewSpace()
        }
    }
    @IBInspectable var BGGColor: UIColor = KBGColor {
           didSet {
               setBottomBorder()
           }
       }
    func setBottomBorder1() {
        // change color
        self.borderStyle = .none
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        self.layer.backgroundColor = BGGColor.cgColor
        
    }
    func setBottomBorder() {
        
        // change color
        self.borderStyle = .none
        self.layer.backgroundColor = BGGColor.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = linecolor.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func updateViewSpace() {
        
        leftViewMode = UITextField.ViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.height))
        
        leftView = view
        
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: fontColor])
        
        
    }
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            view.addSubview(imageView)
            leftView = view
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: fontColor])
        
        
    }
    
}


import UIKit

@IBDesignable
class DesignableUITextFieldRight: UITextField {
    // Provides left padding for images
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x += rightPadding
        return textRect
    }
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var borderColor: UIColor = UIColor.lightGray {
        didSet {
            setBottomBorder1()
        }
    }
    @IBInspectable var fontColor: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    @IBInspectable var linecolor: UIColor = UIColor.lightGray {
        didSet {
            setBottomBorder()
        }
    }
    @IBInspectable var CornerRadious: CGFloat = 0 {
        didSet {
            setBottomBorder1()
        }
    }
    //    func setBottomBorder1() {
    //        // change color
    //        self.borderStyle = .none
    //        self.layer.borderWidth = 1
    //        self.layer.borderColor = borderColor.cgColor
    //        self.layer.backgroundColor = UIColor.white.cgColor
    //
    //    }
    func setBottomBorder() {
        // change color
        self.borderStyle = .none
        self.layer.backgroundColor = KBGColor.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = linecolor.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    func setBottomBorder1() {
        // change color
        self.borderStyle = .none
        //self.layer.backgroundColor =  UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = borderColor.cgColor
        //self.layer.linecolor = linecolor.cgColor
        // self.layer.shadowColor = linecolor.cgColor
        //self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        //self.layer.shadowOpacity = 1.0
        //self.layer.shadowRadius = 0.0
        self.layer.cornerRadius = CornerRadious
    }
    func updateView() {
        if let image = rightImage {
            leftViewMode = UITextField.ViewMode.always
            rightViewMode = UITextField.ViewMode.always
            let leftview = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            let view = UIView(frame: CGRect(x: self.bounds.width - 40, y: 0, width: 40, height: 40))
            let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            view.addSubview(imageView)
            leftView = leftview
            rightView = view
            
        } else {
            
            
            rightViewMode = UITextField.ViewMode.never
            leftViewMode = UITextField.ViewMode.always
            let leftview = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            leftView  = leftview
            rightView  = nil
        }
        
        //        if rightPadding != 0
        //        {
        //            leftViewMode = UITextField.ViewMode.always
        //            rightViewMode = UITextField.ViewMode.always
        //            let leftview = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: rightPadding))
        //            rightView = leftview
        //        }else
        //        {
        //            rightViewMode = UITextField.ViewMode.never
        //            leftViewMode = UITextField.ViewMode.never
        //            rightView = nil
        //            leftView  = nil
        //        }
        
        // Placeholder text color
        //        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        
    }
    
}

//extension UITextField{
//    @IBInspectable var placeHolderColor: UIColor? {
//        get {
//            return self.placeHolderColor
//        }
//        set {
//            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
//        }
//    }
//}
