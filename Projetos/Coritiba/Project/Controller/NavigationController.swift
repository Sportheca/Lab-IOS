//
//  NavigationController.swift
//
//
//  Created by Roberto Oliveira on 14/10/19.
//  Copyright © 2019 Roberto Oliveira. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    var isDarkStatusBarStyle:Bool?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let value = self.isDarkStatusBarStyle else {
            return Theme.statusBarStyle()
        }
        if value {
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        } else {
            return .lightContent
        }
    }
    
}
