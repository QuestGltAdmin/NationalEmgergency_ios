//
//  PincodeVC.swift
//  Lalaji
//
//  Created by Alok Agrawal on 28/11/17.
//  Copyright © 2017 Quest GLT. All rights reserved.
//

import UIKit
protocol PincodeVCDelegate : class {
    func didFinishPincodeView(_ recorderViewController: PincodeVC,str: String)
}
class PincodeVC: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {
    open weak var delegate: PincodeVCDelegate?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var TableV: UITableView!
    @objc var getArray : NSArray = []
    @objc var filteredArray: NSArray = []
    @objc var pincodeDict: NSDictionary = NSDictionary()
    @objc var selectedAr: NSMutableArray = NSMutableArray()
    @objc var selectedArNames: NSMutableArray = NSMutableArray()
    @objc var viewTypeIS : NSString = ""
    @objc open fileprivate(set) var str: String = ""
    @IBOutlet weak var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.showsCancelButton = false
        searchBar.delegate = self
        if viewTypeIS == "bank"
        {
           titleLbl.text  = "Bank"
        }
        
        for subView in searchBar.subviews {
            
            for subsubView in subView.subviews {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left
                if let searchBarTextField = subsubView as? UITextField {
                    if viewTypeIS == "bank"
                    {
                        searchBarTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Search Bank Name here...", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular", size: 15)!,NSAttributedString.Key.paragraphStyle: paragraphStyle])
                        
                    }else
                    {
                       // searchBarTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Search Country here...", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular", size: 15)!,NSAttributedString.Key.paragraphStyle: paragraphStyle])
                    }
                    searchBarTextField.leftView = nil;
                    searchBarTextField.textAlignment = NSTextAlignment.left;
                    searchBarTextField.textColor = UIColor.black
                    if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
                        let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
                        
                        //Magnifying glass
                        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                        glassIconView.tintColor = .black
                    }
                    if let textFieldInsideSearchBar1 = self.searchBar.value(forKey: "searchField") as? UITextField,
                        let glassIconView = textFieldInsideSearchBar1.rightView as? UIImageView {
                        
                        //Magnifying glass
                        glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                        glassIconView.tintColor = .black
                    }
                    
                }
                
            }
            
        }
        TableV.estimatedRowHeight = 44.0
        TableV.rowHeight = UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchBar.text == ""
        {
            return getArray.count
        }else
        {
            return filteredArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "JoinCell") as!  JoinCell
            cell.tintColor = UIColor(red:0.11, green:0.80, blue:0.42, alpha:1.0)
            var dic: NSDictionary = NSDictionary()
        
            if self.searchBar.text == ""
            {
                dic = self.getArray[indexPath.row] as! NSDictionary
            }else
            {
                dic = filteredArray[indexPath.row] as! NSDictionary
            }
        cell.name.text = "\(dic["country_name_en"]!) (\(dic["country_code"]!))"
            return cell
        
    }
    @IBAction func back_btn(_ sender: Any) {
        delegate?.didFinishPincodeView(self, str: "Cancel")
        dismiss(animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        var dic: NSDictionary = NSDictionary()
        
        if self.searchBar.text == ""
        {
            dic = self.getArray[indexPath.row] as! NSDictionary
        }else
        {
            dic = filteredArray[indexPath.row] as! NSDictionary
        }
        pincodeDict = dic
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
        delegate?.didFinishPincodeView(self, str: "Ok")
        dismiss(animated: true, completion: nil)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        TableV.reloadData()
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        //self.searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if viewTypeIS == "bank"
        {
            let firstNamePredicate = NSPredicate(format: "bank_name CONTAINS[cd] %@", searchBar.text!)
            filteredArray = getArray.filtered(using: firstNamePredicate) as NSArray
        }else
        {
            let firstNamePredicate = NSPredicate(format: "country_name_en CONTAINS[cd] %@ || country_code CONTAINS[cd] %@", searchBar.text!,searchBar.text!)
            filteredArray = getArray.filtered(using: firstNamePredicate) as NSArray
        }
        
            self.TableV.reloadData()
    }
    @objc open func startRecording() {
        self.searchBar.text = ""
        TableV.reloadData()
    }
    @objc open func createRecorder() {
        
    }
   

}

//MArK:JoinCell
import UIKit

class JoinCell: UITableViewCell {
    
   @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var creator: UILabel!
    
    @IBOutlet weak var viewV: UIView!
    @IBOutlet weak var countryname: UILabel!
    @IBOutlet weak var invitedVia: UILabel!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var join: UIButton!
   
    
}
