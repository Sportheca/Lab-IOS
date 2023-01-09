//
//  CustomInputView.swift
//  Puratos
//
//  Created by Roberto Oliveira on 21/06/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

extension UITextField {
    // Optional delegate and auto resign for keyboard
    func addDefaultAccessory(delegate: DefaultInputAccessoryViewDelegate?, autoResign:Bool = false) {
        self.inputAccessoryView = DefaultInputAccessoryView(textField: self, delegate: delegate, autoResign: autoResign)
    }
    func addDefaultAccessory() {
        self.inputAccessoryView = DefaultInputAccessoryView(textField: self, delegate: nil, autoResign: true)
    }
}

extension UITextView {
    // Optional delegate and auto resign for keyboard
    func addDefaultAccessory(delegate: DefaultInputAccessoryViewDelegate? = nil, autoResign:Bool = true) {
        self.inputAccessoryView = DefaultInputAccessoryView(textView: self, delegate: delegate, autoResign: autoResign)
    }
}

extension UISearchBar {
    // Optional delegate and auto resign for keyboard
    func addDefaultAccessory() {
        self.inputAccessoryView = DefaultInputAccessoryView(searchBar: self)
    }
}


protocol DefaultInputAccessoryViewDelegate {
    func didSelectOk(textField: UITextField) // Optional delegate when button is tapped
    func didSelectOk(textField: UITextView) // Optional delegate when button is tapped
}


class DefaultInputAccessoryView: UIToolbar {
    
    // MARK: - Properties
    fileprivate var shouldAutoResign:Bool = false
    fileprivate var textField:UITextField?
    fileprivate var textView:UITextView?
    private var searchBar:UISearchBar?
    fileprivate var barDelegate:DefaultInputAccessoryViewDelegate?
    
    
    // MARK: - Methods
    // Button Methods
    @objc func okMethod() {
        if let txf = self.textField {
            self.barDelegate?.didSelectOk(textField: txf)
            if self.shouldAutoResign {
                self.textField?.resignFirstResponder()
            }
        }
        
        if let txv = self.textView {
            self.barDelegate?.didSelectOk(textField: txv)
            if self.shouldAutoResign {
                self.textView?.resignFirstResponder()
            }
        }
        
        if let sb = self.searchBar {
            sb.resignFirstResponder()
        }
    }
    
    // Set Up Methods
    fileprivate func prepareElements() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.45)
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 35)
        
        // OK Button
        let okBtn = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(self.okMethod))
        self.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),okBtn]
        
        if self.textField?.keyboardAppearance == .dark {
            self.barStyle = .blackTranslucent
        }
        
        if self.textView?.keyboardAppearance == .dark {
            self.barStyle = .blackTranslucent
        }
    }
    
    
    
    // MARK: - Init Methods
    init(textField: UITextField, delegate: DefaultInputAccessoryViewDelegate?, autoResign:Bool) {
        super.init(frame: CGRect.zero)
        self.shouldAutoResign = autoResign
        self.textField = textField
        self.barDelegate = delegate
        self.prepareElements()
    }
    
    init(textView: UITextView, delegate: DefaultInputAccessoryViewDelegate?, autoResign:Bool) {
        super.init(frame: CGRect.zero)
        self.shouldAutoResign = autoResign
        self.textView = textView
        self.barDelegate = delegate
        self.prepareElements()
    }
    
    init(searchBar: UISearchBar) {
        super.init(frame: CGRect.zero)
        self.shouldAutoResign = true
        self.searchBar = searchBar
        self.barDelegate = nil
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
}






