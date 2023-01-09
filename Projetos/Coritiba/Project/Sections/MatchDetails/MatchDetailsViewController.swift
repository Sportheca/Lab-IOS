//
//  MatchDetailsViewController.swift
//  
//
//  Created by Roberto Oliveira on 3/16/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MatchDetailsViewController: BaseStackViewController {
    
    // MARK: - Properties
    var currentID:Int?
    var currentItem:MatchDetails?
    var trackEvent:Int?
    
    
    
    // MARK: - Objects
    private let closeHeaderView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryBackground)
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
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private let headerView:MatchDetailsHeaderView = MatchDetailsHeaderView()
    private let statsView:MatchDetailsStatsView = MatchDetailsStatsView()
    
    
    
    
    // MARK: - Methods
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.MatchDetails.close, trackValue: self.currentID)
        self.dismissAction()
    }
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.MatchDetails.tryAgain
        self.loadContent()
    }
    
    private func loadContent() {
        guard let id = self.currentID else {return}
        DispatchQueue.main.async {
            self.loadingView.startAnimating()
            self.scrollView.alpha = 0.0
        }
        ServerManager.shared.getMatchDetails(id: id, trackEvent: self.trackEvent) { (item:MatchDetails?) in
            self.currentItem = item
            DispatchQueue.main.async {
                guard let object = self.currentItem else {
                    self.loadingView.emptyResults()
                    return
                }
                self.headerView.updateContent(item: object)
                self.statsView.updateContent(item: object)
                self.statsView.isHidden = object.infos.isEmpty
                self.loadingView.stopAnimating()
                UIView.animate(withDuration: 0.25) {
                    self.scrollView.alpha = 1.0
                }
            }
        }
    }
    
    
    
    
    // MARK: - Super Methods
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.loadContent()
    }
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.scrollView.alwaysBounceVertical = true
        self.addStackSpaceView(height: 50)
        self.addFullWidthStackSubview(self.headerView)
        self.addFullWidthStackSubview(self.statsView)
        self.addStackSpaceView(height: 50)
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        // Header
        self.view.insertSubview(self.closeHeaderView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.closeHeaderView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.view.addBottomAlignmentRelatedConstraintTo(subView: self.closeHeaderView, reference: self.btnClose, constant: 10)
        // Loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
    }
    
}
