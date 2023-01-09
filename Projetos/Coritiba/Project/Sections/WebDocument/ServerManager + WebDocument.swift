//
//  ServerManager + WebDocument.swift
//  
//
//  Created by Roberto Oliveira on 11/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

struct WebDocumentItem {
    var id:Int
    var body:String
}

extension ServerManager {
    
    func getWebDocumentItem(mode:WebDocumentMode, id:Int, trackEvent:Int?, completion: @escaping (_ item:WebDocumentItem?)->Void) {
        var method = "getRegulamento?t=\(id)"
        if mode == .StoreItem {
            method = "getRegulamentoProduto?id=\(id)"
        }
        APIManager.shared.get(sufix: method, header: self.header(trackEvent: trackEvent, trackValue: id), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            
            let body:String = String.stringValue(from: object["documentacao"]) ?? ""
            let item = WebDocumentItem(id: id, body: body)
            
            completion(item)
        }
    }
    
}

