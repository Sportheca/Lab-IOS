//
//  FontsManager.swift
//
//
//  Created by Roberto Oliveira on 22/05/2018.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit

class FontsManager {
    
    static func customFont(key:String, size: CGFloat) -> UIFont {
        return UIFont(name: key, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func exploreFonts() {
        for family in UIFont.familyNames {
            for font in UIFont.fontNames(forFamilyName: family) {
//                if font.contains(otherString: "Roboto") {
//                    print("static let \(font.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "Roboto", with: "")) = \"\(font)\"")
//                }
                
                print("static let == \(font)")
            }
        }
    }
    
    struct Papyrus {
        static var Normal = "Papyrus"
        static var Condensed = "Papyrus-Condensed"
    }
    
    struct SavoyeLet {
        static var Normal = "SavoyeLetPlain"
    }
    
    struct PartyLet {
        static var Normal = "PartyLetPlain"
    }
    
    struct Chalkduster {
        static var Normal = "Chalkduster"
    }
    
    struct Helvetica {
        static var UltraLightItalic = "HelveticaNeue-UltraLightItalic"
        static var Medium = "HelveticaNeue-Medium"
        static var MediumItalic = "HelveticaNeue-MediumItalic"
        static var UltraLight = "HelveticaNeue-UltraLight"
        static var Italic = "HelveticaNeue-Italic"
        static var Light = "HelveticaNeue-Light"
        static var ThinItalic = "HelveticaNeue-ThinItalic"
        static var LightItalic = "HelveticaNeue-LightItalic"
        static var Bold = "HelveticaNeue-Bold"
        static var Thin = "HelveticaNeue-Thin"
        static var CondensedBlack = "HelveticaNeue-CondensedBlack"
        static var Normal = "HelveticaNeue"
        static var CondensedBold = "HelveticaNeue-CondensedBold"
        static var BoldItalic = "HelveticaNeue-BoldItalic"
    }
    
    struct Avenir {
        static var Oblique = "Avenir-Oblique"
        static var HeavyOblique = "Avenir-HeavyOblique"
        static var Heavy = "Avenir-Heavy"
        static var BlackOblique = "Avenir-BlackOblique"
        static var BookOblique = "Avenir-BookOblique"
        static var Roman = "Avenir-Roman"
        static var Medium = "Avenir-Medium"
        static var Black = "Avenir-Black"
        static var Light = "Avenir-Light"
        static var MediumOblique = "Avenir-MediumOblique"
        static var Book = "Avenir-Book"
        static var LightOblique = "Avenir-LightOblique"
    }
    
    struct AmericanTypewriter {
        static var CondensedBold = "AmericanTypewriter-CondensedBold"
        static var Condensed = "AmericanTypewriter-Condensed"
        static var CondensedLight = "AmericanTypewriter-CondensedLight"
        static var Normal = "AmericanTypewriter"
        static var Bold = "AmericanTypewriter-Bold"
        static var Semibold = "AmericanTypewriter-Semibold"
        static var Light = "AmericanTypewriter-Light"
    }
    
    struct OpenSans {
        static var BoldItalic = "OpenSans-BoldItalic"
        static var Normal = "OpenSans"
        static var Bold = "OpenSans-Bold"
        static var Semibold = "OpenSans-Semibold"
        static var Light = "OpenSans-Light"
    }
    
    struct Roboto {
        static let Regular = "Roboto-Regular"
        static let Black = "Roboto-Black"
        static let Light = "Roboto-Light"
        static let BoldItalic = "Roboto-BoldItalic"
        static let LightItalic = "Roboto-LightItalic"
        static let Thin = "Roboto-Thin"
        static let MediumItalic = "Roboto-MediumItalic"
        static let Medium = "Roboto-Medium"
        static let Bold = "Roboto-Bold"
        static let BlackItalic = "Roboto-BlackItalic"
        static let Italic = "Roboto-Italic"
        static let ThinItalic = "Roboto-ThinItalic"
    }
    
    struct Apex {
        static let Bold = "ApexSerif-Bold"
    }
    
    struct Knockout {
        static let Regular = "Knockout-HTF49-Liteweight"
    }
}
