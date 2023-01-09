//
//  HomeCTABannerView.swift
//
//
//  Created by Roberto Oliveira on 07/04/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class HomeCTABannerItem {
    
    enum Mode:Int {
        case Default = 1
        case Animated = 2
    }
    
    var id:Int
    var color:UIColor
    //    var imageUrl:String?
    var mode:HomeCTABannerItem.Mode
    
    var imagesUrlString:[String]
    var sideMenuIconUrlString:String?
    var sideMenuTitle:String?
    var urlString:String
    var isEmbed:WebContentPresentationMode
    var deeplink:PushNotification?
    var fixedRatio:CGFloat?
    var shouldAdaptRatio:Bool = false
    
    init(id:Int, color:UIColor, mode:HomeCTABannerItem.Mode, imagesUrlString:[String], sideMenuIconUrlString:String?, sideMenuTitle:String?, urlString:String, isEmbed:WebContentPresentationMode, deeplink:PushNotification?, fixedRatio:CGFloat?, shouldAdaptRatio:Bool = false) {
        self.id = id
        self.color = color
        self.mode = mode
        self.imagesUrlString = imagesUrlString
        self.sideMenuIconUrlString = sideMenuIconUrlString
        self.sideMenuTitle = sideMenuTitle
        self.urlString = urlString
        self.isEmbed = isEmbed
        self.deeplink = deeplink
        self.fixedRatio = fixedRatio
        self.shouldAdaptRatio = shouldAdaptRatio
    }
}

protocol HomeCTABannerViewDelegate:AnyObject {
    func homeCTABannerView(homeCTABannerView:HomeCTABannerView, didSelectItem item:HomeCTABannerItem)
}

class HomeCTABannerView: UIView {
    
    enum AnimationTypes {
        case SwipeLeft
        case SwipeRight
        case SwipeUp
        case SwipeDown
    }
    
    // MARK: - Properties
    weak var delegate:HomeCTABannerViewDelegate?
    var currentItem:HomeCTABannerItem?
    private var currentIndex:Int = 0
    private let animations:[AnimationTypes] = [.SwipeLeft, .SwipeUp, .SwipeRight, .SwipeDown]
    private var animationIndex:Int = 0
    private let delay:TimeInterval = 2.5
    private var timer:Timer?
    
    // MARK: - Objects
    let loadingView:ContentLoadingView = ContentLoadingView()
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        vw.clipsToBounds = true
        return vw
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = UIColor.clear
        btn.highlightedScale = 1.0
        btn.highlightedAlpha = 0.8
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    @objc func confirm() {
        guard let item = self.currentItem else {return}
        self.delegate?.homeCTABannerView(homeCTABannerView: self, didSelectItem: item)
    }
    
    
    
