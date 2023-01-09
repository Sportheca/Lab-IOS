//
//  UIColor + Initializers.swift
//
//
//  Created by Roberto Oliveira on 14/03/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

extension UIColor {
    
    // Helper to create rgb colors
    convenience init(R: Int, G: Int, B: Int) {
        self.init(red: CGFloat(R)/255, green: CGFloat(G)/255, blue: CGFloat(B)/255, alpha: 1.0)
    }
    
    convenience init(R: Int, G: Int, B: Int, A:CGFloat) {
        self.init(red: CGFloat(R)/255, green: CGFloat(G)/255, blue: CGFloat(B)/255, alpha: A)
    }
    
    
    // Hex initializers
    convenience init(hex:Int) {
        self.init(R:(hex >> 16) & 0xff, G:(hex >> 8) & 0xff, B:hex & 0xff)
    }
    
    convenience init(hexString: String) {
        self.init(hex: hexString, alphaValue: 1.0)
    }
    
    convenience init(hex: String, alphaValue: CGFloat) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((Array(cString).count) != 6) {
            self.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
            return
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        self.init(red: (CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0), green: (CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0), blue: (CGFloat(rgbValue & 0x0000FF) / 255.0), alpha: alphaValue)
    }
    
    func grayScale() -> UIColor {
        let grayScale = self.cgColor.components ?? []
        var total:CGFloat = 0.0
        for i in 0..<3 {
            guard grayScale.count > i else {continue}
            total += grayScale[i]
        }
        return UIColor(white: total/3, alpha: 1.0)
    }
    
}
