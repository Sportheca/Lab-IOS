//
//  TweetItem.swift
//
//
//  Created by Roberto Oliveira on 21/06/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class TweetItem {
    
    // MARK: - Properties
    var id:String
    var authorName:String
    var authorAccount:String
    var authorImageUrl:String
    var date:Date
    var text:String
    var mediaLink:String
    var mediaType:TweetItemMediaType?
    var mediaUrl:String?
    var thumbUrl:String?
    
    
    // MARK: - Init Methods
    init?(id:String, authorName:String, authorAccount:String, authorImageUrl:String, date:Date, text:String, mediaUrlString:String?) {
        self.id = id
        self.authorName = authorName
        self.authorAccount = authorAccount
        self.authorImageUrl = authorImageUrl
        self.date = date
        
//        self.text = text
//        self.mediaLink = ""
        // Split text from media link
        var validWords:[String] = []
        let words = text.components(separatedBy: " ")
        let mediaPrefix:String = "https://t.co/"
//        var mediaLink:String?
        for (_, word) in words.enumerated() {
            if !word.contains(otherString: mediaPrefix) {
                validWords.append(word)
            } else {
//                if index == words.count-1 {
//                    let words = word.components(separatedBy: mediaPrefix)
//                    mediaLink = mediaPrefix + (words.last ?? "")
//                }
            }
        }
        let trimmed = validWords.joined(separator: " ").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard !trimmed.isEmpty else {return nil}
        self.text = trimmed
        
        if let value = mediaUrlString {
            self.mediaLink = value
            self.mediaUrl = value
            self.mediaType = .Image
        } else {
            return nil
        }
        
//        if let link = mediaLink {
//            self.mediaLink = link
//        } else {
//            return nil
//        }
        
        
    }
    
}








