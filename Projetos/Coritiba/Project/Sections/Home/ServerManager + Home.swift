//
//  ServerManager + Home.swift
//  
//
//  Created by Roberto Oliveira on 07/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

extension ServerManager {
    
    func getHomeBanners(id:Int, trackEvent:Int?, completion: @escaping (_ items:[AllNewsItem]?)->Void) {
        APIManager.shared.get(sufix: "getNoticias?home=\(id)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            var items:[AllNewsItem] = []
            if let objects = object["itens"] as? [[String:Any]] {
                for object in objects {
                    guard let id = Int.intValue(from: object["id"]), let imageUrl = String.stringValue(from: object["img"]) else {continue}
                    let urlString:String? = String.stringValue(from: object["url"])
                    let date:Date? = Date.dateFrom(string: String.stringValue(from: object["data"]) ?? "", format: "dd/MM/yyy")
                    
                    let title:String? = String.stringValue(from: object["titulo"])
                    let subtitle:String? = String.stringValue(from: object["desc"])
                    let category:String? = String.stringValue(from: object["cat"])
                    
                    let isDigitalMembershipOnly = Int.intValue(from: object["std"]) == 1
                    
                    items.append(AllNewsItem(id: id, date: date, title: title, subtitle: subtitle, imageUrl: imageUrl, category: category, urlString: urlString))
                }
            }
            completion(items)
        }
    }
    
    
    func getLastMatchesPreview(trackEvent:Int?, completion: @escaping (_ items:[ClubHomeLastMatchItem]?)->Void) {
        APIManager.shared.get(sufix: "getResultados?home=1", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            var items:[ClubHomeLastMatchItem] = []
            
            if let objects = object["itens"] as? [[String:Any]] {
                for obj in objects {
                    guard let id = Int.intValue(from: obj["id"]), let dateString = String.stringValue(from: obj["dataHora"]) else {continue}
                    guard let date = Date.dateFrom(string: dateString, format: "yyyy-MM-dd HH:mm:ss") else {continue}
                    let subtitle:String = String.stringValue(from: obj["desc"]) ?? ""
                    
                    // club 0
                    let score0:Int = Int.intValue(from: obj["golsClube1"]) ?? 0
                    let img0:String? = String.stringValue(from: obj["clubeImg1"])
                    let penaltiesScore0:Int? = Int.intValue(from: obj["penC1"])
                    
                    var color0:UIColor = UIColor.clear
                    let colorString0:String = String.stringValue(from: obj["cor1"]) ?? ""
                    if colorString0 != "" {
                        color0 = UIColor(hexString: colorString0)
                    }
                    
                    
                    // club 1
                    let score1:Int = Int.intValue(from: obj["golsClube2"]) ?? 0
                    let img1:String? = String.stringValue(from: obj["clubeImg2"])
                    let penaltiesScore1:Int? = Int.intValue(from: obj["penC2"])
                    
                    var color1:UIColor = UIColor.clear
                    let colorString1:String = String.stringValue(from: obj["cor2"]) ?? ""
                    if colorString1 != "" {
                        color1 = UIColor(hexString: colorString1)
                    }
                    
                    
                    items.append(ClubHomeLastMatchItem(id: id, date: date, subtitle: subtitle, color0: color0, club0Score: score0, club0ImageUrl: img0, penaltiesScore0: penaltiesScore0, color1: color1, club1Score: score1, club1ImageUrl: img1, penaltiesScore1: penaltiesScore1))
                }
            }
            completion(items)
        }
    }
    
