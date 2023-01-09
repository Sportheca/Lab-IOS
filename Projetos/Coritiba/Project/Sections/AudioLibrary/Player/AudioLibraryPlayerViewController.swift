//
//  AudioLibraryPlayerViewController.swift
//  
//
//  Created by Roberto Oliveira on 3/25/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class AudioLibraryPlayerViewController: BaseViewController {
    
    // MARK: - Properties
    var trackEvent:Int?
    
    
    
    
    // MARK: - Objects
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.closeAction), for: .touchUpInside)
        return btn
    }()
    private let contentContainerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let contentView:AudioLibraryPlayerContentView = AudioLibraryPlayerContentView()
    
    
    
    
    // MARK: - Methods
    @objc func closeAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibraryPlayer.close, trackValue: AudioLibraryManager.shared.currentItem?.id)
        DispatchQueue.main.async {
            if AudioLibraryPlayer.shared.isPlaying {
                AudioLibraryManager.shared.showFloatingButton()
            }
            self.dismissAction()
        }
    }
    
    
    
    
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AudioLibraryManager.shared.hideFloatingButton()
    }
    
    
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Navigation
        self.view.addSubview(self.btnClose)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 25)
        self.btnClose.addHeightConstraint(40)
        // Container
        self.view.addSubview(self.contentContainerView)
        self.view.addVerticalSpacingTo(subView1: self.btnClose, subView2: self.contentContainerView, constant: 5)
        self.view.addBoundsConstraintsTo(subView: self.contentContainerView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.contentContainerView, constant: 0)
        // Content
        self.contentContainerView.addSubview(self.contentView)
        self.contentContainerView.addFullBoundsConstraintsTo(subView: self.contentView, constant: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.statusBarStyle()
    }
    
}

