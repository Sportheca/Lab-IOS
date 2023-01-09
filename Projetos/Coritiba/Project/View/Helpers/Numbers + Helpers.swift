//
//  Numbers + Helpers.swift
//
//
//  Created by Roberto Oliveira on 30/08/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit


extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * .pi / 180
    }
}
extension Float {
    /// Rounds the float to decimal places value
    func roundTo(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
    
    // Money Format
    func moneyFormatBRL(includeSymbol:Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        let value = formatter.string(for: self) ?? self.description
        if includeSymbol {
            return "R$ \(value)"
        } else {
            return value
        }
    }
    
    static func floatValue(from: Any?) -> Float? {
        if let float = from as? Float {
            return float
        }
        if let double = from as? Double {
            return Float(double)
        }
        if let string = String.stringValue(from: from) {
            if let float = Float(string) {
                return float
            }
            if let double = Double(string) {
                return Float(double)
            }
        }
        if let value = Int.intValue(from: from) {
            return Float(value)
        }
        return nil
    }
    
    func formattedDescription() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        return formatter.string(for: self) ?? self.description
    }
    
    func formattedDescription(places:Int, grouping:String, decimal:String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = grouping
        formatter.decimalSeparator = decimal
        formatter.minimumFractionDigits = places
        formatter.maximumFractionDigits = places
        formatter.alwaysShowsDecimalSeparator = true
        return formatter.string(for: self) ?? self.description
    }
    
}

extension Int {
    static func intValue(from: Any?) -> Int? {
        if let value = from as? Int {
            return value
        }
        if let float = from as? Float {
            return Int(float)
        }
        if let double = from as? Double {
            return double.isNaN ? nil : Int(double)
        }
        if let string = from as? String {
            if let value = Int(string) {
                return value
            }
            if let float = Float(string) {
                return Int(float)
            }
            if let double = Double(string) {
                return Int(double)
            }
        }
        return nil
    }
}

extension Int {
    func descriptionWithThousandsSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(for: self) ?? self.description
    }
    
    func descriptionWithPostfix() -> String {
        if self >= 1_000_000 {
            return (Float(self)/1_000_000).formattedDescription(places: 1, grouping: "", decimal: ".") + "M"
        } else if self >= 1_000 {
            return (Float(self)/1_000).formattedDescription(places: 1, grouping: "", decimal: ".") + "K"
        } else {
            return self.descriptionWithThousandsSeparator()
        }
    }
}
