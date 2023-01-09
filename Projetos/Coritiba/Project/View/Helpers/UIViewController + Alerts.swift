//
//  UIViewController + Alerts.swift
//  
//
//  Created by Roberto Oliveira on 07/06/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // IMPORTANT!!  ----->     Don't forget to add CFBundleDisplayName for key in the info.plist with App Name as Value
    
    
    
    // App name as title
    func serverFailedAlert(handler: ((UIAlertAction) -> Void)?) {
        self.basicAlert(message: "Falha na conexão.\n\nTente novamente mais tarde", handler: handler)
    }
    
    func basicAlert(message:String, handler: ((UIAlertAction) -> Void)?) {
        self.basicAlert(message: message, btnTitle: "OK", handler: handler)
    }
    
    func basicAlert(message: String, btnTitle: String, handler: ((UIAlertAction) -> Void)?) {
        let title = ""
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: btnTitle, style: .default) { (action:UIAlertAction) in
            if handler != nil {
                handler!(action)
            }
        }
        alert.addAction(okAction)
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
            if let currentPopoverpresentioncontroller = alert.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = self.view
                currentPopoverpresentioncontroller.sourceRect = self.navigationItem.titleView?.bounds ?? CGRect.zero
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
            }
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    // Custom title
    func titleAlert(title:String, message:String, handler: ((UIAlertAction) -> Void)?) {
        self.titleAlert(title: title, message: message, btnTitle: "OK", handler: handler)
    }
    
    func titleAlert(title:String, message:String, btnTitle:String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: btnTitle, style: .default) { (action:UIAlertAction) in
            if handler != nil {
                handler!(action)
            }
        }
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    // Question alert
    func questionAlert(title:String, message:String, handler: @escaping ((_ answerYes:Bool) -> Void)) {
        let yesTitle = "Sim"
        let noTitle = "Não"
        self.questionAlert(title: title, message: message, btnConfirmTitle: yesTitle, btnCalcelTitle: noTitle, handler: handler)
    }
    
    func questionAlert(title:String, message:String, btnConfirmTitle:String, btnCalcelTitle:String, handler: @escaping ((_ answerYes:Bool) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: btnConfirmTitle, style: .default) { (action:UIAlertAction) in
            handler(true)
        }
        let noAction = UIAlertAction(title: btnCalcelTitle, style: .destructive) { (action:UIAlertAction) in
            handler(false)
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
    // TextField Alert
    func textfieldAlert(title:String, message:String, textfieldText:String?, placeholder:String?, keyboard:UIKeyboardType, handler: @escaping ((_ answerYes:Bool, _ alertText:String?) -> Void)) {
        let yesTitle = "Confirmar"
        let noTitle = "Cancelar"
        self.textfieldAlert(title: title, message: message, textfieldText: textfieldText, placeholder: placeholder, keyboard: keyboard, btnConfirmTitle: yesTitle, btnCalcelTitle: noTitle, handler: handler)
    }
    
    func textfieldAlert(title:String, message:String, textfieldText:String?, placeholder:String?, keyboard:UIKeyboardType, btnConfirmTitle:String, btnCalcelTitle:String, handler: @escaping ((_ answerYes:Bool, _ alertText:String?) -> Void)) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.textAlignment = .center
            textField.keyboardType = keyboard
            textField.text = textfieldText
            textField.placeholder = placeholder
        }
        
        let yesAction = UIAlertAction(title: btnConfirmTitle, style: .default) { (action:UIAlertAction) in
            handler(true, alert.textFields?.first?.text)
        }
        let noAction = UIAlertAction(title: btnCalcelTitle, style: .destructive) { (action:UIAlertAction) in
            handler(false, nil)
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    // Action Sheet Alert
    func actionAlert(title:String, items:[String], senderView:UIView, handler: @escaping ((_ itemTitle:String?, _ itemIndex:Int?) -> Void)) {
        let title = title
        let noTitle = "Cancelar"
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        for (index,itemTitle) in items.enumerated() {
            let action = UIAlertAction(title: itemTitle, style: .default, handler: { (action:UIAlertAction) in
                handler(itemTitle, index)
            })
            alert.addAction(action)
        }
        let noAction = UIAlertAction(title: noTitle, style: .destructive) { (action:UIAlertAction) in
            handler(nil, nil)
        }
        alert.addAction(noAction)
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
            if let currentPopoverpresentioncontroller = alert.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = senderView
                currentPopoverpresentioncontroller.sourceRect = senderView.bounds
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.any
            }
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    // Camera and PhotoLibrary
    func chooseMediaSourceAlert(sourceView:UIView, completion:@escaping (_ type:UIImagePickerController.SourceType?)->Void) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) && UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            // camera or library
            let mediaAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Câmera", style: .default, handler: { (action:UIAlertAction) in
                completion(UIImagePickerController.SourceType.camera)
            })
            let library = UIAlertAction(title: "Biblioteca", style: .default, handler: { (action:UIAlertAction) in
                completion(UIImagePickerController.SourceType.photoLibrary)
            })
            let cancel = UIAlertAction(title: "Cancelar", style: .destructive) { (_) in
                completion(nil)
            }
            
            mediaAlert.addAction(camera)
            mediaAlert.addAction(library)
            mediaAlert.addAction(cancel)
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
                if let currentPopoverpresentioncontroller = mediaAlert.popoverPresentationController{
                    currentPopoverpresentioncontroller.sourceView = sourceView
                    currentPopoverpresentioncontroller.sourceRect = sourceView.bounds
                    currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                }
            }
            
            DispatchQueue.main.async {
                self.present(mediaAlert, animated: true, completion: nil)
            }
            
        } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            completion(UIImagePickerController.SourceType.photoLibrary)
        }
    }
    
    
}
