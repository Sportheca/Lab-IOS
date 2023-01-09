//
//  AudioLibraryPlayerContentView.swift
//  
//
//  Created by Roberto Oliveira on 3/25/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class AudioLibraryPlayerContentView: UIView {
    
    static let notification_flipCover = "AudioLibraryPlayerContentView_notification_flipCover"
    
    // MARK: - Properties
    private var currentItem:AudioLibraryGroupItem?
    
    // MARK: - Objects
    private let ivCover0:ServerImageView = {
        let iv = ServerImageView()
        iv.isPlaceholderTintColorEnabled = true
        iv.backgroundColor = Theme.color(.PrimaryCardBackground)
        iv.tintColor = Theme.color(Theme.Color.PrimaryCardElements)
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0.15
        iv.clipsToBounds = true
        return iv
    }()
    private let cover1Container:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 25.0
        return vw
    }()
    private let ivCover1:ServerImageView = {
        let iv = ServerImageView()
        iv.isPlaceholderTintColorEnabled = true
        iv.backgroundColor = Theme.color(.PrimaryCardBackground)
        iv.tintColor = Theme.color(Theme.Color.PrimaryCardElements)
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private let textView:UITextView = {
        let txv = UITextView()
        txv.backgroundColor = UIColor.clear
        txv.textAlignment = .center
        txv.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 12)
        txv.textColor = Theme.color(.PrimaryCardElements)
        txv.isEditable = false
        return txv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 3
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 16)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let controllersContainer:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let controllersView:AudioLibraryLargePlayerControllersView = AudioLibraryLargePlayerControllersView()
    
    
    
    
    // MARK: - Methods
    @objc func updateContent() {
        guard let item = AudioLibraryManager.shared.currentItem else {return}
        guard item.id != self.currentItem?.id else {return}
        self.currentItem = item
        self.lblTitle.text = item.title
        self.ivCover0.setServerImage(urlString: item.imageUrl, placeholderImageName: "audio_group_cover")
        self.ivCover1.setServerImage(urlString: item.imageUrl, placeholderImageName: "audio_group_cover")
    }
    
    @objc func flipNotification(_ notification:Notification) {
        guard let item = AudioLibraryManager.shared.currentItem else {return}
        DispatchQueue.main.async {
            if self.textView.isHidden {
                self.textView.text = AudioLibraryManager.shared.lyricsDataSource[item.id] ?? ""
            }
            UIView.transition(with: self.cover1Container, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.ivCover1.isHidden = !self.ivCover1.isHidden
                self.textView.isHidden = !self.textView.isHidden
            }, completion: nil)
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(self.flipNotification(_:)), name: NSNotification.Name(AudioLibraryPlayerContentView.notification_flipCover), object: nil)
        // Cover 0
        self.addSubview(self.ivCover0)
        self.addBoundsConstraintsTo(subView: self.ivCover0, leading: 0, trailing: 0, top: 0, bottom: nil)
        // Cover 1
        self.addSubview(self.cover1Container)
        self.addTopAlignmentConstraintTo(subView: self.cover1Container, constant: 35)
        self.addCenterXAlignmentConstraintTo(subView: self.cover1Container, constant: 0)
        if UIScreen.main.bounds.height >= 700 {
            self.cover1Container.addWidthConstraint(255)
            self.cover1Container.addHeightConstraint(255)
        } else if UIScreen.main.bounds.height >= 667 {
            self.cover1Container.addWidthConstraint(230)
            self.cover1Container.addHeightConstraint(230)
        } else {
            self.cover1Container.addWidthConstraint(150)
            self.cover1Container.addHeightConstraint(150)
        }
        self.cover1Container.addSubview(self.ivCover1)
        self.cover1Container.addFullBoundsConstraintsTo(subView: self.ivCover1, constant: 0)
        self.cover1Container.addSubview(self.textView)
        self.cover1Container.addBoundsConstraintsTo(subView: self.textView, leading: 8, trailing: -8, top: 0, bottom: 0)
        self.textView.isHidden = true
        // Title
        self.addSubview(self.lblTitle)
        self.lblTitle.addHeightConstraint(70)
        self.addVerticalSpacingTo(subView1: self.ivCover1, subView2: self.lblTitle, constant: 5)
        self.addBottomAlignmentRelatedConstraintTo(subView: self.lblTitle, reference: self.ivCover0, constant: -10)
        self.addCenterXAlignmentConstraintTo(subView: self.lblTitle, constant: 0)
        self.addWidthRelatedConstraintTo(subView: self.lblTitle, reference: self.ivCover0, relatedBy: .equal, multiplier: 1.0, constant: -20, priority: 999)
        // Container
        self.addSubview(self.controllersContainer)
        self.addVerticalSpacingTo(subView1: self.ivCover0, subView2: self.controllersContainer, constant: 10)
        self.addBoundsConstraintsTo(subView: self.controllersContainer, leading: 0, trailing: 0, top: nil, bottom: -10)
        // Controllers
        self.controllersContainer.addSubview(self.controllersView)
        self.controllersContainer.addCenterXAlignmentConstraintTo(subView: self.controllersView, constant: 0)
        self.controllersContainer.addCenterYAlignmentConstraintTo(subView: self.controllersView, constant: 0)
        self.controllersView.addWidthConstraint(constant: 375, relatedBy: .lessThanOrEqual, priority: 999)
        self.controllersView.addHeightConstraint(constant: 250, relatedBy: .lessThanOrEqual, priority: 999)
        self.controllersContainer.addLeadingAlignmentConstraintTo(subView: self.controllersView, relatedBy: .equal, constant: 0, priority: 750)
        self.controllersContainer.addTrailingAlignmentConstraintTo(subView: self.controllersView, relatedBy: .equal, constant: 0, priority: 750)
        self.controllersContainer.addTopAlignmentConstraintTo(subView: self.controllersView, relatedBy: .equal, constant: 0, priority: 750)
        self.controllersContainer.addBottomAlignmentConstraintTo(subView: self.controllersView, relatedBy: .equal, constant: 0, priority: 750)
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] (_)  in
            self?.updateContent()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
