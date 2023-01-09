//
//  DebugManager.swift
//
//
//  Created by Roberto Oliveira on 27/11/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class DebugManager {
    
    static let isDebugModeEnabled:Bool = false
    
    
    private init() {}
    static let shared:DebugManager = DebugManager()
    
    // MARK: - Properties
    var isColorDebugEnabled:Bool = false
    var isColorFloatingInspectorEnabled:Bool = false
    var isImageDownloadForcedFail:Bool = false
    
    
    
    
    
    
    // MARK: - Colors Debuger
    var colorToBeDebugged:Theme.Color?
    var colorsDataSource:Set<Theme.Color> = []
    let colorsView:DebugCurrentColorsView = DebugCurrentColorsView()
    
    func showFloatingColors() {
        guard let window = UIApplication.shared.keyWindow else {return}
        self.colorsView.removeFromSuperview()
        window.addSubview(self.colorsView)
        let bottom = (UIApplication.shared.delegate as? AppDelegate)?.tabController?.tabBar.frame.height ?? 49.0
        window.addBottomAlignmentConstraintTo(subView: self.colorsView, constant: -bottom)
        window.addTrailingAlignmentConstraintTo(subView: self.colorsView, constant: 0)
        window.addLeadingAlignmentConstraintTo(subView: self.colorsView, constant: 0)
        self.colorsView.update()
    }
    
    func hideFloatingColors() {
        self.colorsView.removeFromSuperview()
    }
    
}

