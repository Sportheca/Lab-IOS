//
//  ProjectInfoManager.swift
//
//
//  Created by Roberto Oliveira on 26/11/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class ProjectInfoManager {
    
    
    // MARK: - Server
    enum ServerInfo:String {
        case BASE_URL = "https://api.appdocoxa.com.br"
        case API_KEY = "X-SMApiKey"
    }
    
    
    
    
    // MARK: - Text Infos
    enum TextInfo:String {
        case ativar_notificacoes = "Coxa-Branca, ative as notificações para receber notícias em primeira mão e ficar por dentro de tudo que acontece no Coritiba!"// iOS only
        case baixe_agora_o_app = "Baixe agora o app oficial do Coxa e fique por dentro de tudo que acontece no Coritiba!"
        case faca_o_seu_no_app_oficial = "Faça a sua no app oficial do Coxa!"
        case loja_rodape = "Ao selecionar um produto, você será redirecionado para a loja oficial do Coxa."
        case loja_subtitulo = "Confira os produtos da loja oficial do Coxa."
        case loja_titulo = "Sou 1909"
        case ola_clube = "Olá, Coxa-Branca!"
    }
    
    
    
    
    // MARK: - Colors
    static func colorHexStringFrom(_ reference:Theme.Color) -> String {
        switch reference {
            case .PrimaryBackground: return "00544d"
            case .PrimaryText: return "ffffff"
            case .MutedText: return "aaaaaa"
            case .TextOverSplashImage: return "ffffff"
            case .PrimaryButtonBackground: return "fad816"
            case .PrimaryButtonText: return "212121"
            case .PrimaryAnchor: return "fad816"
            case .TabBarBackground: return "012A27"
            case .TabBarSelected: return "fad816"
            case .TabBarUnselected: return "ffffff"
            case .PrimaryCardBackground: return "003d38"
            case .PrimaryCardElements: return "ffffff"
            case .SecondaryCardBackground: return "ffffff"
            case .SecondaryCardElements: return "323232"
            case .AlternativeCardBackground: return "1d1d1d"
            case .AlternativeCardElements: return "ffffff"
            case .PageHeaderBackground: return "1d1d1d"
            case .PageHeaderText: return "ffffff"
            case .AudioLibraryMainButtonBackground: return "fad816"
            case .AudioLibraryMainButtonText: return "003d38"
            case .AudioLibrarySecondaryButtonBackground: return "003d38"
            case .AudioLibrarySecondaryButtonText: return "ffffff"
            case .SurveyOptionBackground: return "ffffff"
            case .SurveyOptionText: return "323232"
            case .SurveyOptionProgress: return "fad816"
            case .MembershipCardPrimaryElements: return "ffffff"
            case .MembershipCardSecondaryElements: return "aaaaaa"
            case .ScheduleBackground: return "003d38"
            case .ScheduleElements: return "ffffff"
            case .TwitterCardBackground: return "000000"
            case .TwitterCardPrimaryText: return "ffffff"
            case .TwitterCardMutedText: return "969696"
            case .TwitterCardAnchor: return "0084b4"
        }
    }
    
    
    
    
    // MARK: - Google Ads
    enum GoogleAdsAdUnit:String {
        /* DON'T FORGET TO CHANGE ADMOB APP ID ON Info.plist */
        case BannerHome = "ca-app-pub-6965406932839627/1855301712"
        case BannerQuizQuestion = "ca-app-pub-6965406932839627/6916056707"
        case BannerClubHome = "ca-app-pub-6965406932839627/6835972131"
        case BannerSchedule = "ca-app-pub-6965406932839627/3607173569"
        case BannerNews = "ca-app-pub-6965406932839627/3172059293"
        case BannerSurveys = "ca-app-pub-6965406932839627/3627370770"
        case InterstitialQuiz = "ca-app-pub-6965406932839627/2521322606"
        case InterstitialSquadSelector = "ca-app-pub-6965406932839627/1827381558"
        case InterstitialMultipleSurveys = "ca-app-pub-6965406932839627/7582077592"
    }
    
    
    
}


