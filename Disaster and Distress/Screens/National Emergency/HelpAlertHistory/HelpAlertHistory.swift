//
//  HelpAlertHistory.swift
//  Disaster and Distress
//
//  Created by Mohit on 30/10/19.
//  Copyright © 2019 Questglt. All rights reserved.
//

import UIKit
import ZKProgressHUD
struct SelectPaymentData {
    var lat: String?
    var long: String?
    var firstName: String?
    var lastName: String?
    var name: String?
    var user_id: String?
    var charges: String?
   
    var contact: String?
    var conCode: String?
    var opened:Bool?
    var section =  [String]()
    init(with dictionary: [String: Any]?) {
        guard let dictionary = dictionary else {
            return
        }
        charges = dictionary["charges"] as? String
        lat = dictionary["lat"] as? String
        long = dictionary["long"] as? String
        firstName = dictionary["firstName"] as? String
        name = dictionary["name"] as? String
        lastName = dictionary["lastName"] as? String
        contact = dictionary["contact"] as? String
        conCode = dictionary["conCode"] as? String
        user_id = dictionary["_id"] as? String
        opened = false
    }
}
class HelpAlertHistory: UIViewController,UITableViewDelegate,UITableViewDataSource,PopUpVCDelegate {
    var userDict = NSDictionary()
    @IBOutlet weak var tableView: UITableView!
    var CourseList = NSArray()
    var  pageType = ""
    var  pageType1 = ""
    var arr_list = [SelectPaymentData]()

    var MedicalDic = SelectPaymentData(with: [:])

