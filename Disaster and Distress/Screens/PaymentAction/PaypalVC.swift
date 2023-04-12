//
//  PaypalVC.swift
//  IcerDriveUser
//
//  Created by Groofl on 15/06/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import UIKit
import WebKit

class PaypalVC: UIViewController, WKNavigationDelegate,PopUpVCDelegate {

   @IBOutlet weak var lblTitle: UILabel!
   @IBOutlet weak var webView: WKWebView!
   @IBOutlet weak var btnBack: UIButton!
   
   var tripid = ""
   var totalAmt = ""
    var APIURLIs = ""
    var mydic = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        //webView.UIDelegate = self
        webView.navigationDelegate = self
        displayWebPage()
    }
    
    private func displayWebPage() {
        //(someValue.cleanValue)
        let url1 = "\(APIURLIs)"
        print("Create Payment URL=\(url1)")
        
//        let paymenurl = "\(url1)\(tripid)\( "/")\( totalAmt)"
//        print(paymenurl)
        
           let url = URL(string: "\(url1)")
           let request = URLRequest(url: url!)
           webView.navigationDelegate = self
           webView.load(request)
       }

       func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
           print(error)
       }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url!)
        https://www.alberdriver.com/paypal/5edf868049622b6bbdf3599c/200
        if ((webView.url?.absoluteString.contains("http://3.129.81.143/payment-success")) != nil)
        {
            // self.navigationController?.popViewController(animated: true)
            print("/login/success")
            // Call Class
        }else{
            // self.navigationController?.popViewController(animated: true)
             print("Finished navigating to url \(webView.url)")        }
       
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("#function")
        
        completionHandler(.performDefaultHandling,nil)
    }

    
    func webView(_ webView: WKWebView,decidePolicyFor navigationAction: WKNavigationAction,decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        //let url1 = navigationAction.request.url
              print(url)

       if url.absoluteString.contains("http://3.129.81.143/payment-success") {
//
            print("#function111")
            decisionHandler(.cancel)
            payment()
       }else if url.absoluteString.contains("http://3.129.81.143/payment-cancel") {
                decisionHandler(.cancel)
            self.dismiss(animated: true, completion: nil)
//            let a = self.navigationController!.viewControllers[0] as! MapVC
//            a.Paypaldata = "PaypalPayment"
//            self.navigationController?.popViewController(animated: true)
        
       }
        else {
            decisionHandler(.allow)
        }
    }
    func payment()
    {
        var PopUpVCView: PopUpVC!
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC)
          PopUpVCView.delegate = self
          PopUpVCView.modalTransitionStyle = .crossDissolve
          PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
          self.present(PopUpVCView, animated: true, completion: nil)
          PopUpVCView.checkData(titleImage: #imageLiteral(resourceName: "check-mark"), title:"Payment Done Successfully!!" , titleSubHead1: "", titleSubHead2: "", details: "", btn1title: "Ok", btn2title: "",typeOf:"dynamic",IsCancelBtn:true)
    }
    func PopUpManager(checkType status: String, AlertType: String)  {
                  print(status)
                  if status != "cancel"
                  {
                    if AlertType == "dynamic"
                    {
                                AppDelegate.sharedAppDelegateInterface.GetHomePage()
                      }else {
                          //    self.navigationController?.popViewController(animated: true)
                      }

                  }
              }
    @IBAction func onClickBtnBack(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
//         let a = self.navigationController!.viewControllers[0] as! MapVC
//         a.Paypaldata = "PaypalPayment"
//         self.navigationController?.popViewController(animated: true)
        
       }
}


extension Float
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
