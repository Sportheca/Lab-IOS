//
//  TwitterApiManager.swift
//  
//
//  Created by Roberto Oliveira on 07/05/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

class TwitterApiManager {
    
    // MARK: - shared access
    private init() {}
    static let shared:TwitterApiManager = TwitterApiManager()
    
    // MARK: - Settings
    var twitterKey:String = ""
    var twitterSecret:String = ""
    
    
    // MARK: - Properties
    private let accessTokenKey:String = "accessTokenKey"
    private var accessToken:String = ""
    
    
    
    // MARK: - Methods
    func getNewToken(completion: @escaping (_ success:Bool)->Void) {
        let urlString = "https://api.twitter.com/oauth2/token/"
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        // Create HTTP request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // TimeOut
        request.timeoutInterval = 15.0 // 15 seconds to timeOut
        
        // Convert info to JSON and set as httpBody
        var body = ""
        for (key,value) in ["grant_type":"client_credentials"] {
            body.append("\(key)=\(value)&")
        }
        body.removeLast()
        request.httpBody = body.data(using: String.Encoding.utf8, allowLossyConversion: true)
        
        // Request Header
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let authorizationString = "\(TwitterApiManager.shared.twitterKey):\(TwitterApiManager.shared.twitterSecret)".data(using: .utf8)?.base64EncodedString() ?? ""
        request.setValue("Basic \(authorizationString)", forHTTPHeaderField: "Authorization")
        
        // Create and resume Task
        URLSession.shared.dataTask(with: request, completionHandler: { (dataObj:Data?, responseObj:URLResponse?, errorObj:Error?) in
            guard let data = dataObj else {
                completion(false)
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            let dict = responseJSON as? [String: Any]
            let token = String.stringValue(from: dict?["access_token"]) ?? self.accessToken
            Foundation.UserDefaults.standard.set(token, forKey: self.accessTokenKey)
            completion(true)
            return
        }).resume()
    }
    
    
    
    func loadTweetsFrom(search:String, limited:Bool, completion: @escaping (_ items:[TweetItem])->Void) {
        self.accessToken = String.stringValue(from: Foundation.UserDefaults.standard.value(forKey: self.accessTokenKey)) ?? self.accessToken
        
        if self.accessToken == "" {
            self.getNewToken { (success:Bool) in
                if success {
                    self.loadTweetsFrom(search: search, limited: limited, completion: completion)
                } else {
                    completion([])
                }
            }
            return
        }
        
//        let searchString = limited ? search : search.replacingOccurrences(of: "filter:images", with: "")
        let queryString = search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? search
        let maxCount:Int = limited ? 20 : 200
        let urlString = "https://api.twitter.com/1.1/search/tweets.json?q=\(queryString)&result_type=mixed&count=\(maxCount)&tweet_mode=extended"
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        // Create HTTP request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // TimeOut
        request.timeoutInterval = 15.0 // 15 seconds to timeOut
        
        // Request Header
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Create and resume Task
        URLSession.shared.dataTask(with: request, completionHandler: { (dataObj:Data?, responseObj:URLResponse?, errorObj:Error?) in
            guard let data = dataObj else {
                completion([])
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = responseJSON as? [String: Any] else {
                completion([])
                return
            }
            
            let items = self.parseTweetsInfo(dict: dict)
            completion(items)
            return
        }).resume()
        
    }
    
    
    
    
    
    private func parseTweetsInfo(dict:[String:Any]) -> [TweetItem] {
        guard let objects = dict["statuses"] as? [[String:Any]] else {return []}
        
        var items:[TweetItem] = []
        var ids:[String] = []
        
        for object in objects {
            guard let idString = String.stringValue(from: object["id"]), let user = object["user"] as? [String:Any] else {continue}
            let authorName = String.stringValue(from: user["name"]) ?? ""
            let authorAccount = String.stringValue(from: user["screen_name"]) ?? ""
            let authorImageUrl = String.stringValue(from: user["profile_image_url_https"]) ?? ""
            let text = String.stringValue(from: object["full_text"]) ?? ""
            
            // date
            let dateString = String.stringValue(from: object["created_at"]) ?? ""
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
            let date = formatter.date(from: dateString) ?? Date.now()
            
            var mediaUrlString:String?
            if let entities = object["entities"] as? [String:Any] {
                if let medias = entities["media"] as? [[String:Any]] {
                    if let media = medias.first {
                        mediaUrlString = String.stringValue(from: media["media_url"])
                    }
                }
            }
            
            guard let item = TweetItem(id: idString, authorName: authorName, authorAccount: authorAccount, authorImageUrl: authorImageUrl, date: date, text: text, mediaUrlString: mediaUrlString) else {continue}
            
            if !ids.contains(idString) {
                ids.append(idString)
                items.append(item)
            }
        }
                   
        items.sort(by: { (a:TweetItem, b:TweetItem) -> Bool in
            return a.date > b.date
        })
        
        return items
    }
    
    
}
