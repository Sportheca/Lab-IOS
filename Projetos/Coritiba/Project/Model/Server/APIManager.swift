//
//  APIManager.swift
//
//
//  Created by Roberto Oliveira on 14/06/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

enum ServerError:Int {
    case Unknow = 0
    case InvalidUrl = 1
    case NotConnected = 2
    case TimeOut = 3
    case Failed = 4
}

// MARK: - ServerManager
class APIManager {
    
    // MARK: - Shared
    static var shared:APIManager = APIManager()
    
    
    
    // MARK: - Debug
    private func debugIfNeeded(sufix:String, header:String) {
        print("\n\n------------------- APIManager -------------------")
        print("sufix: ", sufix)
        print("API URL: ", self.urlString(sufix: sufix))
        print("header: ", header)
    }
    
    private func urlString(sufix:String) -> String {
        if sufix.contains(otherString: "http") {
            return sufix
        }
        var serverUrlString = ProjectManager.mainUrl + ProjectManager.shared.apiPath
        
        // not versioned methods
        if sufix.contains(otherString: "getVersion") || sufix.contains(otherString: "setEndSession") {
            serverUrlString = ProjectManager.mainUrl + "/api/"
        }
        
        let urlString = serverUrlString + sufix
        
        return urlString
    }
    
    
    
