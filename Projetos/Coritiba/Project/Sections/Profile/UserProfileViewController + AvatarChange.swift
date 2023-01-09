//
//  UserProfileViewController + AvatarChange.swift
//  
//
//  Created by Roberto Oliveira on 11/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func chooseAvatarImage() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Profile.changeAvatar, trackValue: nil)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) && UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            // camera or library
            let mediaAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
                if let currentPopoverpresentioncontroller = mediaAlert.popoverPresentationController{
                    currentPopoverpresentioncontroller.sourceView = self.view//self.navigationItem.titleView
                    currentPopoverpresentioncontroller.sourceRect = self.navigationItem.titleView?.bounds ?? CGRect.zero
                    currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                }
            }
            
            let camera = UIAlertAction(title: "Câmera", style: .default, handler: { (action:UIAlertAction) in
                ServerManager.shared.setTrack(trackEvent: EventTrack.Profile.avatarFromCamera, trackValue: nil)
                DispatchQueue.main.async {
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            let library = UIAlertAction(title: "Biblioteca", style: .default, handler: { (action:UIAlertAction) in
                ServerManager.shared.setTrack(trackEvent: EventTrack.Profile.avatarFromLibrary, trackValue: nil)
                DispatchQueue.main.async {
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            let cancel = UIAlertAction(title: "Cancelar", style: .destructive) { (_) in
                ServerManager.shared.setTrack(trackEvent: EventTrack.Profile.avatarCancel, trackValue: nil)
            }
            
            mediaAlert.addAction(camera)
            mediaAlert.addAction(library)
            mediaAlert.addAction(cancel)
            
            
            
            DispatchQueue.main.async {
                self.present(mediaAlert, animated: true, completion: nil)
            }
            
        } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            // library only
            imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            DispatchQueue.main.async {
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let new = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
            ServerManager.shared.userImage = new?.fixOrientation()
            self.headerView.updateContent()
        }
        if let img = new {
            let fixedImage = img.fixOrientation()
            ServerManager.shared.updateAvatar(image: fixedImage, completion: { (success:Bool?) in
                DispatchQueue.main.async {
                    if success != true {
                        ServerManager.shared.userImage = nil
                        self.basicAlert(message: "Falha ao conectar com o Servidor", handler: nil)
                    }
                    self.headerView.updateContent()
                }
            })
        }
    }
}




// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
