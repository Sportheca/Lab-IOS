//
//  InstagramStoriesView.swift
//  
//
//  Created by Roberto Oliveira on 04/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class InstagramStoriesView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    var currentMode:Int?
    var dataSource:[InstagramStoriesItem] = []
    var expandItemTrackEvent:Int?
    
    
    // MARK: - Objects
    let loadingView:ContentLoadingView = ContentLoadingView()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Stories".uppercased()
        return lbl
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(InstagramStoriesItemCell.self, forCellWithReuseIdentifier: "InstagramStoriesItemCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    
    // MARK: - Methods
    func updateContent(items:[InstagramStoriesItem]) {
        self.dataSource.removeAll()
        self.dataSource = items
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func loadContent(mode: InstagramStoriesPosition, trackEvent:Int? = nil) { // 5 = Twitter Home
        self.currentMode = mode.rawValue
        DispatchQueue.main.async {
            self.dataSource.removeAll()
            self.collectionView.reloadData()
            self.loadingView.startAnimating()
        }
        ServerManager.shared.getInstagramStories(trackEvent: trackEvent, mode: mode.rawValue) { (items:[InstagramStoriesItem]?) in
            DispatchQueue.main.async {
                self.dataSource = items ?? []
                self.collectionView.reloadData()
                self.isHidden = self.dataSource.isEmpty
                if self.dataSource.isEmpty {
                    self.loadingView.emptyResults()
                } else {
                    self.loadingView.stopAnimating()
                }
            }
        }
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstagramStoriesItemCell", for: indexPath) as! InstagramStoriesItemCell
        cell.updateContent(item: self.dataSource[indexPath.item], expandItemTrackEvent: expandItemTrackEvent)
        return cell
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 20, trailing: -20, top: 12, bottom: nil)
        self.addSubview(self.collectionView)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.collectionView, constant: 5)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: -15)
        self.collectionView.addHeightConstraint(280)
        // Loading
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.loadingView, reference: self.collectionView, constant: 0)
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






import AVKit
class InstagramStoriesItemCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var currentItem:InstagramStoriesItem?
    private var expandItemTrackEvent:Int?
    
    // MARK: - Objects
    let ivCover:FullScreenImageView = {
        let iv = FullScreenImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20.0
        iv.backgroundColor = Theme.color(.PrimaryCardBackground)
        return iv
    }()
    private let ivIcon:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        iv.tintColor = UIColor.white
        iv.layer.shadowOpacity = 0.3
        iv.layer.shadowRadius = 2.0
        iv.layer.shadowOffset = CGSize(width: 0, height: 0)
        return iv
    }()
    private lazy var btnVideo:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(self.playVideo), for: .touchUpInside)
        return btn
    }()
    
    
    
    // MARK: - Methods
    func updateContent(item:InstagramStoriesItem, expandItemTrackEvent: Int?) {
        self.expandItemTrackEvent = expandItemTrackEvent
        self.currentItem = item
        self.ivCover.setServerImage(urlString: item.coverUrlString)
        self.ivCover.trackValue = item.id
        self.ivCover.trackEvent = expandItemTrackEvent
        let videoUrlString = item.videoUrlString?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.btnVideo.isHidden = videoUrlString == ""
        let iconName = videoUrlString == "" ? "icon_stories_image" : "icon_stories_video"
        self.ivIcon.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
    }
    
    @objc func playVideo() {
        DispatchQueue.main.async {
            let videoUrlString = self.currentItem?.videoUrlString?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard let url = URL(string: videoUrlString) else {return}
            ServerManager.shared.setTrack(trackEvent: self.expandItemTrackEvent, trackValue: self.currentItem?.id)
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            UIApplication.topViewController()?.present(playerViewController, animated: true) {
              player.play()
            }
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.ivCover)
        self.addFullBoundsConstraintsTo(subView: self.ivCover, constant: 0)
        self.addSubview(self.ivIcon)
        self.addBoundsConstraintsTo(subView: self.ivIcon, leading: nil, trailing: -10, top: 10, bottom: nil)
        self.ivIcon.addHeightConstraint(25)
        self.ivIcon.addWidthConstraint(25)
        self.addSubview(self.btnVideo)
        self.addFullBoundsConstraintsTo(subView: self.btnVideo, constant: 0)
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

