//
//  String + Helpers.swift
//
//
//  Created by Roberto Oliveira on 08/06/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

extension String {
    static func stringValue(from: Any?) -> String? {
        if let string = from as? String {
            return string
        }
        if let intV = (from as? Int)?.description {
            return intV
        }
        if let float = from as? Float {
            return float.description
        }
        if let double = from as? Double {
            return double.description
        }
        if let int = Int.intValue(from: from) {
            return int.description
        }
        return nil
    }
    
    static func vCardFrom(firstName:String, lastName:String, phone:String, email:String) -> String {
        let str = "BEGIN:VCARD\nVERSION:3.0\nFN;CHARSET=UTF-8:\(firstName) \(lastName)\nN;CHARSET=UTF-8:\(lastName);\(firstName);;;\nEMAIL;CHARSET=UTF-8;INTERNET:\(email)\nTEL;TYPE=CELL:\(phone)\nEND:VCARD"
        return str
    }
    
}

// MARK: - Content
extension String {
    // Content confirmations
    func contains(otherString: String) -> Bool {
        return self.range(of: otherString) != nil
    }
    
    func containOnlyAllowedCharaters(characters: [Character]) -> Bool {
        //  Cast itself to array of characters and keep only not allowed characters
        let notAllowedCharacters = Array(self).filter({return !(characters.contains($0))})
        return notAllowedCharacters.isEmpty
    }
    
    func containOnlyCPFCharacters() -> Bool {
        let cpfAllowedCharacters:[Character] = ["0","1","2","3","4","5","6","7","8","9","-","."]
        if Array(self.numbersOnly()).count <= 11 {
            return self.containOnlyAllowedCharaters(characters: cpfAllowedCharacters)
        } else {
            return false
        }
    }
    
    func containOnlyPhoneCharacters() -> Bool {
        let phoneAllowedCharacters:[Character] = ["0","1","2","3","4","5","6","7","8","9","(",")","-"," "]
        if Array(self.numbersOnly()).count <= 11 {
            return self.containOnlyAllowedCharaters(characters: phoneAllowedCharacters)
        } else {
            return false
        }
    }
    
    func containOnlyZipCodeCharacters() -> Bool {
        let allowedCharacters:[Character] = ["0","1","2","3","4","5","6","7","8","9","-"]
        if Array(self.numbersOnly()).count <= 8 {
            return self.containOnlyAllowedCharaters(characters: allowedCharacters)
        } else {
            return false
        }
    }
    
    func isValidEmailFormat() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    
    
    // MARK: - Filters
    func numbersOnly() -> String {
        // Cast itself to array of characters and keep only numbers characters
        let numbersChars:[Character] = ["0","1","2","3","4","5","6","7","8","9"]
        let numbers = Array(self).filter({return (numbersChars.contains($0))})
        return String(numbers)
    }
    
}






// MARK: - Substrings
enum CharacterPosition {
    case first
    case last
}

extension String {
    
    // Substring Up to position/character
    func substringUpTo(position:Int) -> String {
        let index = self.index(self.startIndex, offsetBy: position)
        return String(self[..<index])
    }
    
    func substringUpTo(char:Character, at:CharacterPosition, charIncluded:Bool, caseSensitive:Bool = false) -> String {
        let mainString = caseSensitive ? self : self.lowercased()
        let character = caseSensitive ? char : Character(String(char).lowercased())
        guard let positionOfChar = mainString.positionOf(char: character, at: at) else {return self}
        let position = charIncluded ? (positionOfChar + 1) : positionOfChar
        return self.substringUpTo(position: position)
    }
    
    // Substring From position/character
    func substringFrom(position:Int) -> String {
        let index = self.index(self.startIndex, offsetBy: position)
        return String(self[index...])
    }
    
    func substringFrom(char:Character, at:CharacterPosition, charIncluded:Bool, caseSensitive:Bool = false) -> String {
        let mainString = caseSensitive ? self : self.lowercased()
        let character = caseSensitive ? char : Character(String(char).lowercased())
        guard let positionOfChar = mainString.positionOf(char: character, at: at) else {return self}
        let position = charIncluded ? positionOfChar : (positionOfChar + 1)
        return self.substringFrom(position: position)
    }
    
    // First or Last position of a character
    func positionOf(char: Character, at:CharacterPosition) -> Int? {
        var lastCharPositon:Int?
        let characters = Array(self)
        for (index, character) in characters.enumerated() {
            if character == char {
                if at == .last {
                    lastCharPositon = index
                } else if at == .first {
                    return index
                }
            }
        }
        if let position = lastCharPositon {
            return position
        }
        return nil
    }
}










// MARK: - Masks
extension String {
    // CPF Mask
    func withMaskCPF() -> String {
        // Cast itself to array of characters and add separators
        let characters = Array(self.numbersOnly())
        var newString = ""
        for (index,char) in characters.enumerated() {
            switch index {
            case 3,6:
                newString.append(".")
                newString.append(char)
                break
            case 9:
                newString.append("-")
                newString.append(char)
                break
            default: newString.append(char)
            }
        }
        return newString
    }
    
    
    // ZipCode Mask
    func withMaskZipCode() -> String {
        // Cast itself to array of characters and add separators
        let characters = Array(self.numbersOnly())
        if characters.count == 0 {
            return ""
        }
        var newString = ""
        for (index,char) in characters.enumerated() {
            switch index {
            case 5:
                newString.append("-")
                newString.append(char)
                break
            default: newString.append(char)
            }
        }
        return newString
    }
    
    
    // Card ID Mask
    func withMaskCardID() -> String {
        // Cast itself to array of characters and add separators
        let characters = Array(self.numbersOnly())
        var newString = ""
        for (index,char) in characters.enumerated() {
            switch index {
            case 2:
                newString.append(".")
                newString.append(char)
                break
            case 9:
                newString.append("-")
                newString.append(char)
                break
            default: newString.append(char)
            }
        }
        return newString
    }
    
    
    // Phone Mask
    func withMaskPhone() -> String {
        // Cast itself to array of characters and add separators
        let characters = Array(self.numbersOnly())
        if characters.count == 0 {
            return ""
        }
        var newString = ""
        let hyphenIndex = (characters.count > 10) ? 7 : 6
        for (index,char) in characters.enumerated() {
            switch index {
            case 0:
                newString.append("(")
                newString.append(char)
                break
            case 2:
                newString.append(") ")
                newString.append(char)
                break
            case hyphenIndex:
                newString.append("-")
                newString.append(char)
                break
            default: newString.append(char)
            }
        }
        return newString
    }
}








