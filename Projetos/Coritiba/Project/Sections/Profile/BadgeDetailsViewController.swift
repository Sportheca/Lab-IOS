//
//  BadgeDetailsViewController.swift
//  
//
//  Created by Roberto Oliveira on 10/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

struct BadgeItem {
    var id:Int
    var title:String
    var imageUrl:String?
    var message:String
    var isActive:Bool
}

class BadgeDetailsViewController: BaseViewController {
    
    // MARK: - Properties
    var currentItem:BadgeItem?
    
    
    
    // MARK: - Objects
    private let blurView:UIVisualEffectView = {
        let vw = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        return vw
    }()
    private lazy var btnClose:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 10.0
        return vw
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 20)
        lbl.textColor = UIColor.white
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Book, size: 14)
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    
    
    
    
    // MARK: - Methods
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.BadgeDetails.close, trackValue: self.currentItem?.id)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let item = self.currentItem else {return}
        self.ivCover.filter = item.isActive ? .None : .BlackAndWhite
        self.ivCover.setServerImage(urlString: item.imageUrl, placeholderImageName: item.imageUrl)
        self.lblTitle.text = item.title
        self.lblSubtitle.text = item.message
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(self.blurView)
        self.view.addFullBoundsConstraintsTo(subView: self.blurView, constant: 0)
        self.blurView.isUserInteractionEnabled = true
        self.blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.close)))
        self.view.addSubview(self.btnClose)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 20)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 5)
        self.btnClose.addWidthConstraint(70)
        self.btnClose.addHeightConstraint(35)
        
        self.view.addSubview(self.stackView)
        self.view.addCenterYAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.view.addCenterXAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.stackView.addWidthConstraint(300)
        self.stackView.addArrangedSubview(self.ivCover)
        self.ivCover.addWidthConstraint(270)
        self.ivCover.addHeightConstraint(270)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.lblSubtitle)
    }
    
    static func showBadge(item:BadgeItem) {
        DispatchQueue.main.async {
            let vc = BadgeDetailsViewController()
            vc.currentItem = item
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }
    }
    
}
