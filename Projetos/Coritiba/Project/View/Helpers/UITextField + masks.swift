//
//  UITextField + maskCPF.swift
//  
//
//  Created by Roberto Oliveira on 08/06/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit


extension UITextField {
    
    // MARK: - CPF Mask
    func applyMaskToCPF(range: NSRange, string: String) -> Bool {
        if let text = self.text {
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            if newString.containOnlyCPFCharacters() == false {
                return false
            } else {
                self.text = newString.withMaskCPF()
                return false
            }
        }
        return false
    }
    
    // MARK: - Phone Mask
    func applyMaskToPhone(range: NSRange, string: String) -> Bool {
        if let text = self.text {
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            if newString.containOnlyPhoneCharacters() == false {
                return false
            } else {
                self.text = newString.withMaskPhone()
                return false
            }
        }
        return false
    }
    
    // MARK: - ZipCode Mask
    func applyMaskToZipCode(range: NSRange, string: String) -> Bool {
        if let text = self.text {
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            if newString.containOnlyZipCodeCharacters() == false {
                return false
            } else {
                self.text = newString.withMaskZipCode()
                return false
            }
        }
        return false
    }
    
    
    
}


// EXAMPLE OF USE:
/*
extension YourViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.txfCPF) {
            return textField.applyMaskToCPF(range: range, string: string) // CPF MASK
        }
        return true
    }
}
 */








