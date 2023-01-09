//
//  AudioLibraryGroupCoverCell.swift
//  
//
//  Created by Roberto Oliveira on 3/23/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol AudioLibraryGroupCoverCellDelegate:AnyObject {
    func audioLibraryGroupCoverCell(audioLibraryGroupCoverCell:AudioLibraryGroupCoverCell, didSelectItem item:AudioLibraryGroupItem)
}

class AudioLibraryGroupCoverCell: UICollectionViewCell {
    
    static let defaultHeight:CGFloat = 400.0
    
    // MARK: - Properties
    weak var delegate:AudioLibraryGroupCoverCellDelegate?
    private var currentItem:AudioLibraryGroupItem?
    
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.isPlaceholderTintColorEnabled = true
        iv.backgroundColor = Theme.color(.PrimaryCardBackground)
        iv.tintColor = Theme.color(Theme.Color.PrimaryCardElements)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25.0
        return iv
    }()
    private let coverShadowView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.black
        vw.layer.shadowRadius = 30.0
        vw.layer.shadowColor = UIColor.white.cgColor
        vw.layer.shadowOpacity = 0.3
        vw.layer.cornerRadius = 25.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 3
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 16)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private lazy var btnPlay:IconButton = {
        let btn = IconButton()
        btn.updateContent(icon: UIImage(named: "icon_play")?.withRenderingMode(.alwaysTemplate), title: "OUÇA AGORA")
        btn.ivIcon.tintColor = Theme.color(.PrimaryButtonText)
        btn.lblTitle.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.lblTitle.textColor = Theme.color(.PrimaryButtonText)
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.layer.cornerRadius = 10.0
        btn.layer.shadowRadius = 25.0
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowOpacity = 0.16
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    // MARK: - Methods
    @objc func confirm() {
        guard let item = self.currentItem else {return}
        self.delegate?.audioLibraryGroupCoverCell(audioLibraryGroupCoverCell: self, didSelectItem: item)
    }
    
    
    func updateContent(item:AudioLibraryGroupItem) {
        self.currentItem = item
        self.lblTitle.text = item.title
        self.ivCover.setServerImage(urlString: item.imageUrl, placeholderImageName: "audio_group_cover")
    }
    
    @objc func downloadProgressUpdated(_ notification:Notification) {
        guard let info = notification.object as? AudioLibraryDownloadInfo, let item = self.currentItem else {return}
        guard info.id == item.id else {return}
        DispatchQueue.main.async {
            if info.progress >= 1.0 {
                self.btnPlay.updateContent(icon: UIImage(named: "icon_play")?.withRenderingMode(.alwaysTemplate), title: "OUÇA AGORA")
            } else {
                let progress = Int(info.progress*100)
                self.btnPlay.updateContent(icon: UIImage(named: "icon_play")?.withRenderingMode(.alwaysTemplate), title: "Baixando... (\(progress.description)%)")
            }
        }
    }
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadProgressUpdated(_:)), name: NSNotification.Name(AudioLibraryDownloadManager.notification_downloadProgressUpdated), object: nil)
        // Back View
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: nil, trailing: nil, top: 0, bottom: -20)
        self.addCenterXAlignmentConstraintTo(subView: self.backView, constant: 0)
        self.backView.addWidthConstraint(constant: 450, relatedBy: .lessThanOrEqual, priority: 999)
        self.addLeadingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: 20, priority: 750)
        self.addTrailingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: -20, priority: 750)
        // Cover
        self.backView.addSubview(self.ivCover)
        self.ivCover.addWidthConstraint(255)
        self.ivCover.addHeightConstraint(255)
        self.backView.addCenterXAlignmentConstraintTo(subView: self.ivCover, constant: 0)
        self.backView.addTopAlignmentConstraintTo(subView: self.ivCover, constant: 0)
        // Cover Shadow
        self.backView.insertSubview(self.coverShadowView, belowSubview: self.ivCover)
        self.backView.addCenterXAlignmentRelatedConstraintTo(subView: self.coverShadowView, reference: self.ivCover, constant: 0)
        self.backView.addBottomAlignmentRelatedConstraintTo(subView: self.coverShadowView, reference: self.ivCover, constant: -5)
        self.backView.addWidthRelatedConstraintTo(subView: self.coverShadowView, reference: self.ivCover, relatedBy: .equal, multiplier: 1.0, constant: -40, priority: 999)
        self.coverShadowView.addHeightConstraint(100)
        // Title
        self.backView.addSubview(self.lblTitle)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.backView.addVerticalSpacingTo(subView1: self.ivCover, subView2: self.lblTitle, constant: 8)
        self.lblTitle.addHeightConstraint(70)
        // Play
        self.backView.addSubview(self.btnPlay)
        self.backView.addCenterXAlignmentConstraintTo(subView: self.btnPlay, constant: 0)
        self.btnPlay.addHeightConstraint(40)
        self.backView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.btnPlay, constant: 5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}


