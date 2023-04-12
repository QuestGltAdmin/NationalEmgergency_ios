//
//  SearchLocationVC.swift
//  PeopleForHelp
//
//  Created by Quest GLT on 27/05/19.
//  Copyright © 2019 Quest GLT. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
class SearchLocationVC: UIViewController,GMSMapViewDelegate  {
    //  @IBOutlet weak var pinImageContraint: NSLayoutConstraint!
    @IBOutlet weak var Pinimage: UIImageView!
    var Zoom: Float = 16
    var moveFlag: Bool?
    var CheckGesture: Bool?
    var FinalLocationGesture: Bool?
    var marker = GMSMarker()
    @IBOutlet weak var mapV: GMSMapView!
    var locationManager = CLLocationManager()
    @objc var str_lat :String = ""
    @objc var str_long :String = ""
    var Currentlat1:CLLocationDegrees?
    var Currentlong1:CLLocationDegrees?
    var CurrentAddress1:String?
    var mut_arr = NSMutableArray()
    var arrList = NSArray()
    var getMult = NSMutableDictionary()
   
    @IBOutlet weak var lblCurrLoc: UILabel!
    
    @IBOutlet weak var lblMsg: UILabel!
    
    
    @IBAction func doneAction(_ sender: Any) {
        let replaced = indexKeyedDictionary(fromArray: getMult as! [String : Any])
        NotificationCenter.default.post(name: Notification.Name(rawValue: "plotSearch"), object: replaced)
        self.navigationController?.popViewController(animated: true)
        //DataPersistence.sharedDataPersistenceInterface.saveValueInDefaults(replaced as! NSDictionary, storeKey: kHasplotMe)
    }
    
