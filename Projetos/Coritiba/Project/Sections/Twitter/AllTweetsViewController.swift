//
//  AllTweetsViewController.swift
//
//
//  Created by Roberto Oliveira on 04/06/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class AllTweetsViewController: BaseViewController {
    
    // MARK: - Properties
    var searchString:String = ""
    
    
    // MARK: - Objects
    private let headerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor(R: 247, G: 244, B: 244)
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
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 16)
        lbl.textColor = UIColor(R: 50, G: 50, B: 50)
        lbl.text = "Twitter"
        return lbl
    }()
    private let contentView:TwitterVerticalFeedView = TwitterVerticalFeedView()
    
    
    
    
    
    
    // MARK: - Methods
    @objc func close() {
//        ServerManager.shared.setTrack(trackEvent: EventTrack.AllNews.close, trackValue: nil)
        self.dismissAction()
    }
    
    
    
    
    // MARK: - Super Methods
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.contentView.updateContent(searchString: self.searchString)
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        // Title
        self.view.addSubview(self.lblTitle)
        self.view.addVerticalSpacingTo(subView1: self.btnClose, subView2: self.lblTitle, constant: 10)
        self.view.addLeadingAlignmentRelatedConstraintTo(subView: self.lblTitle, reference: self.btnClose, constant: 0)
        // Header
        self.view.insertSubview(self.headerView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.view.addBottomAlignmentRelatedConstraintTo(subView: self.headerView, reference: self.lblTitle, constant: 10)
        // Content
        self.view.addSubview(self.contentView)
        self.view.addVerticalSpacingTo(subView1: self.headerView, subView2: self.contentView, constant: 0)
        self.view.addBoundsConstraintsTo(subView: self.contentView, leading: 0, trailing: 0, top: nil, bottom: 0)
    }
    
}




