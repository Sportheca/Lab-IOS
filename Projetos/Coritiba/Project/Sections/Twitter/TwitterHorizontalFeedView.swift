//
//  TwitterTestView.swift
//
//
//  Created by Roberto Oliveira on 12/12/2017.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

enum TwitterFeedPosition:Int {
    case Home = 1
}

class TwitterHorizontalFeedView: UIView {
    
    // MARK: - Properties
    var showAllTweetsCell:Bool = true
    var expandTweetEventTrack:Int?
    var showAllTweetsEventTrack:Int?
    private var currentMode:Int = 0
    var dataSource:[TweetItem] = []
    private var animatedItems:[Bool] = []
    var searchString:String = ""
    
    
    
    // MARK: - Objects
    let loadingView:PulsingLoadingView = {
        let title = "Carregando Tweets..."
        let icon = UIImage(named: "tweet_bird")?.withRenderingMode(.alwaysTemplate)
        let vw = PulsingLoadingView(title: title, image: icon, animate: true)
        vw.lblTitle.textColor = Theme.color(.MutedText).withAlphaComponent(0.5)
        vw.ivLogo.tintColor = Theme.color(.MutedText).withAlphaComponent(0.8)
        return vw
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(TweetCollectionViewCell.self, forCellWithReuseIdentifier: "TweetCollectionViewCell")
        cv.register(AllTweetsCollectionViewCell.self, forCellWithReuseIdentifier: "AllTweetsCollectionViewCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Methods
    func updateContent(searchString: String) {
        self.searchString = searchString
        // Load Tweets
        ServerManager.shared.getTweets(search: searchString, limited: true) { (result:[TweetItem]?) in
            guard let objects = result else {return}
            self.dataSource.removeAll()
            self.dataSource = objects
            self.animatedItems.removeAll()
            self.animatedItems = Array.init(repeating: false, count: objects.count+1) // One more for last cell (see all tweets)
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
                if self.dataSource.count > 0 {
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.left, animated: false)
                }
            }
            
        }
    }
    
    func loadContent(mode: TwitterFeedPosition) { // 5 = Twitter Home
        self.currentMode = mode.rawValue
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.collectionView.isHidden = true
        }
//        ServerManager.shared.getUserHashtags(mode: mode.rawValue) { (hashtags:String?) in
//            if let words = hashtags {
//                if words != "", words != " " {
//                    self.updateContent(searchString: words)
//                    return
//                }
//            }
//        }
        self.updateContent(searchString: "")
    }
    
    
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Loading
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        // Collections
        self.addSubview(self.collectionView)
        self.collectionView.addHeightConstraint(360)
        self.addFullBoundsConstraintsTo(subView: self.collectionView, constant: 0)
    }
    
    
    // MARK: - Init Methods
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}




extension TwitterHorizontalFeedView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // didSelectItemAt
        if indexPath.item < self.dataSource.count {
            // Open tweet
            guard let cell = collectionView.cellForItem(at: indexPath) as? TweetCollectionViewCell else {return}
            let item = self.dataSource[indexPath.item]
            if let eventTrack = self.expandTweetEventTrack {
                ServerManager.shared.setTrack(trackEvent: eventTrack, trackValue: "\(item.authorAccount)@\(item.id)")
            }
            DispatchQueue.main.async {
                cell.tweetView.openFullScreen()
            }
        } else {
            // Open all tweets
            if let eventTrack = self.showAllTweetsEventTrack {
                ServerManager.shared.setTrack(trackEvent: eventTrack, trackValue: self.currentMode)
            }
            DispatchQueue.main.async {
                let vc = AllTweetsViewController()
                vc.searchString = self.searchString
                let topVc = UIApplication.topViewController()
                if let nav = topVc?.navigationController {
                    nav.pushViewController(vc, animated: true)
                } else {
                    vc.modalPresentationStyle = .fullScreen
                    topVc?.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: min(UIScreen.main.bounds.size.width-30, 345), height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 5, height: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
    
    // Animation
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.animatedItems[indexPath.item] == false {
            self.animatedItems[indexPath.item] = true
            cell.alpha = 0
            cell.frame.origin.x += 60
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
                    cell.alpha = 1
                    cell.frame.origin.x -= 60
                }, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.scaleTo(0.97)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.scaleTo(nil)
    }
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataSource.isEmpty {
            return 0
        }
        return (self.showAllTweetsCell) ? self.dataSource.count+1 : self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < self.dataSource.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCollectionViewCell", for: indexPath) as! TweetCollectionViewCell
            cell.tweetView.updateContent(tweet: self.dataSource[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllTweetsCollectionViewCell", for: indexPath) as! AllTweetsCollectionViewCell
            return cell
        }
    }
    
}




class TweetCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - Objects
    let tweetView:TweetView = TweetView()
    
    
    
    
    
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Container
        self.addSubview(self.tweetView)
        self.addFullBoundsConstraintsTo(subView: self.tweetView, constant: 0)
    }
    
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
}





class AllTweetsCollectionViewCell: UICollectionViewCell {
    // MARK: - Objects
    private let containerView:CustomGradientView = {
        let vw = CustomGradientView()
        vw.color1 = Theme.color(.PrimaryButtonBackground)
        vw.color2 = Theme.color(.PrimaryButtonBackground)
        vw.layer.cornerRadius = 5.0
        vw.clipsToBounds = true
        vw.layer.masksToBounds = true
        return vw
    }()
    private let ivLogo:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "tweet_bird")
        return iv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 3
        lbl.textAlignment = .right
        lbl.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.semibold)
        lbl.textColor = Theme.color(.PrimaryButtonText)
        lbl.text = "Ver\nMais\nTweets"
        return lbl
    }()
    
    
    // MARK: - Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.containerView)
        self.addFullBoundsConstraintsTo(subView: self.containerView, constant: 5)
        self.containerView.addSubview(self.ivLogo)
        self.containerView.addBoundsConstraintsTo(subView: self.ivLogo, leading: 20, trailing: nil, top: 20, bottom: nil)
        self.ivLogo.addHeightConstraint(100)
        self.ivLogo.addWidthConstraint(100)
        self.containerView.addSubview(self.lblTitle)
        self.containerView.addBoundsConstraintsTo(subView: self.lblTitle, leading: nil, trailing: -30, top: nil, bottom: -30)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.7
    }
    
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
}