    // MARK: - Methods
    func updateContent(item:HomeCTABannerItem?) {
        self.backView.backgroundColor = UIColor.clear
        guard let object = item else {
            self.ivCover.alpha = 0.0
            return
        }
        self.currentIndex = 0
        self.animationIndex = 0
        
        self.currentItem = object
        self.backView.backgroundColor = object.color
        self.ivCover.setServerImage(urlString: object.imagesUrlString.first)
        self.ivCover.alpha = 1.0
        
        if object.mode == .Animated {
            self.timer?.invalidate()
            self.timer = nil
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.animate), userInfo: nil, repeats: true)
            guard let t = self.timer else {return}
            RunLoop.main.add(t, forMode: .common)
        }
        
        if let ratio = item?.fixedRatio {
            self.ivCover.removeFromSuperview()
            self.backView.addSubview(self.ivCover)
            self.backView.addFullBoundsConstraintsTo(subView: self.ivCover, constant: 0)
            self.ivCover.backgroundColor = UIColor.clear
            let height = UIScreen.main.bounds.width * ratio
            self.fixedHeightConstraints.constant = height
            self.fixedHeightConstraints.isActive = true
        } else {
            if item?.shouldAdaptRatio == true {
                self.adaptRatio()
            }
        }
    }
    
    private func adaptRatio() {
//        guard let item = self.currentItem else {return}
//        let imgUrl = item.imagesUrlString.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        guard imgUrl != "" else {return}
//        ServerManager.shared.downloadImage(urlSufix: imgUrl) { (img:UIImage?) in
//            DispatchQueue.main.async {
//                var ratio:CGFloat = 0.0
//                if let i = img {
////                    ratio = i.size.height / i.size.width
////                    guard let vc = (UIApplication.shared.delegate as? AppDelegate)?.tabController?.tabVc0 else {return}
////                    vc.contentView.tableView.beginUpdates()
////                    self.ivCover.removeFromSuperview()
////                    self.backView.addSubview(self.ivCover)
////                    self.backView.addFullBoundsConstraintsTo(subView: self.ivCover, constant: 0)
////                    self.ivCover.backgroundColor = UIColor.clear
////                    let height = UIScreen.main.bounds.width * ratio
////                    self.fixedHeightConstraints.constant = height
////                    self.fixedHeightConstraints.isActive = true
////                    vc.contentView.tableView.endUpdates()
////                    vc.contentView.tableView.reloadRows(at: vc.contentView.tableView.indexPathsForVisibleRows ?? [], with: .automatic)
//                }
//            }
//        }
    }
    
    @objc func animate() {
        guard let item = self.currentItem else {return}
        
        // get current image and increase to next
        self.currentIndex = (self.currentIndex >= item.imagesUrlString.count-1) ? 0 : self.currentIndex+1
        let img = item.imagesUrlString[self.currentIndex]
        
        // get current animation time and increase to next
        let animation = self.animations[self.animationIndex]
        self.animationIndex = (self.animationIndex >= self.animations.count-1) ? 0 : self.animationIndex+1
        
        let duration:TimeInterval = 0.6
        switch animation {
        case .SwipeLeft:
            let x = (self.bounds.width/2) + (self.ivCover.frame.width/2)
            UIView.animate(withDuration: duration/2, delay: 0.0, options: [.curveEaseIn], animations: {
                self.ivCover.transform = CGAffineTransform(translationX: -x, y: 0)
            }) { (completed:Bool) in
                self.ivCover.transform = CGAffineTransform(translationX: x, y: 0)
                self.ivCover.setServerImage(urlString: img)
                
                UIView.animate(withDuration: duration/2, delay: 0.0, options: [.curveEaseOut], animations: {
                    self.ivCover.transform = CGAffineTransform.identity
                }) { (completed:Bool) in
                    //
                }
            }
            break
        
        case .SwipeRight:
            let x = (self.bounds.width/2) + (self.ivCover.frame.width/2)
            UIView.animate(withDuration: duration/2, delay: 0.0, options: [.curveEaseIn], animations: {
                self.ivCover.transform = CGAffineTransform(translationX: x, y: 0)
            }) { (completed:Bool) in
                self.ivCover.transform = CGAffineTransform(translationX: -x, y: 0)
                self.ivCover.setServerImage(urlString: img)
                
                UIView.animate(withDuration: duration/2, delay: 0.0, options: [.curveEaseOut], animations: {
                    self.ivCover.transform = CGAffineTransform.identity
                }) { (completed:Bool) in
                    //
                }
            }
            break
            
        case .SwipeUp:
            let y = (self.bounds.height/2) + (self.ivCover.frame.height/2)
            UIView.animate(withDuration: duration/2, delay: 0.0, options: [.curveEaseIn], animations: {
                self.ivCover.transform = CGAffineTransform(translationX: 0, y: -y)
            }) { (completed:Bool) in
                self.ivCover.transform = CGAffineTransform(translationX: 0, y: y)
                self.ivCover.setServerImage(urlString: img)
                
                UIView.animate(withDuration: duration/3, delay: 0.0, options: [.curveEaseOut], animations: {
                    self.ivCover.transform = CGAffineTransform.identity
                }) { (completed:Bool) in
                    //
                }
            }
            break
            
        case .SwipeDown:
            let y = (self.bounds.height/2) + (self.ivCover.frame.height/2)
            UIView.animate(withDuration: duration/2, delay: 0.0, options: [.curveEaseIn], animations: {
                self.ivCover.transform = CGAffineTransform(translationX: 0, y: y)
            }) { (completed:Bool) in
                self.ivCover.transform = CGAffineTransform(translationX: 0, y: -y)
                self.ivCover.setServerImage(urlString: img)
                
                UIView.animate(withDuration: duration/3, delay: 0.0, options: [.curveEaseOut], animations: {
                    self.ivCover.transform = CGAffineTransform.identity
                }) { (completed:Bool) in
                    //
                }
            }
            break
        }
        
        
    }
    
    
    private var ratioConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private var fixedHeightConstraints:NSLayoutConstraint = NSLayoutConstraint()
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Button
        self.addSubview(self.btnConfirm)
        self.addFullBoundsConstraintsTo(subView: self.btnConfirm, constant: 0)
        // Content
        self.btnConfirm.addSubview(self.backView)
        self.backView.isUserInteractionEnabled = false
        self.addBoundsConstraintsTo(subView: self.backView, leading: 0, trailing: 0, top: 10, bottom: -10)
        self.ratioConstraint = NSLayoutConstraint(item: self.backView, attribute: .height, relatedBy: .equal, toItem: self.backView, attribute: .width, multiplier: 0.25, constant: 0)
        self.ratioConstraint.priority = UILayoutPriority(750)
        self.addConstraint(self.ratioConstraint)
        self.fixedHeightConstraints = NSLayoutConstraint(item: self.backView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        self.fixedHeightConstraints.priority = UILayoutPriority(999)
        self.fixedHeightConstraints.isActive = false
        self.addConstraint(self.fixedHeightConstraints)
//        self.backView.addHeightConstraint(constant: 150, relatedBy: .lessThanOrEqual, priority: 999)
        // Cover
        self.backView.addSubview(self.ivCover)
        self.backView.addBoundsConstraintsTo(subView: self.ivCover, leading: nil, trailing: nil, top: 0, bottom: 0)
        self.backView.addCenterXAlignmentConstraintTo(subView: self.ivCover, constant: 0)
        self.backView.addLeadingAlignmentConstraintTo(subView: self.ivCover, relatedBy: .equal, constant: 20, priority: 750)
        self.backView.addTrailingAlignmentConstraintTo(subView: self.ivCover, relatedBy: .equal, constant: -20, priority: 750)
        self.ivCover.addWidthConstraint(constant: 500, relatedBy: .lessThanOrEqual, priority: 999)
        // Loading
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.loadingView, reference: self.backView, constant: 0)
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





