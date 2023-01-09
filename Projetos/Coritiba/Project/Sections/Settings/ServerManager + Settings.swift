//
//  ServerManager + Settings.swift
//  
//
//  Created by Roberto Oliveira on 11/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

extension ServerManager {
    
    func getMenuDocumentsOptions(trackEvent:Int?, completion: @escaping (_ items:[BasicInfo]?)->Void) {
        APIManager.shared.get(sufix: "getDocs", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            
            var objects:[BasicInfo] = []
            if let items = object["itens"] as? [[String:Any]] {
                for item in items {
                    guard let id = Int.intValue(from: item["id"]), let title = String.stringValue(from: item["tipo"]) else {continue}
                    objects.append(BasicInfo(id: id, title: title))
                }
            }
            
            completion(objects)
        }
    }
    
}

