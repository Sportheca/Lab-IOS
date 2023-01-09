//
//  ServerManager + InstagramStories.swift
//  
//
//  Created by Roberto Oliveira on 04/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

enum InstagramStoriesPosition:Int {
    case Home = 1
}

struct InstagramStoriesItem {
    var id:Int
    var coverUrlString:String?
    var ctaUrlString:String?
    var videoUrlString:String?
}

extension ServerManager {
    
    func getInstagramStories(trackEvent:Int?, mode:Int, completion: @escaping (_ items:[InstagramStoriesItem]?)->Void) {
        APIManager.shared.get(sufix: "getInstagramStories?t=\(mode)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil) // Failed
                return
            }
            
            var items:[InstagramStoriesItem] = []
            
            if let objects = object["itens"] as? [[String:Any]] {
                for obj in objects {
                    guard let coverUrlString = String.stringValue(from: obj["display_url"]) else {continue}
                    let id = Int.intValue(from: obj["id"]) ?? 0
                    let ctaUrlString = String.stringValue(from: obj["story_cta_url"])
                    let videoUrlString = String.stringValue(from: obj["video_src"])
                    items.append(InstagramStoriesItem(id: id, coverUrlString: coverUrlString, ctaUrlString: ctaUrlString, videoUrlString: videoUrlString))
                }
            }
            
            completion(items)
        }
    }
    
}
