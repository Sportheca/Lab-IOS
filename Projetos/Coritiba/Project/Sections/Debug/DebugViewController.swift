//
//  DebugViewController.swift
//
//
//  Created by Roberto Oliveira on 27/11/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class DebugViewController: BaseStackViewController {
    
    // MARK: - Properties
    
    
    
    
    // MARK: - Objects
    private let closeHeaderView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryBackground)
        return vw
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private let serverView:DebugServerView = DebugServerView()
    private let textsView:DebugTextsView = DebugTextsView()
    private let imagesView:DebugImagesView = DebugImagesView()
    private let colorsView:DebugColorsView = DebugColorsView()
    
    
    
    // MARK: - Methods
    @objc func close() {
        self.dismissAction()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vw = UIView()
        vw.backgroundColor = UIColor.yellow
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.scrollView.alwaysBounceVertical = true
        self.addStackSpaceView(height: 50)
        self.addFullWidthStackSubview(self.serverView)
        self.addFullWidthStackSubview(self.textsView)
        self.addFullWidthStackSubview(self.imagesView)
        self.addFullWidthStackSubview(self.colorsView)
        self.addStackSpaceView(height: 50)
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        // Header
        self.view.insertSubview(self.closeHeaderView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.closeHeaderView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.view.addBottomAlignmentRelatedConstraintTo(subView: self.closeHeaderView, reference: self.btnClose, constant: 10)
    }
    
}
