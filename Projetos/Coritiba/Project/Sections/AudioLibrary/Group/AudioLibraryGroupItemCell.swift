//
//  AudioLibraryGroupItemCell.swift
//  
//
//  Created by Roberto Oliveira on 3/23/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class AudioLibraryGroupItemCell: UICollectionViewCell {
    
    static let defaultHeight:CGFloat = 80.0
    
    // MARK: - Properties
    private var currentItem:AudioLibraryGroupItem?
    
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.layer.cornerRadius = 25.0
        return vw
    }()
     let separatorView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.MutedText)
        return vw
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.isPlaceholderTintColorEnabled = true
        iv.backgroundColor = Theme.color(.PrimaryCardBackground)
        iv.tintColor = Theme.color(Theme.Color.PrimaryCardElements)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10.0
        return iv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblDate:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 12)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    private let lblDescription:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 12)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(item:AudioLibraryGroupItem, roundTop:Bool, roundBottom:Bool) {
        self.currentItem = item
        self.ivCover.setServerImage(urlString: item.imageUrl, placeholderImageName: "audio_group_cover")
        self.lblTitle.text = item.title
        self.lblDate.text = item.date?.stringWith(format: "dd 'de' MMMM 'de' yyyy") ?? ""
        self.lblDescription.text = item.durationDescription
        
        // Corner radius
        var maskedCorners:CACornerMask = []
        if roundTop {
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if roundBottom {
            maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        self.backView.layer.maskedCorners = maskedCorners
    }
    
    
    @objc func downloadProgressUpdated(_ notification:Notification) {
        guard let info = notification.object as? AudioLibraryDownloadInfo, let item = self.currentItem else {return}
        guard info.id == item.id else {return}
        DispatchQueue.main.async {
            if info.progress >= 1.0 {
                self.lblDescription.text = item.durationDescription
            } else {
                let progress = Int(info.progress*100)
                self.lblDescription.text = "Baixando... (\(progress.description)%)"
            }
        }
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadProgressUpdated(_:)), name: NSNotification.Name(AudioLibraryDownloadManager.notification_downloadProgressUpdated), object: nil)
        // Back View
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: nil, trailing: nil, top: 0, bottom: 0)
        self.addCenterXAlignmentConstraintTo(subView: self.backView, constant: 0)
        self.backView.addWidthConstraint(constant: 450, relatedBy: .lessThanOrEqual, priority: 999)
        self.addLeadingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: 0, priority: 750)
        self.addTrailingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: 0, priority: 750)
        // Separator
        self.backView.addSubview(self.separatorView)
        self.separatorView.addHeightConstraint(1)
        self.backView.addBoundsConstraintsTo(subView: self.separatorView, leading: 20, trailing: -20, top: nil, bottom: 0)
        // Cover
        self.backView.addSubview(self.ivCover)
        self.backView.addCenterYAlignmentConstraintTo(subView: self.ivCover, constant: 0)
        self.backView.addLeadingAlignmentConstraintTo(subView: self.ivCover, constant: 15)
        self.ivCover.addHeightConstraint(50)
        self.ivCover.addWidthConstraint(50)
        // Title
        self.backView.addSubview(self.lblTitle)
        self.backView.addHorizontalSpacingTo(subView1: self.ivCover, subView2: self.lblTitle, constant: 10)
        self.backView.addTopAlignmentRelatedConstraintTo(subView: self.lblTitle, reference: self.ivCover, constant: 0)
        self.backView.addTrailingAlignmentConstraintTo(subView: self.lblTitle, constant: -15)
        self.lblTitle.addHeightConstraint(constant: 35, relatedBy: .greaterThanOrEqual, priority: 999)
        // Date
        self.backView.addSubview(self.lblDate)
        self.backView.addHorizontalSpacingTo(subView1: self.ivCover, subView2: self.lblDate, constant: 10)
        self.backView.addBottomAlignmentRelatedConstraintTo(subView: self.lblDate, reference: self.ivCover, constant: 0)
        // Description
        self.backView.addSubview(self.lblDescription)
        self.backView.addTrailingAlignmentConstraintTo(subView: self.lblDescription, constant: -15)
        self.backView.addBottomAlignmentRelatedConstraintTo(subView: self.lblDescription, reference: self.ivCover, constant: 0)
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


