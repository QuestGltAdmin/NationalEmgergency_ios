//
//  WebService.swift
//  WashAdmin
//
//  Created by Alok Agrawal on  4/01/17.
//  Copyright © 2017 Quest GLT. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
let str = "http://pacificbazar.com/website/demo/api/"

typealias FooCompletionHandler = (_ obj:AnyObject?, _ success:Bool?,_ OtherStatus:String?) -> Void

class WebService: NSObject {
    let ConstantsObject = Constants()
    @objc static let sharedWebService = WebService()
    
    func Get_AUTH(controller: String, completionHandler:@escaping FooCompletionHandler) {
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
            let MyURL = APIURL + controller
            Alamofire.request(MyURL, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success:
                    print(response)
                    if response != nil
                    {
                        if let result = response.result.value {
                            
                            let JSON = result as! NSDictionary
                            completionHandler(JSON, true,nil)
                        }
                        
                    }else
                    {
                        let _ : NSDictionary = (response as? NSDictionary)!
                        completionHandler(nil, true,nil)
                    }
                    break
                case .failure(let error):
                    completionHandler(nil, false,error.localizedDescription)
                    print(error)
                }
            }
        }
    }
  
    func Get_AUTHForGoogleMap(controller: String, completionHandler:@escaping FooCompletionHandler) {
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
            let MyURL = APIURL + controller
            Alamofire.request(MyURL, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success:
                    print(response)
                    if response != nil
                    {
                        if let result = response.result.value {
                            
                            let JSON = result as! NSDictionary
                            completionHandler(JSON, true,nil)
                        }
                        
                    }else
                    {
                        let _ : NSDictionary = (response as? NSDictionary)!
                        completionHandler(nil, true,nil)
                    }
                    break
                case .failure(let error):
                    completionHandler(nil, false,error.localizedDescription)
                    print(error)
                }
            }
        }
    }
    func Get_AUTH_WithParameter(controller: String,values: [String: Any], completionHandler:@escaping FooCompletionHandler) {
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
            let MyURL = APIURL + controller
            print(MyURL)
            Alamofire.request(MyURL, method: .get, parameters: values,encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success:
                    print(response)
                    if response != nil
                    {
                        if let result = response.result.value {
                            
                            let JSON = result as! NSDictionary
                            completionHandler(JSON, true,nil)
                        }
                        
                    }else
                    {
                        let _ : NSDictionary = (response as? NSDictionary)!
                        completionHandler(nil, true,nil)
                    }
                    break
                case .failure(let error):
                    completionHandler(nil, false,error.localizedDescription)
                    print(error)
                }
            }
        }
    }
    open func translateTest(request_str: String,  callback:@escaping (_ translatedText:String) -> ()) {
        
        //        guard apiKey != "" else {
        //            return
        //        }
        
        var request = URLRequest(url: URL(string: request_str)!)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        //        let jsonRequest = [
        //            "q": params.text,
        //            "source": "en",
        //            "target": targetLanguage,
        //            ] as [String : Any]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: [:], options: .prettyPrinted) {
            request.httpBody = jsonData
            let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    print("Something went wrong: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    guard httpResponse.statusCode == 200 else {
                        if let data = data {
                            print("Response [\(httpResponse.statusCode)] - \(data)")
                        }
                        return
                    }
                    
                    do {
                        if let data = data {
                            if let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                                if let jsonData = json["data"] as? [String : Any] {
                                    if let translations = jsonData["translations"] as? [NSDictionary] {
                                        if let translation = translations.first as? [String : Any] {
                                            if let translatedText = translation["translatedText"] as? String {
                                                callback(translatedText)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Serialization failed: \(error.localizedDescription)")
                    }
                }
            }
            
            task.resume()
        }
    }
    func Get_LanguageData(controller: String, completionHandler:@escaping FooCompletionHandler) {
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
            let MyURL = controller
            Alamofire.request(MyURL, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success:
                    print(response)
                    if response != nil
                    {
                        if let result = response.result.value {
                            
                            let JSON = result as! NSDictionary
                            completionHandler(JSON, true,nil)
                        }
                        
                    }else
                    {
                        let _ : NSDictionary = (response as? NSDictionary)!
                        completionHandler(nil, true,nil)
                    }
                    break
                case .failure(let error):
                    completionHandler(nil, false,error.localizedDescription)
                    print(error)
                }
            }
        }
    }
    func Get_URL(controller: String, completionHandler:@escaping FooCompletionHandler) {
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
            let MyURL = controller
            Alamofire.request(MyURL, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success:
                    print(response)
                    if response != nil
                    {
                        if let result = response.result.value {
                            
                            let JSON = result as! NSDictionary
                            completionHandler(JSON, true,nil)
                        }
                        
                    }else
                    {
                        let _ : NSDictionary = (response as? NSDictionary)!
                        completionHandler(nil, true,nil)
                    }
                    break
                case .failure(let error):
                    completionHandler(nil, false,error.localizedDescription)
                    print(error)
                }
            }
        }
    }
    func Post_AUTH111(controller: String,values: [String: Any], completionHandler:@escaping FooCompletionHandler) {
//        Constants().alertMessage(title: "", message: "\(values)")
        
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
            
            let MyURL = APIURL + controller
            Alamofire.request(MyURL, method: .post, parameters: values,encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                
                switch response.result {
                case .success:
                    print(response)
                    

                    if let result = response.result.value {

                        let JSON = result as! NSDictionary
                        

                        completionHandler(JSON, true,nil)
                    }
                    //                    if response.count != 0
                    //                    {
                    //
                    //
                    //                    }else
                    //                    {
                    //
                    //                        let _ : NSDictionary = (response as? NSDictionary)!
                    //                        completionHandler(nil, true,nil)
                    //                    }
                    break
                case .failure(let error):
                   

//                    completionHandler(nil, false,error.localizedDescription)
                    print(error)
                }
            }
        }
    }
    func Post_AUTH(controller: String,values: [String: Any], completionHandler:@escaping FooCompletionHandler) {
       
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
            let headers = [
                "Content-Type": "application/json"
            ]
            let MyURL = APIURL + controller
            print("MyURL:\(MyURL)")
            print("values:\(values)")

            Alamofire.request(MyURL, method: .post, parameters: values,encoding: JSONEncoding.default, headers: headers).responseJSON {
                response in
                
                switch response.result {
                case .success:
                    print(response)
                    
                    if let result = response.result.value {
                        
                        let JSON = result as! NSDictionary
                        completionHandler(JSON, true,nil)
                    }
//                    if response.count != 0
//                    {
//
//
//                    }else
//                    {
//
//                        let _ : NSDictionary = (response as? NSDictionary)!
//                        completionHandler(nil, true,nil)
//                    }
                    break
                case .failure(let error):
                    completionHandler(nil, false,error.localizedDescription)
                    print(error)
                }
            }
        }
    }
    func Post_Language(controller: String, completionHandler:@escaping FooCompletionHandler) {
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
            
            let MyURL = APILanguage + "?" + controller
            Alamofire.request(MyURL, method: .post,encoding: JSONEncoding.default, headers: nil).responseJSON {
                response in
                switch response.result {
                case .success:
                    print(response)
                    
                    if let result = response.result.value {
                        
                        let JSON = result as! NSDictionary
                        completionHandler(JSON, true,nil)
                    }
                    //                    if response.count != 0
                    //                    {
                    //
                    //
                    //                    }else
                    //                    {
                    //
                    //                        let _ : NSDictionary = (response as? NSDictionary)!
                    //                        completionHandler(nil, true,nil)
                    //                    }
                    break
                case .failure(let error):
                    completionHandler(nil, false,error.localizedDescription)
                    print(error)
                }
            }
        }
    }
    func Post_AUTH_Profile(controller: String,values: [String: Any],strImageKey: String, completionHandler:@escaping FooCompletionHandler) {
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
            let imD =  ((values as NSDictionary).value(forKey: strImageKey) as! UIImage).jpegData(compressionQuality: 0.5)
            let timeStamp = NSString.init(format: "%f.jpg",NSDate().timeIntervalSince1970 * 1000)
            let MyURL = APIURL + controller
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                multipartFormData.append(imD!, withName: strImageKey, fileName: timeStamp as String, mimeType: "\(strImageKey)/jpeg") //multipartFormData.append(UIImageJPEGRepresentation(getImage, 0.5)!, withName: "photo_path", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                //                for (key, value) in values {
                //                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                //                }
            }, to:MyURL)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        switch response.result {
                        case .success:
                            print(response)
                            if response != nil
                            {
                                if let result = response.result.value {
                                    
                                    let JSON = result as! NSDictionary
                                    completionHandler(JSON, true,nil)
                                }
                                
                            }else
                            {
                                let _ : NSDictionary = (response as? NSDictionary)!
                                completionHandler(nil, true,nil)
                            }
                            break
                        case .failure(let error):
                            completionHandler(nil, false,error.localizedDescription)
                            print(error)
                        }
                    }
                    
                case .failure(let encodingError):
                    completionHandler(nil, false,encodingError.localizedDescription)
                }
                
            }
        }
    }
    func Post_accident(controller: String,imageData:Data?,VideoData:Data?,values: [String: Any],strImageKey: String,strVideoKey: String, completionHandler:@escaping FooCompletionHandler) {
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
            //            let imD =  ((values as NSDictionary).value(forKey: strImageKey) as! UIImage).jpegData(compressionQuality: 0.5)
            //            let Video =  ((values as NSDictionary).value(forKey: strVideoKey) as! UIImage).jpegData(compressionQuality: 0.5)
            let timeStamp = NSString.init(format: "%f",NSDate().timeIntervalSince1970 * 1000)
            let timeStamp1 = NSString.init(format: "%f",NSDate().timeIntervalSince1970 * 1000)
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ] //application/x-www-form-urlencoded multipart/form-data
            let MyURL = APIURL + controller
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                for (key, value) in values {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                if let data = imageData{
                    multipartFormData.append(data, withName: strImageKey, fileName: "\(timeStamp).png", mimeType: "\(timeStamp)/png")
                }
                if let data = VideoData{
                    multipartFormData.append(data, withName: strVideoKey, fileName: "\(timeStamp1).mp4", mimeType: "\(timeStamp1)/mp4")
                }
            }, usingThreshold: UInt64.init(), to:MyURL,headers:headers)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        switch response.result {
                        case .success:
                            print(response)
                            if response != nil
                            {
                                if let result = response.result.value {
                                    
                                    let JSON = result as! NSDictionary
                                    completionHandler(JSON, true,nil)
                                }
                                
                            }else
                            {
                                let _ : NSDictionary = (response as? NSDictionary)!
                                completionHandler(nil, true,nil)
                            }
                            break
                        case .failure(let error):
                            completionHandler(nil, false,error.localizedDescription)
                            print(error)
                        }
                    }
                    
                case .failure(let encodingError):
                    completionHandler(nil, false,encodingError.localizedDescription)
                }
                
            }
        }
    }
    
    func Post_Feedback(controller: String,audioData:Data?,VideoData:Data?,values: [String: Any],strAudioKey: String,strVideoKey: String, completionHandler:@escaping FooCompletionHandler) {
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
            let timeStamp = NSString.init(format: "%f",NSDate().timeIntervalSince1970 * 1000)
            let timeStamp1 = NSString.init(format: "%f",NSDate().timeIntervalSince1970 * 1000)
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            let MyURL = APIURL + controller
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in values {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                if let data = audioData{
                    multipartFormData.append(data, withName: strAudioKey, fileName: "\(timeStamp).m4a", mimeType: "\(timeStamp)/m4a")
                }
                if let data = VideoData{
                    multipartFormData.append(data, withName: strVideoKey, fileName: "\(timeStamp1).mp4", mimeType: "\(timeStamp1)/mp4")
                }
            }, usingThreshold: UInt64.init(), to:MyURL,headers:headers)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        switch response.result {
                        case .success:
                            print(response)
                            if response != nil
                            {
                                if let result = response.result.value {
                                    
                                    let JSON = result as! NSDictionary
                                    completionHandler(JSON, true,nil)
                                }
                                
                            }else
                            {
                                let _ : NSDictionary = (response as? NSDictionary)!
                                completionHandler(nil, true,nil)
                            }
                            break
                        case .failure(let error):
                            completionHandler(nil, false,error.localizedDescription)
                            print(error)
                        }
                    }
                    
                case .failure(let encodingError):
                    completionHandler(nil, false,encodingError.localizedDescription)
                }
                
            }
        }
    }
    
    func Post_accidentBigBrother(controller: String,imageData:Data?,VideoData:Data?,audiodata:Data?,values: [String: Any],strImageKey: String,strVideoKey: String, strAudioKey: String, completionHandler:@escaping FooCompletionHandler) {
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
            //            let imD =  ((values as NSDictionary).value(forKey: strImageKey) as! UIImage).jpegData(compressionQuality: 0.5)
            //            let Video =  ((values as NSDictionary).value(forKey: strVideoKey) as! UIImage).jpegData(compressionQuality: 0.5)
            let timeStamp = NSString.init(format: "%f",NSDate().timeIntervalSince1970 * 1000)
            let timeStamp1 = NSString.init(format: "%f",NSDate().timeIntervalSince1970 * 1000)
            let timeStamp2 = NSString.init(format: "%f",NSDate().timeIntervalSince1970 * 1000)

            let headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ] //application/x-www-form-urlencoded multipart/form-data
            let MyURL = APIURL + controller
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                for (key, value) in values {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                if let data = imageData{
                    multipartFormData.append(data, withName: strImageKey, fileName: "\(timeStamp).png", mimeType: "\(timeStamp)/png")
                }
                if let data = VideoData{
                    multipartFormData.append(data, withName: strVideoKey, fileName: "\(timeStamp1).mp4", mimeType: "\(timeStamp1)/mp4")
                }
                if let data = audiodata{
                    multipartFormData.append(data, withName: strAudioKey, fileName: "\(timeStamp2).m4a", mimeType: "\(timeStamp2)/m4a")
                }
            }, usingThreshold: UInt64.init(), to:MyURL,headers:headers)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        switch response.result {
                        case .success:
                            print(response)
                            if response != nil
                            {
                                if let result = response.result.value {
                                    
                                    let JSON = result as! NSDictionary
                                    completionHandler(JSON, true,nil)
                                }
                                
                            }else
                            {
                                let _ : NSDictionary = (response as? NSDictionary)!
                                completionHandler(nil, true,nil)
                            }
                            break
                        case .failure(let error):
                            completionHandler(nil, false,error.localizedDescription)
                            print(error)
                        }
                    }
                    
                case .failure(let encodingError):
                    completionHandler(nil, false,encodingError.localizedDescription)
                }
                
            }
        }
    }


    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let url = "http://google.com" /* your API url */
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    func Post_multiplePicture(controller: String,imageData:NSMutableArray,values: [String: Any],strImageKey: String, completionHandler:@escaping FooCompletionHandler) {
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
            //            let imD =  ((values as NSDictionary).value(forKey: strImageKey) as! UIImage).jpegData(compressionQuality: 0.5)
           
            let headers = [
                "Content-Type": "multipart/form-data"
            ] //application/x-www-form-urlencoded multipart/form-data
            let MyURL = APIURL + controller
            Alamofire.upload(multipartFormData: { (multipartFormData) in
//                for imageData in imagesData {
//                    multipartFormData.append(imageData, withName: "\(imageParamName)[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
//                }
                for (key, value) in values {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
               
                for data in imageData{
                    let timeStamp = NSString.init(format: "%f",NSDate().timeIntervalSince1970 * 1000)
                    multipartFormData.append(data as! Data, withName: strImageKey, fileName: "\(timeStamp).png", mimeType: "\(timeStamp)/png")
                }
            }, usingThreshold: UInt64.init(), to:MyURL,headers:headers)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        switch response.result {
                        case .success:
                            print(response)
                            if response != nil
                            {
                                if let result = response.result.value {
                                    
                                    let JSON = result as! NSDictionary
                                    completionHandler(JSON, true,nil)
                                }
                                
                            }else
                            {
                                let _ : NSDictionary = (response as? NSDictionary)!
                                completionHandler(nil, true,nil)
                            }
                            break
                        case .failure(let error):
                            completionHandler(nil, false,error.localizedDescription)
                            print(error)
                        }
                    }
                    
                case .failure(let encodingError):
                    completionHandler(nil, false,encodingError.localizedDescription)
                }
                
            }
        }
    }
    
    func Post_AUTH_Profile1(controller: String,imageData:Data?,values: [String: Any],strImageKey: String, completionHandler:@escaping FooCompletionHandler) {
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
           
           let timeStamp = NSString.init(format: "%f",NSDate().timeIntervalSince1970 * 1000)
            let headers = [
                "Content-Type":"multipart/form-data"
            ] //application/x-www-form-urlencoded multipart/form-data
            let MyURL = APIURL + controller 
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                for (key, value) in values {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                if let data = imageData{
                    multipartFormData.append(data, withName: strImageKey, fileName: "\(timeStamp).png", mimeType: "\(timeStamp)/png")
                }
            }, usingThreshold: UInt64.init(), to:MyURL,headers:headers)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        switch response.result {
                        case .success:
                            print(response)
                            if response != nil
                            {
                                if let result = response.result.value {
                                    
                                    let JSON = result as! NSDictionary
                                    completionHandler(JSON, true,nil)
                                }
                                
                            }else
                            {
                                let _ : NSDictionary = (response as? NSDictionary)!
                                completionHandler(nil, true,nil)
                            }
                            break
                        case .failure(let error):
                            completionHandler(nil, false,error.localizedDescription)
                            print(error)
                        }
                    }
                    
                case .failure(let encodingError):
                    completionHandler(nil, false,encodingError.localizedDescription)
                }
                
            }
        }
    }
    func Post_AUTH_Profile2(controller: String,imageData:Data?,imageData1:Data?,values: [String: Any],strImageKey: String,strImageKey2: String, completionHandler:@escaping FooCompletionHandler) {
        if Reachability.isConnectedToNetwork() != true {
            completionHandler(nil, false, NLockConnection)
        } else {
           
            let timeStamp = NSString.init(format: "%f",NSDate().timeIntervalSince1970 * 1000)
            let timeStamp1 = NSString.init(format: "%f",NSDate().timeIntervalSince1970 * 1000)
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ] //application/x-www-form-urlencoded multipart/form-data
            let MyURL = APIURL + controller
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                for (key, value) in values {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                if let data = imageData{
                    multipartFormData.append(data, withName: strImageKey, fileName: "\(timeStamp).png", mimeType: "\(timeStamp)/png")
                }
                if let data = imageData1{
                    multipartFormData.append(data, withName: strImageKey2, fileName: "\(timeStamp1).png", mimeType: "\(timeStamp1)/png")
                }
            }, usingThreshold: UInt64.init(), to:MyURL,headers:headers)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        switch response.result {
                        case .success:
                            print(response)
                            if response != nil
                            {
                                if let result = response.result.value {
                                    
                                    let JSON = result as! NSDictionary
                                    completionHandler(JSON, true,nil)
                                }
                                
                            }else
                            {
                                let _ : NSDictionary = (response as? NSDictionary)!
                                completionHandler(nil, true,nil)
                            }
                            break
                        case .failure(let error):
                            completionHandler(nil, false,error.localizedDescription)
                            print(error)
                        }
                    }
                    
                case .failure(let encodingError):
                    completionHandler(nil, false,encodingError.localizedDescription)
                }
                
            }
        }
    }
    
    @objc func convertToDictionary1(ar: NSArray) -> String?  {
        
        
        do {
            let data = try JSONSerialization.data(withJSONObject:ar, options:[])
            let dataString = String(data: data, encoding: String.Encoding.utf8)!
            
            return dataString
        } catch {
            print(error.localizedDescription)
            return error.localizedDescription
        }
        
        return nil
    }
    
    @objc func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                
                //return ["status":false,"data":[error.localizedDescription]]
                
            }
        }
        return nil
    }
    
    
}

