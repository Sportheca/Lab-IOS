//
//  ServerManager + Twitter.swift
//
//
//  Created by Roberto Oliveira on 21/06/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

extension ServerManager {
    
    func getUserHashtags(mode:Int, completion: @escaping (_ object:String?)->Void) {
        APIManager.shared.get(sufix: "getTwitter?t=\(mode)", header: self.header(), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil) // Failed
                return
            }
            
            TwitterApiManager.shared.twitterKey = String.stringValue(from: object["key"]) ?? ""
            TwitterApiManager.shared.twitterSecret = String.stringValue(from: object["secret"]) ?? ""
            
            let hashtags = String.stringValue(from: object["Hashtags"])
            completion(hashtags) // Success
        }
    }
    
    
    func getTweets(search:String, limited:Bool, completion: @escaping (_ objects:[TweetItem]?)->Void) {
//        TwitterApiManager.shared.loadTweetsFrom(search: search, limited: limited, completion: completion)
        ServerManager.shared.getTwitterPosts(home: limited) { (items:[TweetItem]?) in
            completion(items)
        }
    }
    
    
    func getTwitterPosts(home:Bool, completion: @escaping (_ objects:[TweetItem]?)->Void) {
        var sufix:String = ""
        if home {
            sufix = "home=1"
        }
        APIManager.shared.get(sufix: "getTwitterPosts?\(sufix)", header: self.header(), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let obj = dict["Object"] as? [String:Any] else {
                completion(nil) // Failed
                return
            }
            
            guard let objects = obj["items"] as? [[String:Any]] else {
                completion(nil) // Failed
                return
            }
            
            var items:[TweetItem] = []
            var ids:[String] = []
            
            for object in objects {
                guard let idString = String.stringValue(from: object["id"]) else {continue}
                let authorName = String.stringValue(from: object["authorName"]) ?? ""
                let authorAccount = String.stringValue(from: object["authorAccount"]) ?? ""
                let authorImageUrl = String.stringValue(from: object["authorImageUrl"]) ?? ""
                let text = String.stringValue(from: object["text"]) ?? ""
                
                // date
                let dateString = String.stringValue(from: object["date"]) ?? ""
                let date = Date.dateFrom(string: dateString, format: "yyyy-MM-dd HH:mm:ss") ?? Date.now()
                
                var mediaUrlString:String?
                var thumbUrl:String?
                var mediaType:TweetItemMediaType?
                if let medias = object["media"] as? [[String:Any]] {
                    for media in medias {
                        let mediaTypeString:String = String.stringValue(from: media["type"]) ?? ""
                        switch mediaTypeString {
                        case "photo":
                            mediaUrlString = String.stringValue(from: media["img"])
                            mediaType = TweetItemMediaType.Image
                            break
                        case "video":
                            mediaUrlString = String.stringValue(from: media["video"])
                            thumbUrl = String.stringValue(from: media["img"])
                            mediaType = TweetItemMediaType.Video
                            break
                        default: break
                        }
                    }
                }
                
                guard let item = TweetItem(id: idString, authorName: authorName, authorAccount: authorAccount, authorImageUrl: authorImageUrl, date: date, text: text, mediaUrlString: mediaUrlString) else {continue}
                item.mediaType = mediaType
                item.thumbUrl = thumbUrl
                if !ids.contains(idString) {
                    ids.append(idString)
                    items.append(item)
                }
            }
                       
            items.sort(by: { (a:TweetItem, b:TweetItem) -> Bool in
                return a.date > b.date
            })
            
            completion(items)
        }
    }
    
    
}
