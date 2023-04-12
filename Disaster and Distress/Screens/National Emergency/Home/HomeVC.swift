//
//  HomeVC.swift
//  Zega Cookware
//
//  Created by Mohit on 09/10/19.
//  Copyright © 2019 Questglt. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import ZKProgressHUD
import MessageUI

var LocationServiceCheck:CLAuthorizationStatus?

class HomeVC: UIViewController,CompleteTimerDelegate,LocationManagerDelegate {
     func locationManager(didChangeAuthorization status: CLAuthorizationStatus) {
           LocationServiceCheck = status
           print(LocationServiceCheck)
     }
     func CompleteTimerManager(checkType status: String, AlertType: String) {
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
     }
   
    var Currentlat1:CLLocationDegrees?
    var Currentlong1:CLLocationDegrees?
    var Zoom: Float = 16
    @IBOutlet weak var mapV: GMSMapView!
    var userDict = NSDictionary()

    @IBOutlet weak var userAddress: DisolveTransitionLbl!
    @IBOutlet weak var user_DateOfPlot: DisolveTransitionLbl!
    @IBOutlet weak var userName: DisolveTransitionLbl!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var PlotView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let AppDele = UIApplication.shared.delegate! as! AppDelegate
                     if AppDele.DeviceToken == nil
                     {
                         AppDele.DeviceToken = "";
                     }
              
        if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) != nil)
        {
           userDict = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) as! NSDictionary

        }
        NotificationCenter.default.addObserver(self, selector: #selector(getPloat), name: NSNotification.Name("plotGet"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getHelp), name: NSNotification.Name("helpGet"), object: nil)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name:UIApplication.willEnterForegroundNotification, object: nil)

        print(LocationManager.sharedLocationManager.location)
        
          
        // Do any additional setup after loading the view.
    }
    @objc func appMovedToForeground() {
        if Reachability.isConnectedToNetwork() != true {
            showOfflinePage(Controller: self)
        }else
        {
            getPloat()
        }
    }
    @objc func getHelp()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            var PopUpVCView: CompleteTimerVC!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            PopUpVCView = (storyboard.instantiateViewController(withIdentifier: "CompleteTimerVC") as! CompleteTimerVC)
            PopUpVCView.delegate = self
            PopUpVCView.modalTransitionStyle = .crossDissolve
            PopUpVCView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(PopUpVCView, animated: true, completion: nil)
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) != nil)
        {
           userDict = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) as! NSDictionary

        }
        self.mapV.clear()
        appMovedToForeground()
       
    }
    func getPathHere()
    {
            ZKProgressHUD.showGif(gifUrl: Bundle.main.url(forResource: SetGIFName, withExtension: SetGIFType), gifSize: SetGIFSize)
            ZKProgressHUD.setBackgroundColor(.clear)
           
            let str_lat = "\(Currentlat1!)"
            let str_long = "\(Currentlong1!)"
            getAddressFromLatLon(pdblLatitude: str_lat, withLongitude: str_long)

          
            let camera = GMSCameraPosition.camera(withLatitude: Currentlat1!, longitude: Currentlong1!, zoom: Zoom)
            
            self.mapV.camera = camera
//                self.mapV?.isMyLocationEnabled = true
            self.mapV.settings.myLocationButton = true
            
            self.mapV.settings.zoomGestures = true
    }
 
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
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

                        self.createMarker(titleMarker: "Your Location",snippet:addressString , iconMarker: #imageLiteral(resourceName: "Pin") , latitude: lat, longitude: lon)
                        
                  }
            })

        }
    @objc func plotGet(notification: NSNotification)
     {
           let cellData = notification.object
           if let dataDict = cellData as? [String : Any] {
               if ((dataDict) != nil)
               {
                self.getPloat()
               }
            }
    }
    @objc func getPloat()
    {
        self.mapV.clear()
        if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) != nil)
        {
           userDict = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasUserData) as! NSDictionary

        }
        if (DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasplotMe) != nil) {
            PlotView.isHidden = false
            var plotMe = NSDictionary()
            plotMe = DataPersistence.sharedDataPersistenceInterface.getValueForKey(kHasplotMe) as! NSDictionary
            userAddress.text = plotMe["streetAdd"] as? String
            user_DateOfPlot.text = plotMe["created_at"] as? String
            if self.checkExist(parameter:"image",userDict:userDict)
            {
              let getPath = "\(APIURLProfile)/"
              let url = "\(getPath)\(GetImageCorrect(ImageURL: checkStringNull(checkData:userDict["image"]!)))"
              let downloadURL: NSURL = NSURL(string: url)!
              self.userImg.af_setImage(withURL: downloadURL as URL)
            }else
            {
                self.userImg.image = #imageLiteral(resourceName: "userProfileImage")
            }
            var Name : String = ""

            if self.checkExist(parameter:"firstName", userDict: userDict)
           {
               Name = Name + "\(userDict["firstName"]!)"
           }
            if self.checkExist(parameter:"lastName", userDict: userDict)
           {
               Name = Name + " \(userDict["lastName"]!)"
           }
            self.userName.text = Name
           
            Currentlat1 =  Double("\(plotMe["lat"]!)")!
            Currentlong1 =  Double("\(plotMe["long"]!)")!
             getPathHere()
        }else
        {
            
            let getPr = LocationManager.sharedLocationManager.location?.coordinate
             Currentlat1 = getPr?.latitude
             Currentlong1 = getPr?.longitude
            PlotView.isHidden = true
             let str_lat = "\(Currentlat1!)"
             let str_long = "\(Currentlong1!)"
            getAddressFromLatLon(pdblLatitude: str_lat, withLongitude: str_long)
            let camera = GMSCameraPosition.camera(withLatitude: Currentlat1!, longitude: Currentlong1!, zoom: Zoom)
            
            self.mapV.camera = camera
//                self.mapV?.isMyLocationEnabled = true
            self.mapV.settings.myLocationButton = true
            
            self.mapV.settings.zoomGestures = true

        }
    }
    func checkExist(parameter:String,userDict:NSDictionary) -> Bool
      {
          if let firstName = userDict[parameter]
          {
              if (firstName as! String).count != 0
              {
                  return true
              }
          }
          return false
      }
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String,snippet:String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
     let house = UIImage(named: "plot me")!.withRenderingMode(.alwaysOriginal)
     let markerView = UIImageView(image: house)
        markerView.frame.size = CGSize.init(width: 40, height: 40)
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
           let marker = GMSMarker(position: position)
           marker.snippet = snippet
           marker.iconView = markerView
           marker.tracksViewChanges = true
           marker.map = mapV
    }
    @IBAction func addBtnAction(_ sender: Any) {
        let VC1 = self.storyboard?.instantiateViewController(withIdentifier: "addOptionsVC") as! addOptionsVC
        let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
        navController.modalPresentationStyle = .overFullScreen

        navController.setNavigationBarHidden(true, animated: false)
        self.present(navController, animated:false, completion: nil)
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "addOptionsVC") as! addOptionsVC
//
//        self.present(VC, animated: true, completion: nil)
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
