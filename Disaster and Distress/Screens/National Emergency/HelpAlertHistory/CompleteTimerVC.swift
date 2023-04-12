//
//  CompleteTimerVC.swift
//  Zega Cookware
//
//  Created by Mohit on 09/10/19.
//  Copyright © 2019 Questglt. All rights reserved.
//

import UIKit
@objc protocol CompleteTimerDelegate {
    @objc optional func CompleteTimerManager(checkType status: String,AlertType:String)
}
class CompleteTimerVC: UIViewController {
    var delegate: CompleteTimerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func CloseAction(_ sender: Any) {
           delegate?.CompleteTimerManager?(checkType: "cancel",AlertType:"cancel")
           self.dismiss(animated: true, completion: nil)
       }
    @IBAction func DoneAction(_ sender: Any) {
        delegate?.CompleteTimerManager?(checkType: "cancel",AlertType:"cancel")
        self.dismiss(animated: true, completion: nil)
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
