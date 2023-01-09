//
//  Theme.swift
//
//
//  Created by Roberto Oliveira on 25/06/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

enum ColorScheme:Int {
    case Primary = 1
    case Secondary = 2
    
    func primaryColor() -> UIColor {
        switch self {
        case .Primary: return Theme.color(.PrimaryCardBackground)
        case .Secondary: return Theme.color(.SecondaryCardBackground)
        }
    }
    
    func elementsColor() -> UIColor {
        switch self {
        case .Primary: return Theme.color(.PrimaryCardElements)
        case .Secondary: return Theme.color(.SecondaryCardElements)
        }
    }
    
    static func schemeAt(index:Int) -> ColorScheme {
        let schemes:[ColorScheme] = [ColorScheme.Primary, ColorScheme.Secondary]
        let i = index % schemes.count
        let scheme:ColorScheme = i < schemes.count ? schemes[i] : .Primary
        return scheme
    }
    
}


class Theme {
    private init() {}
    static let systemDestructiveColor = UIColor(R: 255, G: 56, B: 35)
    
    static func statusBarStyle() -> UIStatusBarStyle {
        // User Interface is Dark
        return .lightContent
//        // User Interface is Light
//        if #available(iOS 13.0, *) {
//            return .darkContent
//        } else {
//            return .default
//        }
    }
    
    static func color(_ from:Color) -> UIColor {
        DebugManager.shared.colorsDataSource.insert(from)
        let color = UIColor(hexString: ProjectInfoManager.colorHexStringFrom(from))
        if DebugManager.isDebugModeEnabled {
            if let debugColor = DebugManager.shared.colorToBeDebugged {
                if from == debugColor {
                    return UIColor.magenta
                }
                return color.grayScale()
            }
        }
        return color
    }
    
    
    enum Color {
        // Primary Background
        case PrimaryBackground // default background
        // Texts
        case PrimaryText // default texts, icons...
        case MutedText // subtitles, secondary infos, disabled items...
        // Splash Image
        case TextOverSplashImage // text & buttons over Splash Image. Splash, Maintenance, Login, Signup, Request Notification...
        // Buttons
        case PrimaryButtonBackground // default button back
        case PrimaryButtonText // default button title/icon
        case PrimaryAnchor // default anchor
        // Tab Bar
        case TabBarBackground // bottom menu back
        case TabBarSelected // bottom menu selected item
        case TabBarUnselected // bottom menu unselected item
        // Cards
        case PrimaryCardBackground
        case PrimaryCardElements
        case SecondaryCardBackground
        case SecondaryCardElements
        case AlternativeCardBackground
        case AlternativeCardElements
        // Page Header
        case PageHeaderBackground // custom nav bar background
        case PageHeaderText // custom nav bar elements
        // Audio Library
        case AudioLibraryMainButtonBackground // audio player main button (play, pause, download and floating) background
        case AudioLibraryMainButtonText // audio player main button (play, pause, download and floating) title/icon
        case AudioLibrarySecondaryButtonBackground // audio player secondary button (previous & next track) background
        case AudioLibrarySecondaryButtonText // audio player secondary button (previous & next track) icon
        // Surveys
        case SurveyOptionBackground // survey options & textview background
        case SurveyOptionText // survey options & textview text
        case SurveyOptionProgress // survey options & textview progress
        // Membership Card
        case MembershipCardPrimaryElements // membership card avatar placeholder and infos
        case MembershipCardSecondaryElements // membership card info titles
        // Schedule Card
        case ScheduleBackground
        case ScheduleElements
        // Twitter Card
        case TwitterCardBackground // tweet background
        case TwitterCardPrimaryText // tweet text & author
        case TwitterCardMutedText // tweet account & date
        case TwitterCardAnchor // tweet "read more"
    }
    
    
    
}



extension Theme.Color {
    
    
    func title() -> String {
        switch self {
            case .PrimaryBackground: return "PrimaryBackground"
            case .PrimaryText: return "PrimaryText"
            case .MutedText: return "MutedText"
            case .TextOverSplashImage: return "TextOverSplashImage"
            case .PrimaryButtonBackground: return "PrimaryButtonBackground"
            case .PrimaryButtonText: return "PrimaryButtonText"
            case .PrimaryAnchor: return "PrimaryAnchor"
            case .TabBarBackground: return "TabBarBackground"
            case .TabBarSelected: return "TabBarSelected"
            case .TabBarUnselected: return "TabBarUnselected"
            case .PrimaryCardBackground: return "PrimaryCardBackground"
            case .PrimaryCardElements: return "PrimaryCardElements"
            case .SecondaryCardBackground: return "SecondaryCardBackground"
            case .SecondaryCardElements: return "SecondaryCardElements"
            case .AlternativeCardBackground: return "AlternativeCardBackground"
            case .AlternativeCardElements: return "AlternativeCardElements"
            case .PageHeaderBackground: return "PageHeaderBackground"
            case .PageHeaderText: return "PageHeaderText"
            case .AudioLibraryMainButtonBackground: return "AudioLibraryMainButtonBackground"
            case .AudioLibraryMainButtonText: return "AudioLibraryMainButtonText"
            case .AudioLibrarySecondaryButtonBackground: return "AudioLibrarySecondaryButtonBackground"
            case .AudioLibrarySecondaryButtonText: return "AudioLibrarySecondaryButtonText"
            case .SurveyOptionBackground: return "SurveyOptionBackground"
            case .SurveyOptionText: return "SurveyOptionText"
            case .SurveyOptionProgress: return "SurveyOptionProgress"
            case .MembershipCardPrimaryElements: return "MembershipCardPrimaryElements"
            case .MembershipCardSecondaryElements: return "MembershipCardSecondaryElements"
            case .ScheduleBackground: return "ScheduleBackground"
            case .ScheduleElements: return "ScheduleElements"
            case .TwitterCardBackground: return "TwitterCardBackground"
            case .TwitterCardPrimaryText: return "TwitterCardPrimaryText"
            case .TwitterCardMutedText: return "TwitterCardMutedText"
            case .TwitterCardAnchor: return "TwitterCardAnchor"
        }
    }
    
}


class DeviceManager {
    private init() {}
    static let shared:DeviceManager = DeviceManager()
    
    var defaultSafeAreaInsets:UIEdgeInsets = UIEdgeInsets.zero
    
}