    func getHomeQuizPreview(trackEvent:Int?, completion: @escaping (_ item:HomeQuizItem?)->Void) {
        APIManager.shared.get(sufix: "getQuizHome", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            guard let id = Int.intValue(from: object["id"]) else {
                completion(nil)
                return
            }
            let title = String.stringValue(from: object["titulo"]) ?? ""
            let imageUrlString = String.stringValue(from: object["img"]) ?? ""
            let message = String.stringValue(from: object["descricao"]) ?? ""
            
            // quantity
            let quantityString = String.stringValue(from: object["quantidade"]) ?? ""
            let quantityComponents = quantityString.components(separatedBy: "/")
            var answered:Int = 0
            if quantityComponents.count > 0 {
                answered = Int.intValue(from: quantityComponents[0]) ?? 0
            }
            let correct = Int.intValue(from: object["corretas"]) ?? 0
            let subtitle = correct.descriptionWithThousandsSeparator() + "/" + answered.descriptionWithThousandsSeparator()
            
            
            let item = HomeQuizItem(id: id, imageUrl: imageUrlString, title: title, subtitle: subtitle, message: message, answeredQuestions: answered)
            completion(item)
        }
    }
    
    
    func getHomeSurveyAnswers(trackEvent:Int?, completion: @escaping (_ items:[HomeSurveysAnswersItem]?)->Void) {
        APIManager.shared.get(sufix: "getPesquisasHome", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            var items:[HomeSurveysAnswersItem] = []
            if let objects = object["itens"] as? [[String:Any]] {
                for obj in objects {
                    guard let id = Int.intValue(from: obj["id"]), let title = String.stringValue(from: obj["grupo"]) else {continue}
                    let subtitle = String.stringValue(from: obj["pergunta"]) ?? ""
                    let imageUrlString = String.stringValue(from: obj["img"])
                    
                    var infos:[HomeSurveysAnswersItemInfo] = []
                    if let answers = obj["respostas"] as? [[String:Any]] {
                        var totalAnswersCounter:Int = 0
                        for answer in answers {
                            guard let answerCounter = Int.intValue(from: answer["qtd"]) else {continue}
                            totalAnswersCounter += answerCounter
                        }
                        for answer in answers {
                            guard let answerCounter = Int.intValue(from: answer["qtd"]), let answerTitle = String.stringValue(from: answer["resposta"]) else {continue}
                            let answerID = Int.intValue(from: answer["id"]) ?? 0
                            let progress:Float = (totalAnswersCounter == 0) ? 0 : Float(answerCounter)/Float(totalAnswersCounter)
                            let isHighlighted = Int.intValue(from: answer["h"]) == 1
                            infos.append(HomeSurveysAnswersItemInfo(id: answerID, title: answerTitle, progress: progress, isHighlighted: isHighlighted))
                        }
                    }
                    items.append(HomeSurveysAnswersItem(id: id, imageUrl: imageUrlString, title: title, subtitle: subtitle, infos: infos))
                    
                }
            }
            completion(items)
        }
    }
    
    
    
    
    func getHomeSquadInfo(trackEvent:Int?, completion: @escaping (_ item:SquadSelectorInfo?)->Void) {
        APIManager.shared.get(sufix: "getEscalacaoHome", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            guard let id = Int.intValue(from: object["id"]), let title = String.stringValue(from: object["titulo"]), let scheme = SquadScheme(rawValue: Int.intValue(from: object["esquema"]) ?? 1) else {
                completion(nil)
                return
            }
            
            var items:[Int:SquadSelectorItem] = [:]
            if let objects = object["players"] as? [[String:Any]] {
                for obj in objects {
                    guard let pos = Int.intValue(from: obj["pos"]), let objTitle = String.stringValue(from: obj["name"]) else {continue}
                    var description:String?
                    if let value = Int.intValue(from: obj["perc"]) {
                        description = "\(value.description)%"
                    }
                    let img = String.stringValue(from: obj["img"])
                    items[pos] = SquadSelectorItem(id: 0, title: objTitle, description: description, imageUrl: img)
                }
            }
            
            let item = SquadSelectorInfo(id: id, title: title, scheme: scheme)
            item.items = [
                1 : items[1],
                2 : items[2],
                3 : items[3],
                4 : items[4],
                5 : items[5],
                6 : items[6],
                7 : items[7],
                8 : items[8],
                9 : items[9],
                10 : items[10],
                11 : items[11],
            ]
            completion(item)
        }
    }
    
    
    
    
    
