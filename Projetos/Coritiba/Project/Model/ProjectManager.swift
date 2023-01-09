//
//  ProjectManager.swift
//
//
//  Created by Roberto Oliveira on 19/07/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

class ProjectManager {
    private init() {}
    static var shared:ProjectManager = ProjectManager()
    
    // MARK: - Main Information
    // AppStore Link
    var itunesLink:String = ""
    // Server API Path
    var apiPath:String = "/api/"
    
    
    // MARK: - Server Information
    // Server Url
    static let mainUrl:String = ProjectInfoManager.ServerInfo.BASE_URL.rawValue
    // Server API key
    static let serverAPIKey:String = ProjectInfoManager.ServerInfo.API_KEY.rawValue
    // Server Images Path
    static let imagesPath:String = "/Content/images/"
    // Server Files Path
    static let filesPath:String = "/Content/"
    // MARK: - Local Information
    static let downloadsPath:String = "Downloads"
    
    
    /*
     1º - Copiar o arquivo dSYMs.zip para a pasta raiz do Projeto iOS
     2º - Executar no terminal para encontrar dSYM files
     mdfind -name .dSYM | while read -r line; do dwarfdump -u "$line"; done
     3º - Executar o comando abaixo no terminal
    Pods/FirebaseCrashlytics/upload-symbols -gsp Project/Assets/GoogleService-Info.plist -p ios dSYMs.dSYM
    */
    
}



extension ProjectManager {

 static let externalURLSchemes: [String] = {
     guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]] else {
        return []
    }
    var result: [String] = []
    for urlTypeDictionary in urlTypes {
        guard let urlSchemes = urlTypeDictionary["CFBundleURLSchemes"] as? [String] else { continue }
        result = urlSchemes
    }
    return result
 }()

}
