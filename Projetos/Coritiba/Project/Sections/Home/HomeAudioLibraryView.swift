//
//  HomeAudioLibraryView.swift
//  
//
//  Created by Roberto Oliveira on 3/26/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

struct HomeAudioLibraryItem {
    var id:Int
    var imageUrl:String?
    var title:String
    var urlString:String?
}

protocol HomeAudioLibraryViewDelegate:AnyObject {
    func homeAudioLibraryView(homeAudioLibraryView:HomeAudioLibraryView, didSelectItem item:HomeAudioLibraryItem)
}

class HomeAudioLibraryView: UIView {
    
    // MARK: - Properties
    var currentItem:HomeAudioLibraryItem?
    weak var delegate:HomeAudioLibraryViewDelegate?
    
    
    // MARK: - Objects
    private let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "PODCAST".uppercased()
        return lbl
    }()
    let loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.color = Theme.color(.PrimaryCardElements)
        return vw
    }()
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        return vw
    }()
    private let lblTop:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 14)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.text = "Último Lançamento"
        return lbl
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.isPlaceholderTintColorEnabled = true
        iv.backgroundColor = Theme.color(.PrimaryCardBackground)
        iv.tintColor = Theme.color(Theme.Color.PrimaryCardElements)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    private let coverShadowView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.layer.shadowRadius = 30.0
        vw.layer.shadowColor = Theme.color(.PrimaryCardElements).cgColor
        vw.layer.shadowOpacity = 0.3
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 14)
//        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private lazy var btnPlay:IconButton = {
        let btn = IconButton()
        btn.updateContent(icon: UIImage(named: "icon_play")?.withRenderingMode(.alwaysTemplate), title: "OUÇA AGORA")
        btn.lblTitle.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 19)
        btn.lblTitle.adjustsFontSizeToFitWidth = true
        btn.lblTitle.textColor = Theme.color(.PrimaryButtonText)
        btn.ivIcon.tintColor = Theme.color(.PrimaryButtonText)
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.cornerRadius = 20.0
        btn.layer.shadowRadius = 25.0
        btn.layer.shadowColor = Theme.color(.PrimaryCardElements).cgColor
        btn.layer.shadowOpacity = 0.16
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    @objc func confirm() {
        guard let item = self.currentItem else {return}
        self.delegate?.homeAudioLibraryView(homeAudioLibraryView: self, didSelectItem: item)
    }
    
    
    
    // MARK: - Methods
    func updateContent(item:HomeAudioLibraryItem?) {
        guard let object = item else {
            self.lblTop.alpha = 0.0
            self.ivCover.alpha = 0.0
            self.coverShadowView.alpha = 0.0
            self.lblTitle.alpha = 0.0
            self.btnPlay.alpha = 0.0
            return
        }
        
        self.currentItem = object
        self.lblTitle.text = object.title
        self.ivCover.setServerImage(urlString: object.imageUrl, placeholderImageName: "audio_group_cover")
        
        self.lblTop.alpha = 1.0
        self.ivCover.alpha = 1.0
        self.coverShadowView.alpha = 1.0
        self.lblTitle.alpha = 1.0
        self.btnPlay.alpha = 1.0
    }
    
    @objc func downloadProgressUpdated(_ notification:Notification) {
        guard let info = notification.object as? AudioLibraryDownloadInfo, let item = self.currentItem else {return}
        guard info.id == item.id else {return}
        DispatchQueue.main.async {
            if info.progress >= 1.0 {
                self.btnPlay.updateContent(icon: UIImage(named: "icon_play"), title: "OUÇA AGORA")
            } else {
                let progress = Int(info.progress*100)
                self.btnPlay.updateContent(icon: UIImage(named: "icon_play"), title: "Baixando... (\(progress.description)%)")
            }
        }
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadProgressUpdated(_:)), name: NSNotification.Name(AudioLibraryDownloadManager.notification_downloadProgressUpdated), object: nil)
        // Title
        self.addSubview(self.lblHeader)
        self.lblHeader.addHeightConstraint(25)
        self.addBoundsConstraintsTo(subView: self.lblHeader, leading: 22, trailing: nil, top: 12, bottom: nil)
        self.lblHeader.setContentCompressionResistancePriority(UILayoutPriority(1000), for: NSLayoutConstraint.Axis.horizontal)
        // Content
        self.addSubview(self.backView)
        self.addVerticalSpacingTo(subView1: self.lblHeader, subView2: self.backView, constant: 5)
        self.addBoundsConstraintsTo(subView: self.backView, leading: 0, trailing: 0, top: nil, bottom: -10)
        // Loading
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.loadingView, reference: self.backView, constant: 0)
        // Cover
        self.backView.addSubview(self.ivCover)
        if UIScreen.main.bounds.width > 320 {
            self.ivCover.addWidthConstraint(200)
            self.ivCover.addHeightConstraint(217)
        } else {
            self.ivCover.addWidthConstraint(110)
            self.ivCover.addHeightConstraint(110)
        }
        self.backView.addBoundsConstraintsTo(subView: self.ivCover, leading: 0, trailing: nil, top: 0, bottom: 0)
        // Cover Shadow
//        self.backView.insertSubview(self.coverShadowView, belowSubview: self.ivCover)
//        self.backView.addCenterXAlignmentRelatedConstraintTo(subView: self.coverShadowView, reference: self.ivCover, constant: 0)
//        self.backView.addBottomAlignmentRelatedConstraintTo(subView: self.coverShadowView, reference: self.ivCover, constant: -5)
//        self.backView.addWidthRelatedConstraintTo(subView: self.coverShadowView, reference: self.ivCover, relatedBy: .equal, multiplier: 1.0, constant: -30, priority: 999)
//        self.coverShadowView.addHeightConstraint(60)
        // Top
        self.backView.addSubview(self.lblTop)
        self.lblTop.addHeightConstraint(constant: 30, relatedBy: .equal, priority: 999)
        self.backView.addBoundsConstraintsTo(subView: self.lblTop, leading: nil, trailing: -30, top: 20, bottom: nil)
        // Title
        self.backView.addSubview(self.lblTitle)
        self.backView.addVerticalSpacingTo(subView1: self.lblTop, subView2: self.lblTitle, constant: 20)
        self.backView.addTrailingAlignmentConstraintTo(subView: self.lblTitle, constant: -30)
        self.backView.addHorizontalSpacingTo(subView1: self.ivCover, subView2: self.lblTitle, constant: 30)
        // Play
        self.backView.addSubview(self.btnPlay)
        self.btnPlay.addHeightConstraint(40)
        self.backView.addHorizontalSpacingTo(subView1: self.ivCover, subView2: self.btnPlay, constant: 10)
        self.backView.addTrailingAlignmentConstraintTo(subView: self.btnPlay, constant: -10)
        self.backView.addBottomAlignmentRelatedConstraintTo(subView: self.btnPlay, reference: self.ivCover, constant: 0)
        self.backView.addBottomAlignmentConstraintTo(subView: self.btnPlay, constant: -30)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}