    @IBOutlet weak var planSelectTxt: UILabel!
    @IBOutlet weak var titleLbl: DisolveTransitionLbl!
    @IBOutlet weak var height: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if pageType == "Both Services"
        {
            planSelectTxt.text = "Select Any Plan"
           
        }else
        {
            planSelectTxt.text = ""
            
        }
        height.constant = 0
        titleLbl.TextIS = pageType
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableView.automaticDimension
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name:UIApplication.willEnterForegroundNotification, object: nil)

      }
      @objc func appMovedToForeground() {
        
          if Reachability.isConnectedToNetwork() != true {
              showOfflinePage(Controller: self)
          }else
          {
            if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) != nil)
            {
               userDict = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) as! NSDictionary
                if pageType == "Medical Assistance" || pageType == "Both Services"
                {
                    HitListOfSingle(APIName:"getMedicalServices")
                }else{
                    HitListOfSingle(APIName:"helpHistory")
                }
            }
          }
      }
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          appMovedToForeground()
      }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.backToViewController(vc: self)
    }
    func HitListOfSingle(APIName:String) {
        self.tableView.removeBackgroundText()
        ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: SetGIFName, withExtension: SetGIFType), gifSize: SetGIFSize)
        ZKProgressHUD.setBackgroundColor(.clear)
        let WebDict:[String:Any]  = [
            "user_id":userDict["_id"]!,
         
        ]
        WebService().Post_AUTH(controller: APIName, values: WebDict) { (Data, Status,otherStatus) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                ZKProgressHUD.dismiss()
                if Status == true
                {
                    if(Data?["status"] as! Int) == 1
                    {
                        self.CourseList = Data?["data"] as! NSArray
                        if self.CourseList.count == 0
                        {
                          self.tableView.reloadData()
                          self.tableView.displayBackgroundText(text: "No record found.", fontStyle: "Poppins-Regular", fontSize: 18)
                        }else
                        {
                            if self.pageType == "Medical Assistance" ||  self.pageType == "Both Services"
                            {
                             
                           self.arr_list = [SelectPaymentData]()
                           for (index, element) in self.CourseList.enumerated() {
                               print("Item \(index): \(element)")
                            self.arr_list.append(SelectPaymentData.init(with: self.CourseList[index] as! [String : Any]))
//                               if index == 0
//                               {
//                                   var getData = SelectPaymentData.init(with: self.CourseList[index] as! [String : Any])
//                                   getData.opened = true
//                                   self.arr_list.append(getData)
//                               }else
//                               {
//                                self.arr_list.append(SelectPaymentData.init(with: self.CourseList[index] as! [String : Any]))
//                               }
                           }
                            }
                            self.tableView.reloadData()
                        }
                        
                    }
                    else {
                        self.CourseList = NSArray()
                        self.tableView.reloadData()
                        self.tableView.displayBackgroundText(text: "No record found.", fontStyle: "Poppins-Regular", fontSize: 18)
                   
                    }
                }else
                {
                    if let othervalues : String = otherStatus
                        
                    {
                        customWarningAlert(Controller: self, title: show_Alert, Message: otherStatus!, btn1title: Msgok)
                    }else
                    {
                        customWarningAlert(Controller: self, title: show_Alert, Message: Data?["msg"] as! String, btn1title: Msgok)
                        
                    }
                }
            })
      
        }
        
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pageType == "Medical Assistance" || pageType == "Both Services"
        {
            return arr_list.count
        }else
        {
            return CourseList.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = HelpAlertHistoryCell()
        if pageType == "Medical Assistance" || pageType == "Both Services"
        {
            if pageType == "Medical Assistance"
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "PaymentServiceCell", for: indexPath as IndexPath) as! HelpAlertHistoryCell;
                cell.timeDate.text = "Pay: \(arr_list[indexPath.row].charges!)$"
                cell.name.text = "Medical Names is: \(arr_list[indexPath.row].name!)"
                cell.selectBtn.addTarget(self, action: #selector(self.ViewAddAction1), for: .touchUpInside)
                cell.selectBtn.tag = indexPath.row
            }else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "PaymentServiceCell1", for: indexPath as IndexPath) as! HelpAlertHistoryCell;
                cell.name.text = "Medical Names is: \(arr_list[indexPath.row].name!)\nCharges: \(arr_list[indexPath.row].charges!)$"
                if arr_list[indexPath.row].opened == false
                {
                    cell.selectBtn.setImage(#imageLiteral(resourceName: "dot"), for: .normal)
                }else
                {
                    cell.selectBtn.setImage(#imageLiteral(resourceName: "filldot"), for: .normal)
                }
                cell.selectBtn.addTarget(self, action: #selector(self.ViewAddAction), for: .touchUpInside)
                cell.selectBtn.tag = indexPath.row
            }
            cell.contactNumbr.text = "My contact number is: \(arr_list[indexPath.row].conCode!)\(arr_list[indexPath.row].contact!)"
        
        let getLocationUTL = "https://maps.google.com/maps?q=\(arr_list[indexPath.row].lat!),\(arr_list[indexPath.row].long!)"
//        cell.location.text = "My location is: \("asgdhsgdhjdsghgdsgfhjdgshjfgdhjsfghdsgfhjghdahsdghsagdhsagdhjdsgfhgdshfg")"
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
        let formattedText = String.format(strings: [getLocationUTL],
                                          boldFont: cell.location.font,
                                            boldColor: UIColor.blue,
                                            inString: "My location is: \(getLocationUTL)",
                                            font: cell.location.font,
                                            color: UIColor.black)
        cell.location.attributedText = formattedText
        cell.location.tag = indexPath.row
        cell.location.addGestureRecognizer(tap)
        cell.btnAction.tag = indexPath.row
        cell.btnAction.addTarget(self, action:#selector(crossBtn), for: .touchUpInside)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "HelpAlertHistoryCell", for: indexPath as IndexPath) as! HelpAlertHistoryCell;
                    
                    cell.number.text = "+1 242-426-8307"
                    cell.timeDate.text = changeformate(strDate:"\(((CourseList[indexPath.row] as! NSDictionary)["submitted_at"] as! String))")
                    cell.name.text = "My name is: \((((CourseList[indexPath.row] as! NSDictionary)["user_id"] as! NSDictionary)["firstName"] as! String)) \((((CourseList[indexPath.row] as! NSDictionary)["user_id"] as! NSDictionary)["lastName"] as! String))"
                    cell.contactNumbr.text = "My contact number is: \((((CourseList[indexPath.row] as! NSDictionary)["user_id"] as! NSDictionary)["conCode"] as! String))\((((CourseList[indexPath.row] as! NSDictionary)["user_id"] as! NSDictionary)["contact"] as! String))"
                    let getLocationUTL = "https://maps.google.com/maps?q=\(((CourseList[indexPath.row] as! NSDictionary)["lat"] as! String)),\(((CourseList[indexPath.row] as! NSDictionary)["long"] as! String))"
            //        cell.location.text = "My location is: \("asgdhsgdhjdsghgdsgfhjdgshjfgdhjsfghdsgfhjghdahsdghsagdhsagdhjdsgfhgdshfg")"
                    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
                    let formattedText = String.format(strings: [getLocationUTL],
                                                      boldFont: cell.location.font,
                                                        boldColor: UIColor.blue,
                                                        inString: "My location is: \(getLocationUTL)",
                                                        font: cell.location.font,
                                                        color: UIColor.black)
                    cell.location.attributedText = formattedText
                    cell.location.tag = indexPath.row
                    cell.location.addGestureRecognizer(tap)
                    cell.btnAction.tag = indexPath.row
                    cell.btnAction.addTarget(self, action:#selector(crossBtn), for: .touchUpInside)
        }
        return cell
     
    }
    @IBAction func ViewAddAction1(_ sender: UIButton) {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentChoose1") as! PaymentChoose
                VC.MedicalDic = arr_list[sender.tag]
               VC.getServiceCharges = Int(arr_list[sender.tag].charges!)!
               VC.getTransectionFee = 5
               VC.PaymentType = "Medical Assistance"
               VC.getTransection_user_id = "\(arr_list[sender.tag].user_id!)"
               self.navigationController?.pushViewController(VC, animated: true)
       
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "RoadSideVC") as! RoadSideVC
            VC.MedicalDic = MedicalDic
            VC.pageType = "Both Services"
           self.navigationController?.pushViewController(VC, animated: true)
               
    }
 
    @IBAction func ViewAddAction(_ sender: UIButton) {
         height.constant = 50
        for (index, element) in self.arr_list.enumerated()
        {
            if arr_list[index].opened == true
            {
                arr_list[index].opened = false
            }
        }
        
        if arr_list[sender.tag].opened == true
        {
            arr_list[sender.tag].opened = false
            //DataPersistence.sharedDataPersistenceInterface
        }else
        {
            arr_list[sender.tag].opened = true
        }
        MedicalDic = arr_list[sender.tag]
        tableView.reloadData()
//        if arr_list[sender.tag].opened == true
//                   {
//                       arr_list[sender.tag].opened = false
//                       let section = IndexSet.init(integer: sender.tag)
//                       tableView.reloadSections(section, with: .none)
//                       let dataIndex = sender.tag
//                       if sender.tag != 0 {
//
//                          arr_list[sender.tag].opened = false
//                       }else
//                       {
//
//                           let section = IndexSet.init(integer: sender.tag)
//                           tableView.reloreloadSections(section, with: .none)
//                       }
//
//                   }else
//                   {
//                       tableView.beginUpdates()
//                       var  getIndex = [IndexSet]()
//                       if let row = self.arr_list.index(where: {$0.opened == true}) {
//                           self.arr_list[row].opened = false
//                           // getIndex.append(IndexSet.init(integer: row))
//                           tableView.reloadSections(IndexSet.init(integer: row), with: .none)
//                       }
//
//                       tableView.endUpdates()
//                       arr_list[sender.tag].opened = true
//                       let section = IndexSet.init(integer: sender.tag)
//                       tableView.reloadSections(section, with: .none) // play around with this
//
//                   }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if pageType == "Medical Assistance"
        {
            
        }else
        {
           
        }
        
    }
    @objc func crossBtn(sender:UIButton){
      
        guard let url = URL(string: "https://maps.google.com/maps?q=\(((CourseList[sender.tag] as! NSDictionary)["lat"] as! String)),\(((CourseList[sender.tag] as! NSDictionary)["long"] as! String))") else {
                  return
              }
              if #available(iOS 10, *) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
                  
              } else {
                  UIApplication.shared.openURL(url)
              }
    }
    @objc func handleTermTapped(sender:UITapGestureRecognizer) {
        print("sender")
//        let termString = termText as NSString
//        let termRange = termString.range(of: term)
//        let policyRange = termString.range(of: policy)
//
//        let tapLocation = gesture.location(in: termLabel)
//        let index = termLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
//
//        if checkRange(termRange, contain: index) == true {
////            handleViewTermOfUse()
//            return
//        }
//
//        if checkRange(policyRange, contain: index) {
//            handleViewPrivacy()
//            return
//        }
    }
    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
    func PopUpManager(checkType status: String, AlertType: String) {
        if status != "cancel"
        {
            if AlertType != "alert".uppercased()
            {
                self.navigationController?.popViewController(animated: true)
            }
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
extension String {
    static func format(strings: [String],
                    boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                    boldColor: UIColor = UIColor.blue,
                    inString string: String,
                    font: UIFont = UIFont.systemFont(ofSize: 14),
                    color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: string,
                                    attributes: [
                                        NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor,NSAttributedString.Key.underlineStyle:1] as [NSAttributedString.Key : Any]
        for bold in strings {
//            attributedString.addAttribute(.link, value: string, range: (string as NSString).range(of: bold))
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
            
        }
        return attributedString
    }
}
import UIKit

class HelpAlertHistoryCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var contactNumbr: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timeDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
