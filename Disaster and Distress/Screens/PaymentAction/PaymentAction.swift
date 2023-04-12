//
//  PaymentAction.swift
//  Disaster and Distress
//
//  Created by Mohit on 07/02/20.
//  Copyright © 2020 Questglt. All rights reserved.
//

import UIKit

class PaymentAction: UIViewController {

    @IBOutlet weak var medicalBtn: UIView!
    @IBOutlet weak var roadSideBtn: UIView!
    @IBOutlet weak var bothBtn: UIView!
    @IBOutlet weak var PaymentBtn: UIButton!
    var typeIs = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        medicalBtn.layer.borderColor = LightGray.cgColor
        roadSideBtn.layer.borderColor = LightGray.cgColor
        bothBtn.layer.borderColor = LightGray.cgColor
        PaymentBtn.isHidden = true
        typeIs = ""
        // Do any additional setup after loading the view.
    }
    
    @IBAction func medical(_ sender: Any) {
        typeIs = "medical"
        PaymentBtn.isHidden = false
        medicalBtn.layer.borderColor = KBLUEColor.cgColor
        roadSideBtn.layer.borderColor = LightGray.cgColor
        bothBtn.layer.borderColor = LightGray.cgColor
    }
    @IBAction func roadSide(_ sender: Any) {
        typeIs = "roadSide"
        PaymentBtn.isHidden = false
        medicalBtn.layer.borderColor = LightGray.cgColor
        roadSideBtn.layer.borderColor = KBLUEColor.cgColor
        bothBtn.layer.borderColor = LightGray.cgColor
       }
    @IBAction func both(_ sender: Any) {
        typeIs = "both"
        PaymentBtn.isHidden = false
        medicalBtn.layer.borderColor = LightGray.cgColor
        roadSideBtn.layer.borderColor = LightGray.cgColor
        bothBtn.layer.borderColor = KBLUEColor.cgColor
       }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.backToViewController(vc: self)
    }
    @IBAction func continueBtn(_ sender: Any) {
        if typeIs == "medical"
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "HelpAlertHistory") as! HelpAlertHistory
            VC.pageType = "Medical Assistance"
            self.navigationController?.pushViewController(VC, animated: true)
        }else if typeIs == "both"
        {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "HelpAlertHistory") as! HelpAlertHistory
            VC.pageType = "Both Services"
            self.navigationController?.pushViewController(VC, animated: true)
        }else{
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "RoadSideVC") as! RoadSideVC
            VC.pageType = "Roadside Assistance"
            self.navigationController?.pushViewController(VC, animated: true)
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
