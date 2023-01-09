//
// FloatingButton.swift
// 
//
// Created by Roberto Oliveira on 07/05/22.
// Copyright © 2022 Sportheca. All rights reserved.
//

import UIKit

struct ButtonInfos {
    var url:String?
    var imgUrl:String?
    var isEmbed:WebContentPresentationMode?
}

class FloatingButton {
    
    // MARK: - Shared
    private init(){}
    static let shared:FloatingButton = FloatingButton()
    
    // MARK: - Properties
    var urlString:String = ""
    var imgUrlImage:String = ""
    var isEmbed:WebContentPresentationMode?
    var currentItem:ButtonInfos?

    // MARK: - Floating Button
    private lazy var btnFloating:CustomButton = {
        let btn = CustomButton()
        btn.adjustsImageWhenHighlighted = false
        btn.backgroundColor = UIColor.clear
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.floatingAction), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Methods
    @objc func floatingAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.NoScreen.floatingButton, trackValue: nil)
        DispatchQueue.main.async {
            let item = self.currentItem
            BaseWebViewController.open(urlString: item?.url, mode: item?.isEmbed)
        }
    }
    func showFloatingButton() {
        let item = self.currentItem
        self.btnFloating.setServerImage(urlString: item?.imgUrl)
        guard item?.url?.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            self.hideFloatingButton()
            return
        }
        guard ServerManager.shared.isHomePresented == true else {
            self.hideFloatingButton()
            return
        }
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {return}
            self.btnFloating.removeFromSuperview()
            window.addSubview(self.btnFloating)
            let bottom = (UIApplication.shared.delegate as? AppDelegate)?.tabController?.tabBar.frame.height ?? 49.0
            window.addBottomAlignmentConstraintTo(subView: self.btnFloating, constant: -(bottom+3))
            window.addTrailingAlignmentConstraintTo(subView: self.btnFloating, constant: -5)
            self.btnFloating.addHeightConstraint(61)
            self.btnFloating.addWidthConstraint(61)
        }
    }
    
    func hideFloatingButton() {
        DispatchQueue.main.async {
            self.btnFloating.removeFromSuperview()
        }
    }
    
}