    func getHomeAudioLibrary(trackEvent:Int?, completion: @escaping (_ item:HomeAudioLibraryItem?)->Void) {
        APIManager.shared.get(sufix: "getAudiotecaHome", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            guard let id = Int.intValue(from: object["id"]) else {
                completion(nil)
                return
            }
            let title = String.stringValue(from: object["titulo"]) ?? ""
            let imageUrlString:String? = String.stringValue(from: object["img"])
            let urlString = String.stringValue(from: object["audio"]) ?? ""
            
            let item = HomeAudioLibraryItem(id: id, imageUrl: imageUrlString, title: title, urlString: urlString)
            completion(item)
        }
    }
    
    
    
    
    func getHomeCTA(trackEvent:Int?, completion: @escaping (_ item:HomeCTABannerItem?)->Void) {
        APIManager.shared.get(sufix: "getBanner", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            guard let id = Int.intValue(from: object["id"]) else {
                completion(nil)
                return
            }
            let isRatioFixed:Bool = Int.intValue(from: object["ratio"]) == 1
            var color = Theme.color(.PrimaryCardBackground)
            if let hex = String.stringValue(from: object["color"]) {
                color = UIColor(hexString: hex)
            }
            
            var imagesUrlString:[String] = []
            if let images = object["images"] as? [Any] {
                for image in images {
                    guard let imageUrl = String.stringValue(from: image) else {continue}
                    imagesUrlString.append(imageUrl)
                }
            }
            
            let mode:HomeCTABannerItem.Mode = HomeCTABannerItem.Mode(rawValue: Int.intValue(from: object["mode"]) ?? 0) ?? .Default
            
            
            for img in imagesUrlString {
                ServerManager.shared.downloadImage(urlSufix: img) { (_) in
                    // just to be cached
                }
            }
            
            
            let urlString = String.stringValue(from: object["link"]) ?? ""
            let sideMenuIconUrlString = String.stringValue(from: object["icon"])
            let sideMenuTitle = String.stringValue(from: object["title"]) ?? ""
            let isEmbed = WebContentPresentationMode.from(object["embed"])
            
            var deeplink:PushNotification?
            if let t = Int.intValue(from: object["t"]) {
                if let pushType = PushNotificationType(rawValue: t) {
                    deeplink = PushNotification(type: pushType, id: id, value1: Int.intValue(from: object["v"]), value2: Int.intValue(from: object["v2"]))
                }
            }
            
            
            if isRatioFixed && !imagesUrlString.isEmpty {
                let imgurl = imagesUrlString.first ?? ""
                ServerManager.shared.downloadImage(urlSufix: imgurl) { (img:UIImage?) in
                    var ratio:CGFloat = 0.0
                    if let i = img {
                        ratio = i.size.height / i.size.width
                    }
                    let item = HomeCTABannerItem(id: id, color: color, mode: mode, imagesUrlString: imagesUrlString, sideMenuIconUrlString: sideMenuIconUrlString, sideMenuTitle: sideMenuTitle, urlString: urlString, isEmbed: isEmbed, deeplink: deeplink, fixedRatio: ratio)
                    completion(item)
                }
                
            } else {
                let item = HomeCTABannerItem(id: id, color: color, mode: mode, imagesUrlString: imagesUrlString, sideMenuIconUrlString: sideMenuIconUrlString, sideMenuTitle: sideMenuTitle, urlString: urlString, isEmbed: isEmbed, deeplink: deeplink, fixedRatio: nil)
                completion(item)
            }
        }
    }
    
    
    func getHomeVideo(trackEvent:Int?, completion: @escaping (_ item:HomeVideoItem?)->Void) {
        APIManager.shared.get(sufix: "getVideos", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            
            guard let items = object["itens"] as? [[String:Any]], let item = items.first else {
                completion(nil)
                return
            }
            
            let id = Int.intValue(from: item["id"]) ?? 0
            guard let urlString = String.stringValue(from: item["url"]) else {
                completion(nil)
                return
            }
            
            let imageUrl:String = String.stringValue(from: object["imgTit"]) ?? ""
            ServerManager.shared.downloadImage(urlSufix: imageUrl) { (img:UIImage?) in
                let obj = HomeVideoItem(id: id , urlString: urlString, headerImage: img)
                completion(obj)
            }
            
        }
    }
    
    
}
