//
//  RatingViewController.swift
//
//
//  Created by Roberto Oliveira on 22/06/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

extension RatingViewController {
    static func present() {
        let vc = RatingViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
}

class RatingViewController: BaseKeyboardViewController {
    
    // MARK: - Properties
    var trackEvent:Int?
    
    
    
    
    // MARK: - Objects
    private let headerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryBackground)
        return vw
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Avaliar Depois", for: .normal)
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
    private lazy var contentView:RatingContentView = {
        let vw = RatingContentView()
        vw.delegate = self
        return vw
    }()
    
    
    
    // MARK: - Methods
    @objc func tryAgain() {
//        self.trackEvent = EventTrack.PrizeCollector.tryAgain
        self.loadContent()
    }
    
    @objc func close() {
//        ServerManager.shared.setTrack(trackEvent: EventTrack.PrizeCollector.close, trackValue: nil)
        DispatchQueue.main.async {
            self.dismissAction()
        }
    }
    
    private func loadContent() {
        DispatchQueue.main.async {
            self.loadingView.startAnimating()
            self.contentView.isHidden = true
        }
        ServerManager.shared.getRatingDetails(trackEvent: self.trackEvent) { (object:RatingDetails?, message:String?) in
            self.trackEvent = nil
            DispatchQueue.main.async {
                guard let item = object else {
                    self.loadingView.emptyResults()
                    return
                }
                self.loadingView.stopAnimating()
                self.contentView.updateContent(item: item)
                self.contentView.isHidden = false
            }
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.contentView.currentItem == nil {
            self.loadContent()
        }
    }
    
    
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.scrollView.alwaysBounceVertical = true
        self.view.addConstraint(NSLayoutConstraint(item: self.contentContainerView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: 0))
        self.view.addTopAlignmentConstraintTo(subView: self.contentContainerView, relatedBy: .lessThanOrEqual, constant: 0, priority: 999)
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        // header
        self.view.insertSubview(self.headerView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.view.addBottomAlignmentRelatedConstraintTo(subView: self.headerView, reference: self.btnClose, constant: 10)
        // contentView
        self.contentContainerView.addSubview(self.contentView)
        self.contentContainerView.addTopAlignmentConstraintFromSafeAreaTo(subView: self.contentView, constant: 150)
        self.contentContainerView.addBoundsConstraintsTo(subView: self.contentView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.contentContainerView.addBottomAlignmentConstraintTo(subView: self.contentView, relatedBy: .lessThanOrEqual, constant: -50, priority: 999)
    }
    
}




import StoreKit
extension RatingViewController: RatingContentViewDelegate {
    
    func ratingContentView(ratingContentView: RatingContentView, didConfirmWithOption option: RatingOption, andMessage message: String) {
        DispatchQueue.main.async {
            self.loadingView.startAnimating()
            self.contentView.isHidden = true
            SKStoreReviewController.requestReview()
        }
        ServerManager.shared.setRating(item: option, message: message, trackEvent: nil) { (success:Bool?, message:String?) in
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.contentView.isHidden = false
                if success == true {
                    self.basicAlert(message: message ?? "Avaliação enviada!") { (_) in
                        self.dismissAction()
                    }
                } else {
                    self.titleAlert(title: "Ooops", message: message ?? "Falha ao enviar avaliação.", handler: nil)
                }
            }
        }
    }
    
}