    @IBOutlet weak var selectedAddressTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let notificationCenter = NotificationCenter.default
             notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name:UIApplication.willEnterForegroundNotification, object: nil)

           
    }
  
    //MARK:HitAPi
   @objc func appMovedToForeground() {
          if Reachability.isConnectedToNetwork() != true {
              showOfflinePage(Controller: self)
          }else
          {
                   moveFlag = true
                   let getPr = LocationManager.sharedLocationManager.location?.coordinate
                   Currentlat1 = getPr?.latitude
                   Currentlong1 = getPr?.longitude
                   CurrentAddress1 = CurrentAddress
                   
                   createMarker(titleMarker: "Your Location",snippet:"CurrentAddress1" , iconMarker: #imageLiteral(resourceName: "Pin") , latitude: Currentlat1!, longitude: Currentlong1!)
                   
                   str_lat = "\(Currentlat1!)"
                   str_long = "\(Currentlong1!)"
                   //            self.mapV.clear()
                   CheckGesture = true
                   FinalLocationGesture = false
                   let camera = GMSCameraPosition.camera(withLatitude: Currentlat1!, longitude: Currentlong1!, zoom: Zoom)
                   
                   self.mapV.camera = camera
                   self.mapV.delegate = self
                   self.mapV?.isMyLocationEnabled = true
                   self.mapV.settings.myLocationButton = true
                   self.mapV.settings.compassButton = true
                   self.mapV.settings.zoomGestures = true
          }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appMovedToForeground()
    }
    // MARK: function for create a marker pin on map
    func createMarker(titleMarker: String,snippet:String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
     
    }
    // MARK: - Fetch Location
    @IBAction func changeLocation(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        UINavigationBar.appearance().barTintColor = KBLUEColor
        UINavigationBar.appearance().tintColor = UIColor.white
        present(autocompleteController, animated: true, completion: nil)
    }
   
    
    @IBAction func changeLocation1(_ sender: Any) {
        
        CurrentAddress = CurrentAddress1
       
        self.navigationController?.popViewController(animated: true)
    }
   
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        moveFlag = true
    }
    
    func displayLocationInfo(placemark: GMSAddress,location:CLLocation) {
        if placemark != nil {
            //stop updating location to save battery life
            
            let addressIs: String = NSString.init(format: "%@, %@, %@, %@", (placemark.locality != nil) ? placemark.locality! : "", (placemark.postalCode != nil) ? placemark.postalCode! : "", (placemark.administrativeArea != nil) ? placemark.administrativeArea! : "", (placemark.country != nil) ? placemark.country! : "") as String
            
            
            CurrentAddress1 =  (placemark.lines! as NSArray).componentsJoined(by: ", ")
            
            
            let LatC = placemark.coordinate.latitude
            let LongC = placemark.coordinate.longitude
            Currentlat1 = LatC
            Currentlong1 = LongC
            selectedAddressTxt.text = CurrentAddress1!
            
            createMarker(titleMarker: "Your Location",snippet:CurrentAddress1! , iconMarker: #imageLiteral(resourceName: "Pin") , latitude: LatC, longitude: LongC)
            
            str_lat = "\(LatC)"
            str_long = "\(LongC)"
            //            self.mapV.clear()
            self.getMult.setValue(Currentlat1, forKey: "latitude")
            self.getMult.setValue(Currentlong1, forKey: "longitude")
            self.getMult.setValue(selectedAddressTxt.text!, forKey: "placename")

            let LatRegionalPark = LatC
            let LongRegionalPark = LongC
            CheckGesture = true
            FinalLocationGesture = false
            let camera = GMSCameraPosition.camera(withLatitude: LatRegionalPark, longitude: LongRegionalPark, zoom: Zoom)
            
            self.mapV.camera = camera
            self.mapV.delegate = self
            self.mapV?.isMyLocationEnabled = true
            self.mapV.settings.myLocationButton = true
            self.mapV.settings.compassButton = true
            self.mapV.settings.zoomGestures = true
            
        }
    }
    
   
    // MARK: - GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapV.isMyLocationEnabled = true
        FinalLocationGesture = true
        
        if (moveFlag!)
        {
            var destinationLocation = CLLocation()
            destinationLocation = CLLocation(latitude: position.target.latitude,  longitude: position.target.longitude)
            
            let destinationCoordinate = destinationLocation.coordinate
            print(destinationCoordinate)
            
            GMSGeocoder().reverseGeocodeCoordinate(CLLocationCoordinate2DMake(destinationLocation.coordinate.latitude, destinationLocation.coordinate.longitude)) { (response, error) in
                if (error != nil) {
                    //self.createMarker(titleMarker: "Your Location",snippet:self.area_txt.text! , iconMarker: #imageLiteral(resourceName: "Pin") , latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
                    self.Currentlat1 = destinationCoordinate.latitude
                    self.Currentlong1 = destinationCoordinate.longitude
                    self.str_lat = "\(destinationCoordinate.latitude)"
                    self.str_long = "\(destinationCoordinate.longitude)"
                    return
                }
                if (response?.results()!.count != 0) {
                    if self.CheckGesture != false
                    {
                        let addressObj = response?.results()![0] as! GMSAddress
                        self.CurrentAddress1 = (addressObj.lines! as NSArray).componentsJoined(by: ", ")
                        self.selectedAddressTxt.text = (addressObj.lines! as NSArray).componentsJoined(by: ", ")//self.area_txt.text!
                        
                        //                self.area_txt.text = (pm.addressDictionary!["FormattedAddressLines"] as! NSArray).componentsJoined(by: ", ")
                        //                self.selectedAddressTxt.text = (pm.addressDictionary!["FormattedAddressLines"] as! NSArray).componentsJoined(by: ", ")
                        
                        
                        //self.createMarker(titleMarker: "Your Location",snippet:self.area_txt.text! , iconMarker: #imageLiteral(resourceName: "Pin") , latitude: addressObj.coordinate.latitude, longitude: addressObj.coordinate.longitude)
                        self.Currentlat1 = addressObj.coordinate.latitude
                        self.Currentlong1 = addressObj.coordinate.longitude
                        self.str_lat = "\(addressObj.coordinate.latitude)"
                        self.str_long = "\(addressObj.coordinate.longitude)"
                        self.getMult.setValue(self.Currentlat1, forKey: "latitude")
                        self.getMult.setValue(self.Currentlong1, forKey: "longitude")
                        self.getMult.setValue(self.selectedAddressTxt.text!, forKey: "placename")

                        //                }
                    } else {
                        print("Problem with the data received from geocoder")
                        
                    }
                }
                self.moveFlag = false
                
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        mapV.isMyLocationEnabled = true
        FinalLocationGesture = false
        if (gesture) {
            mapView.selectedMarker = nil
            CheckGesture = true
        }else
        {
            CheckGesture = false
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        mapV.isMyLocationEnabled = true
        return false
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        mapV.isMyLocationEnabled = true
        mapV.selectedMarker = nil
        return false
    }
    
    
    
}
// MARK: - GMS Auto Complete Delegate, for autocomplete search location
extension SearchLocationVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let getAddres = place.formattedAddress
        selectedAddressTxt.text = getAddres
        CurrentAddress1 = getAddres
        //area_txt.text = getAddres
        let LatRegionalPark: Double = place.coordinate.latitude
        let LongRegionalPark: Double = place.coordinate.longitude
        Currentlat1 = LatRegionalPark
        Currentlong1 = LongRegionalPark
        self.mapV.clear()
        str_lat = ""
        str_long = ""
        
        createMarker(titleMarker: "Your Location",snippet:getAddres! , iconMarker: #imageLiteral(resourceName: "Pin") , latitude: LatRegionalPark, longitude: LongRegionalPark)
        
        str_lat = "\(place.coordinate.latitude)"
        str_long = "\(place.coordinate.longitude)"
        self.getMult.setValue(Currentlat1, forKey: "latitude")
        self.getMult.setValue(Currentlong1, forKey: "longitude")
        self.getMult.setValue(selectedAddressTxt.text!, forKey: "placename")

        let camera = GMSCameraPosition.camera(withLatitude: LatRegionalPark, longitude: LongRegionalPark, zoom: Zoom)
        self.mapV.camera = camera
        self.mapV.delegate = self
        self.mapV?.isMyLocationEnabled = true
        self.mapV.settings.myLocationButton = true
        self.mapV.settings.compassButton = true
        self.mapV.settings.zoomGestures = true
        //DataPersistence.sharedDataPersistenceInterface.saveValueInDefaults(getAddres as AnyObject, storeKey: kHasGetAddress)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
   
    func checkNull(location:Any) -> String
    {
        guard let id = location as? String else {
            
            return ""
        }
            return id
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dict = (mut_arr[indexPath.row] as! NSDictionary)
        print(dict)
        let loctiondic  =  dict["location"] as! NSDictionary
        print(loctiondic)
       
//        Currentlat = Double("\(loctiondic["lat"]!)") //Double(loctiondic["lat"] as! NSS)
//        Currentlong =  Double("\(loctiondic["lng"]!)") //Double(loctiondic["lng"] as! String)
        CurrentAddress = "\(dict["Address"] as! String)"
        

        self.navigationController?.popViewController(animated: true)
        // let Curlat = loctiondic["lat"] as! String as NSString
        //let Curlng = loctiondic["lng"] as! String
        
    }
}

