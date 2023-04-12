//
//  RoadSideVC.swift
//  Disaster and Distress
//
//  Created by Mohit on 08/02/20.
//  Copyright © 2020 Questglt. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import ZKProgressHUD
class RoadSideVC: UIViewController,GMSMapViewDelegate,PopUpVCDelegate {
    @IBOutlet weak var mapV: GMSMapView!
    @objc var str_lat :String = ""
    @objc var str_long :String = ""
    var userDict = NSDictionary()
    var Currentlat1:CLLocationDegrees?
    var Currentlong1:CLLocationDegrees?
    var Currentlat_Select:CLLocationDegrees?
    var Currentlong_Select:CLLocationDegrees?
    var Zoom: Float = 14
    var arr_list = [SelectPaymentData]()
    var selectedDic = SelectPaymentData(with: [:])
    var MedicalDic = SelectPaymentData(with: [:])
    @IBOutlet weak var nameService: UILabel!
    @IBOutlet weak var MobileName: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var noService: UIView!
    @IBOutlet weak var popUpBack: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpGShadowView: RoundShadowView1!
    @IBOutlet weak var titleLbl: UILabel!
    var  pageType = ""

    @IBOutlet weak var titlePayment: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        PopUpShow(status: true, userData: SelectPaymentData(with: [:]))
        if pageType == "Both Services"
        {
            titleLbl.text = "Select Any Plan"
        }else
        {
            titleLbl.text = ""
        }
        noService.isHidden = true
        mapV.isHidden = true
        if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) != nil)
         {
            userDict = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) as! NSDictionary
         }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name:UIApplication.willEnterForegroundNotification, object: nil)
        appMovedToForeground()
        // Do any additional setup after loading the view.
    }
    func HitListOfSingle(APIName:String) {
        ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: SetGIFName, withExtension: SetGIFType), gifSize: SetGIFSize)
        ZKProgressHUD.setBackgroundColor(.clear)
        let getPr = LocationManager.sharedLocationManager.location?.coordinate

        let WebDict:[String:Any]  = [
            "user_id":userDict["_id"]!,
            "lat":getPr!.latitude,
            "long":getPr!.longitude,
        ]
        WebService().Post_AUTH(controller: APIName, values: WebDict) { (Data, Status,otherStatus) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                ZKProgressHUD.dismiss()
                if Status == true
                {
                    if(Data?["status"] as! Int) == 1
                    {
                        let CourseList = Data?["data"] as! NSArray
                        if CourseList.count == 0
                        {
                            self.noService.isHidden = false
                            self.mapV.isHidden = true

                        }else
                        {
                           self.noService.isHidden = true
                            self.mapV.isHidden = false
                           self.arr_list = [SelectPaymentData]()
                           for (index, element) in CourseList.enumerated() {
                               print("Item \(index): \(element)")
                               if index == 0
                               {
                                   var getData = SelectPaymentData.init(with: CourseList[index] as! [String : Any])
                                   getData.opened = true
                                   self.arr_list.append(getData)
                               }else
                               {
                                    self.arr_list.append(SelectPaymentData.init(with: CourseList[index] as! [String : Any]))
                               }
                            }
                            
                            self.getPloat()
                         }
                    }
                    else {

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
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String,arr_Data:SelectPaymentData) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)

                    print(pm.subLocality)

                    print(pm.thoroughfare)

                    print(pm.postalCode)

                    print(pm.subThoroughfare)

                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "

                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "

                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "

                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "

                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "

                    }
                    if pm.subThoroughfare != nil {
                           addressString = addressString + pm.subThoroughfare! + " "
                    }
                    print(addressString)
                    ZKProgressHUD.dismiss()

                    self.createMarker(titleMarker: "Your Location",snippet:addressString , iconMarker: #imageLiteral(resourceName: "Pin") , latitude: lat, longitude: lon, arr_Data: arr_Data)
                    
              }
        })

    }
    // MARK: function for create a marker pin on map
       func createMarker(titleMarker: String,snippet:String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees,arr_Data:SelectPaymentData) {
        let house = UIImage(named: "plot me")!.withRenderingMode(.alwaysOriginal)
        let markerView = UIImageView(image: house)
           markerView.frame.size = CGSize.init(width: 40, height: 40)
           let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
              let marker = GMSMarker(position: position)
//              marker.snippet = snippet
              marker.iconView = markerView
              marker.tracksViewChanges = true
              marker.userData = ["userData":arr_Data]
              marker.map = mapV
       }
    @objc func appMovedToForeground() {
          if Reachability.isConnectedToNetwork() != true {
              showOfflinePage(Controller: self)
          }else
          {
            // getPloat()
            HitListOfSingle(APIName:"getRoadServices")

          }
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        PopUpShow(status: false,userData: (marker.userData as! NSDictionary)["userData"] as! SelectPaymentData)
        return false
    }
        @objc func getPloat()
        {
            self.mapV.clear()
            let getPr = LocationManager.sharedLocationManager.location?.coordinate
             Currentlat1 = getPr?.latitude
             Currentlong1 = getPr?.longitude
             let str_lat = "\(Currentlat1!)"
             let str_long = "\(Currentlong1!)"
            let camera = GMSCameraPosition.camera(withLatitude: Currentlat1!, longitude: Currentlong1!, zoom: Zoom)
            
            self.mapV.camera = camera
//                self.mapV?.isMyLocationEnabled = true
            self.mapV.settings.myLocationButton = true
            self.mapV.delegate = self
            self.mapV.settings.zoomGestures = true
            for arr_Data in arr_list
            {
                getAddressFromLatLon(pdblLatitude: arr_Data.lat!, withLongitude: arr_Data.long!,arr_Data:arr_Data)
            }
        }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        PopUpShow(status: false,userData: (marker.userData as! NSDictionary)["userData"] as! SelectPaymentData)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func payBtn(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentChoose1") as! PaymentChoose
        
       VC.getTransectionFee = 5
       VC.PaymentType = pageType
        if pageType == "Both Services"
        {
            VC.MedicalDic = MedicalDic
            VC.RoadSideDic = selectedDic
            VC.getServiceCharges = Int(MedicalDic.charges!)!
            VC.getroadSideserviceCharges = Int(selectedDic.charges!)!
        }else
        {
            VC.RoadSideDic = selectedDic
            VC.getServiceCharges = Int(selectedDic.charges!)!
        }
       VC.getTransection_user_id = "\(selectedDic.user_id!)"
       self.navigationController?.pushViewController(VC, animated: true)
    }
   
    @IBAction func cancelPopup(_ sender: Any) {
        PopUpShow(status: true, userData: SelectPaymentData(with: [:]))
    }
    func PopUpShow(status:Bool,userData:SelectPaymentData)
    {
        if status == false
        {
            selectedDic = userData
            titlePayment.setTitle("Pay: \(userData.charges!)", for: .normal)
            nameService.text = "Medical Names is: \(userData.name!)"
            MobileName.text = "Contact number is: \(userData.conCode!)\(userData.contact!)"
           
            let getLocationUTL = "https://maps.google.com/maps?q=\(userData.lat!),\(userData.long!)"
    //        cell.location.text = "My location is: \("asgdhsgdhjdsghgdsgfhjdgshjfgdhjsfghdsgfhjghdahsdghsagdhsagdhjdsgfhgdshfg")"
//            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
            let formattedText = String.format(strings: [getLocationUTL],
                                              boldFont: Location.font,
                                                boldColor: UIColor.blue,
                                                inString: "My location is: \(getLocationUTL)",
                                                font: Location.font,
                                                color: UIColor.black)
            Location.attributedText = formattedText
//            Location.tag = indexPath.row
//            Location.addGestureRecognizer(tap)
//            Location.tag = indexPath.row
//            cell.btnAction.addTarget(self, action:#selector(crossBtn), for: .touchUpInside)
        }
        popUpBack.isHidden = status
        popUpView.isHidden = status
        popUpGShadowView.isHidden = status
    }
    @IBAction func btnLocationAction(_ sender: Any) {
        guard let url = URL(string: "https://maps.google.com/maps?q=\(selectedDic.lat!),\(selectedDic.long!)") else {
                         return
                     }
                     if #available(iOS 10, *) {
                         UIApplication.shared.open(url, options: [:], completionHandler: nil)
                         
                     } else {
                         UIApplication.shared.openURL(url)
                     }
    }
    func PopUpManager(checkType status: String, AlertType: String)  {
                print(status)
        if status != "cancel"
        {
         
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


import UIKit

protocol MapMarkerDelegate: class {
    func didTapInfoButton(data: NSDictionary)
}

class MapMarkerWindow: UIView {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var availibilityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    weak var delegate: MapMarkerDelegate?
    var spotData: NSDictionary?
    
    @IBAction func didTapInfoButton(_ sender: UIButton) {
        delegate?.didTapInfoButton(data: spotData!)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapMarkerWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
}
