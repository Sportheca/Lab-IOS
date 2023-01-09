//
//  TwitterManager.swift
//
//
//  Created by Roberto Oliveira on 27/09/18.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit
import WebKit

// Workflow

// 1 - Twitter framework supply an encode URL
// 2 - TwitterManager load content and figure out what type of media to display
// 3 - Receiver display media properly

enum TweetItemMediaType {
    case Image
    case Video
    case GIF
}

class TwitterManager {
    
    // MARK: - Properties
    var completion:((_ id:String, _ urlString:String?, _ mediaType:TweetItemMediaType?)->Void)?
    var tweetId:String = String()
    private var timer:Timer?
    private let webView:WKWebView = WKWebView()
    
    
    
    
    // MARK: - Timer Method
    @objc func checkWebViewContent() {
        self.webView.evaluateJavaScript("document.documentElement.outerHTML") { (object:Any?, error:Error?) in
            let contentString = object as? String ?? ""
            // Check if it is video or GIF (GIF is an mp4 file)
            var mediaType:TweetItemMediaType?
            if contentString.contains(".m3u8") {
                mediaType = .Video
            } else if contentString.contains(".mp4") {
                mediaType = .GIF
            }
            // Call Completion if media is founded
            if mediaType != nil {
                self.timer?.invalidate()
                self.timer = nil
                let components = contentString.components(separatedBy: "src=\"")
                
                // Completion for Videos
                if mediaType == .Video {
                    for component in components {
                        if component.contains("m3u8") {
                            let link = component.components(separatedBy: "\"").first ?? ""
                            self.completion?(self.tweetId, link, .Video)
                            self.completion = nil
                            return
                        }
                    }
                }
                
                // Completion for GIFs
                if mediaType == .GIF {
                    for component in components {
                        if component.contains("mp4") {
                            let link = component.components(separatedBy: "\"").first ?? ""
                            self.completion?(self.tweetId, link, .GIF)
                            self.completion = nil
                            return
                        }
                    }
                }
                
            }
        }
        return
    }
    
    
    func getTweetInfo(id:String, mediaUrl:String, completion: @escaping (_ id:String, _ urlString:String?, _ mediaType:TweetItemMediaType?)->Void) {
        self.tweetId = id
        self.completion = completion
        guard let url = URL(string: mediaUrl) else {
            completion(self.tweetId, nil, nil)
            return
        }
        do {
            let htmlString = try String(contentsOf: url, encoding: String.Encoding.utf8)
            
            var isValid:Bool = false
            
            // Check if it is a Video or GIF
            if htmlString.contains("og:video:url\" content=\"") {
                let components = htmlString.components(separatedBy: "og:video:url\" content=\"")
                guard components.count > 1, let videoUrl = URL(string: components[1].components(separatedBy: "\"").first ?? "") else {
                    completion(self.tweetId, nil, nil)
                    return
                }
                isValid = true
                DispatchQueue.main.async {
                    self.webView.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
                    self.webView.load(URLRequest(url: videoUrl))
                    self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.checkWebViewContent), userInfo: nil, repeats: true)
                    RunLoop.main.add(self.timer!, forMode: .common)
                }
                return
            }
            
            
            // If it is not a video, check if it is an Image
            if htmlString.contains("og:image\" content=\"") {
                isValid = true
                let components = htmlString.components(separatedBy: "og:image\" content=\"")
                guard components.count > 1, let imageUrl = URL(string: components[1].components(separatedBy: "\"").first ?? "") else {
                    completion(self.tweetId, nil, nil)
                    return
                }
                self.completion?(self.tweetId, imageUrl.absoluteString, .Image)
                self.completion = nil
                return
            }
            
            
            // If it is not video, gif or image, then call completion with nil
            if !isValid {
                completion(self.tweetId, nil, nil)
                return
            }
        } catch {
            completion(self.tweetId, nil, nil)
            return
        }
    }
    
}





