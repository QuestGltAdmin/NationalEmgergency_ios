//
//  PopUpVC.swift
//  Zega Cookware


import UIKit
@objc protocol PopUpVCDelegate {
    @objc optional func PopUpManager(checkType status: String,AlertType:String)
   
}

class PopUpVC: UIViewController,PopUpVCDelegate {
    var delegate: PopUpVCDelegate?
    
    @IBOutlet weak var xImageContraint: NSLayoutConstraint!
    @IBOutlet weak var widthImg: NSLayoutConstraint!
    @IBOutlet weak var heightImg: NSLayoutConstraint!
    @IBOutlet weak var dropShadow: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var MsgOops: UILabel!
    @IBOutlet weak var MsgLine1: UILabel!
    @IBOutlet weak var MsgLine2: UILabel!
    @IBOutlet weak var MsgLine3: UILabel!
    @IBOutlet weak var btnHelp: UIButton!
    @IBOutlet weak var btnTryAgain: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    
//    @IBOutlet weak var mainV: UIView!
    var TypeOFAlert = ""
    var IsCancelBtn:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
  
    func checkData(titleImage:UIImage,title:String,titleSubHead1:String,titleSubHead2:String,details:String,btn1title:String,btn2title:String,typeOf:String,IsCancelBtn:Bool)
    {
        if titleImage != nil
        {
             img.image = titleImage
        }

        MsgOops.text = title
        MsgLine1.text = titleSubHead1
        
        MsgLine2.text = titleSubHead2
        MsgLine3.text = details
        btnHelp.setTitle(btn1title.uppercased(), for: .normal)
        btnTryAgain.setTitle(btn2title.uppercased(), for: .normal)
        
        MsgOops.isHidden =  title == "" ? true : false
        MsgLine1.isHidden =  titleSubHead1 == "" ? true : false
        MsgLine2.isHidden =  titleSubHead2 == "" ? true : false
        MsgLine3.isHidden =  details == "" ? true : false
        btnHelp.isHidden =  btn1title == "" ? true : false
        btnTryAgain.isHidden =  btn2title == "" ? true : false
        TypeOFAlert = typeOf
        if IsCancelBtn == true
        {
            btnCross.isHidden = true
        }else
        {
            btnCross.isHidden = false
        }
        
        
        if TypeOFAlert == "cooking success" || TypeOFAlert == "heatup success"
        {
            widthImg.constant =  35
            heightImg.constant = 27.7
            xImageContraint.constant = 50
        }else
        if TypeOFAlert == "alert"
        {
            widthImg.constant =  40//35
            heightImg.constant = 40 //27.7
            xImageContraint.constant = 31//59
        }else
        if TypeOFAlert == "success alert"
        {
            widthImg.constant =  35
            heightImg.constant = 27.7
            xImageContraint.constant = 59
        }else
        {
              widthImg.constant =  35
              heightImg.constant = 27.7
              xImageContraint.constant = 59
           
        }
        
        MsgOops.letterSpace = 0.48
        btnHelp.letterSpace = 1.76
        btnTryAgain.letterSpace = 1.76
//        if TypeOFAlert == "alert"
//        {
//            btnCross.isHidden = true
//        }else
//        {
//            btnCross.isHidden = false
//        }
       
    }
    func checkData(title:String,titleSubHead1:String,titleSubHead2:String,details:String,btn1title:String,btn2title:String,typeOf:String,IsCancelBtn:Bool)
    {
        MsgOops.text = title.uppercased()
        MsgLine1.text = titleSubHead1.uppercased()
        MsgLine2.text = titleSubHead2.uppercased()
        MsgLine3.text = details.uppercased()
        btnHelp.setTitle(btn1title.uppercased(), for: .normal)
        btnTryAgain.setTitle(btn2title.uppercased(), for: .normal)
        MsgOops.isHidden =  title == "" ? true : false
        MsgLine1.isHidden =  titleSubHead1 == "" ? true : false
        MsgLine2.isHidden =  titleSubHead2 == "" ? true : false
        MsgLine3.isHidden =  details == "" ? true : false
        btnHelp.isHidden =  btn1title == "" ? true : false
        btnTryAgain.isHidden =  btn2title == "" ? true : false
        widthImg.constant = 0
        heightImg.constant = 0
        TypeOFAlert = typeOf
        if IsCancelBtn == true
        {
            btnCross.isHidden = true
        }else
        {
            btnCross.isHidden = false
        }
        MsgOops.letterSpace = 0.48

        btnHelp.letterSpace = 1.76
        btnTryAgain.letterSpace = 1.76
//        if TypeOFAlert == "alert"
//        {
//            btnCross.isHidden = true
//        }else
//        {
//            btnCross.isHidden = false
//        }
    }
    @IBAction func HelpAction(_ sender: Any) {
      
            delegate?.PopUpManager?(checkType: btnHelp.titleLabel!.text!,AlertType:TypeOFAlert)
            self.dismiss(animated: true, completion: nil)
       
    }
    
    @IBAction func TryAgainAction(_ sender: Any) {
        delegate?.PopUpManager?(checkType: btnTryAgain.titleLabel!.text!,AlertType:TypeOFAlert)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func CloseAction(_ sender: Any) {
        delegate?.PopUpManager?(checkType: "cancel",AlertType:TypeOFAlert)
        self.dismiss(animated: true, completion: nil)
    }
}

import UIKit
@IBDesignable
class RoundShadowView1: UIView {
    @IBInspectable var fillColor: UIColor? {
           didSet {
               updateView()
           }
    }
    @IBInspectable var shadowPathRect: CGFloat = 0 {
           didSet {
               updateView()
        }
    }
    
    var shadowLayer: CAShapeLayer!
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    func updateView() {
        if shadowLayer == nil {
            
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: shadowPathRect).cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor
            shadowLayer.shadowColor = UIColor.lightGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            shadowLayer.shadowOpacity = 10
            shadowLayer.shadowRadius = 5
           
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
class RoundShadowView: UIView {
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 10
    private var fillColor: UIColor = .white // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            shadowLayer.shadowColor = UIColor.lightGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 5
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