    // MARK: - Connection Methods
    func post(sufix:String, header:String, postInfo:[String:Any], bodyFormat:Bool = false, completion: @escaping (_ dict:[String:Any]?, _ error:ServerError?)->Void) {
        self.debugIfNeeded(sufix: sufix, header: header)
        let urlString = self.urlString(sufix: sufix)
        print("postInfo: ", postInfo)
        if let url = URL(string: urlString) {
            // Create HTTP request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // TimeOut
            request.timeoutInterval = 15.0 // 15 seconds to timeOut
            
            // Convert info to JSON and set as httpBody
            if bodyFormat {
                var body = ""
                for (key,value) in postInfo {
                    body.append("\(key)=\(value)&")
                }
                body.removeLast()
                request.httpBody = body.data(using: String.Encoding.utf8, allowLossyConversion: true)
            } else {
                let jsonData = try? JSONSerialization.data(withJSONObject: postInfo)
                request.httpBody = jsonData
            }
            
            
            // Request Header
            request.setValue(header, forHTTPHeaderField: ProjectManager.serverAPIKey)
            
            // Create and resume Task
            URLSession.shared.dataTask(with: request, completionHandler: { (dataObj:Data?, responseObj:URLResponse?, errorObj:Error?) in
                guard let data = dataObj else {
                    if NetworkManager.isConnectedToNetwork() == false { // Not connected
                        print("API failed connection sufix:\(sufix)")
                        completion(nil, ServerError.NotConnected)
                        return
                    } else if (errorObj as NSError?)?.code == -1001 { // Time Out
                        print("API time out! sufix:\(sufix)")
                        completion(nil, ServerError.TimeOut)
                        return
                    } else {
                        print("\n--------\n\nAPI failed at \"\(sufix)\" with error: \(errorObj.debugDescription)\n\n---------\n")
                        completion(nil, ServerError.Failed)
                        return
                    }
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                let dict = responseJSON as? [String: Any]
                print("\n--------- \(sufix)-------------")
                print("url: ", url)
                print("dataObj: \(String(describing: dataObj))")
                print("responseJSON: \(String(describing: responseJSON))")
                print("error: \(String(describing: errorObj))")
                print("header: \(header)")
                print("----------------------")
                ServerManager.shared.checkServerInvalidations(info: dict)
                completion(dict, nil)
            }).resume()
        } else {
            // Not possible to create url
            print("API invalid url")
            completion(nil, ServerError.InvalidUrl)
        }
    }
    
    
    
    
    func get(sufix:String, header:String, sendInfo:[String:Any]?, completion: @escaping (_ dict:[String:Any]?, _ error:ServerError?)->Void) {
        self.debugIfNeeded(sufix: sufix, header: header)
        let urlString = self.urlString(sufix: sufix)
        if let url = URL(string: urlString) {
            // Create HTTP request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // TimeOut
            request.timeoutInterval = 15.0 // 15 seconds to timeOut
            
            // Convert info to JSON and set as httpBody
            if let info = sendInfo {
                let jsonData = try? JSONSerialization.data(withJSONObject: info)
                request.httpBody = jsonData
            }
            
            // Request Header
            request.setValue(header, forHTTPHeaderField: ProjectManager.serverAPIKey)
            
            // Create and resume Task
            URLSession.shared.dataTask(with: request, completionHandler: { (dataObj:Data?, responseObj:URLResponse?, errorObj:Error?) in
                guard let data = dataObj else {
                    if NetworkManager.isConnectedToNetwork() == false { // Not connected
                        print("API failed connection sufix:\(sufix)")
                        completion(nil, ServerError.NotConnected)
                        return
                    } else if (errorObj as NSError?)?.code == -1001 { // Time Out
                        print("API time out! sufix:\(sufix)")
                        completion(nil, ServerError.TimeOut)
                        return
                    } else {
                        print("\n--------\n\nAPI failed at \"\(sufix)\" with error: \(errorObj.debugDescription)\n\n---------\n")
                        completion(nil, ServerError.Failed)
                        return
                    }
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                let dict = responseJSON as? [String: Any]
                print("\n--------- \(sufix)-------------")
                print("dataObj: \(String(describing: dataObj))")
                print("responseJSON: \(String(describing: responseJSON))")
                print("error: \(String(describing: errorObj))")
                print("header: \(header)")
                print("----------------------")
                ServerManager.shared.checkServerInvalidations(info: dict)
                completion(dict, nil)
            }).resume()
        } else {
            // Not possible to create url
            completion(nil, ServerError.InvalidUrl)
        }
    }
    
    func downloadImage(sufix:String?, completion: @escaping (_ image:UIImage?)->Void) {
        guard let imageSufix = sufix else {
            completion(nil)
            return
        }
        // Add our server images path if it is not an external media
        var imageUrl = imageSufix
        if !imageSufix.contains("http") {
            imageUrl = "\(ProjectManager.mainUrl)\(ProjectManager.imagesPath)\(imageSufix)"
        }
//        print("imageUrl: ", imageUrl)
        
        let encoded = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? imageUrl
        if let url = URL(string: encoded) {
            // Create HTTP request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // TimeOut
            request.timeoutInterval = 15.0 // 15 seconds to timeOut
            
            // Create and resume Task
            URLSession.shared.dataTask(with: request, completionHandler: { (dataObj:Data?, responseObj:URLResponse?, errorObj:Error?) in
                guard let data = dataObj else {
                    completion(nil)
                    return
                }
                let object = UIImage(data: data)
//                print("\n\n---------- IMAGE DOWNLOAD ----------")
//                print("url: ", url)
//                print("data: ", data)
//                print("object: ", object as Any)
//                print("responseObj: ", responseObj as Any)
//                print("errorObj: ", errorObj as Any)
//                print("---------------------------------------")
                completion(object)
            }).resume()
        } else {
            // Not possible to create url
            completion(nil)
        }
    }
    
    func postImageWithInfo(sufix:String, header:String, imageData:Data?, imageExtension:String = "jpg", info:[String:Any]?, bodyFormat:Bool = false, completion: @escaping (_ dict:[String:Any]?, _ error:ServerError?)->Void) {
        self.debugIfNeeded(sufix: sufix, header: header)
        let urlString = self.urlString(sufix: sufix)
        guard let url = URL(string: urlString) else {
            // Not possible to create url
            completion(nil, nil)
            return
        }
        
        let request = NSMutableURLRequest(url: url);
        request.httpMethod = "POST";
        
        // TimeOut
        request.timeoutInterval = 15.0 // 15 seconds to timeOut
        
        
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        if let dict = info {
            for (key, value) in dict {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        if let data = imageData {
            let filePathKey = "file"
            let filename = "img.\(imageExtension)"
            let mimetype = "image/\(imageExtension)"
            //            let filename = "img.gif"
            //            let mimetype = "image/gif"
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(data)
            body.appendString(string: "\r\n")
        }
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        request.httpBody = body as Data
        
        
        
        // Request Header
        request.setValue(header, forHTTPHeaderField: ProjectManager.serverAPIKey)
        
        // Create and resume Task
        URLSession.shared.dataTask(with: request as URLRequest) { (dataObj:Data?, responseObj:URLResponse?, errorObj:Error?) in
            guard let data = dataObj else {
                if NetworkManager.isConnectedToNetwork() == false { // Not connected
                    print("API failed connection")
                    completion(nil, ServerError.NotConnected)
                    return
                } else if (errorObj as NSError?)?.code == -1001 { // Time Out
                    print("API time out!")
                    completion(nil, ServerError.TimeOut)
                    return
                } else {
                    print("\n--------\n\nAPI failed at \"\(String(describing: sufix))\" with error: \(errorObj.debugDescription)\n\n---------\n")
                    completion(nil, ServerError.Failed)
                    return
                }
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            let dict = responseJSON as? [String: Any]
            print("\n--------- \(sufix)-------------")
            print("url: ", url)
            print("dataObj: \(String(describing: dataObj))")
            print("responseJSON: \(String(describing: responseJSON))")
            print("error: \(String(describing: errorObj))")
            print("header: \(header)")
            print("----------------------")
            ServerManager.shared.checkServerInvalidations(info: dict)
            completion(dict, nil)
            }.resume()
    }
    
}

// MARK: - NSMutableData
extension NSMutableData {
    func appendString(string: String) {
        guard let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true) else {return}
        append(data)
    }
}






// This extension allows cancelling the previous request before requesting a new one
let global_defaultSession = URLSession(configuration: .default)
var global_dataTask: URLSessionDataTask?
extension APIManager {
    func getCancellingPreviousRequest(sufix:String, header:String, sendInfo:[String:Any]?, completion: @escaping (_ dict:[String:Any]?, _ error:ServerError?)->Void) {
        self.debugIfNeeded(sufix: sufix, header: header)
        global_dataTask?.cancel()
        let urlString = self.urlString(sufix: sufix)
        if let url = URL(string: urlString) {
            // Create HTTP request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            // TimeOut
            request.timeoutInterval = 15.0 // 15 seconds to timeOut
            // Convert info to JSON and set as httpBody
            if let info = sendInfo {
                let jsonData = try? JSONSerialization.data(withJSONObject: info)
                request.httpBody = jsonData
            }
            // Request Header
            request.setValue(header, forHTTPHeaderField: ProjectManager.serverAPIKey)
            // Create and resume Task
            global_dataTask = global_defaultSession.dataTask(with: request, completionHandler: { (dataObj:Data?, responseObj:URLResponse?, errorObj:Error?) in
                guard let data = dataObj else {return}
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                let dict = responseJSON as? [String: Any]
                ServerManager.shared.checkServerInvalidations(info: dict)
                completion(dict, nil)
            })
            global_dataTask?.resume()
        } else {
            // Not possible to create url
            completion(nil, ServerError.InvalidUrl)
        }
    }
}
