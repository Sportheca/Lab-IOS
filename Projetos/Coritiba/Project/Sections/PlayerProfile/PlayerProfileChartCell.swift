//
//  PlayerProfileChartCell.swift
//  
//
//  Created by Roberto Oliveira on 20/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class PlayerProfileChartCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var currentItem:PlayerProfile?
    private var selectedInfoID:Int = 1 // 1=geral | 2=titular | 3=reserva
    
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    private let chartView:RadarChart = {
        let vw = RadarChart()
        vw.matrixCornerRadius = 5.0
        vw.matrixOutlineReferences = 4
        vw.matrixLastReferenceMultiplier = 0.3
        vw.matrixBorderColor = Theme.color(.PrimaryCardElements).withAlphaComponent(0.3)
        vw.matrixBorderWidth = 1.0
        vw.matrixLastReferenceFillColor = UIColor.clear
        vw.progressBackgroundColor = Theme.color(.PrimaryAnchor).withAlphaComponent(0.4)
        vw.progressBorderColor = Theme.color(.PrimaryAnchor)
        return vw
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 5.0
        return vw
    }()
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(item:PlayerProfile) {
        self.currentItem = item
        self.updateActions()
        
        let animationTime:TimeInterval = 2.0
        guard let info = item.chartInfos[self.selectedInfoID] else {
            DispatchQueue.main.async {
                self.chartView.alpha = 0.0
            }
            ServerManager.shared.getPlayerProfileChartInfo(item: item, infoID: self.selectedInfoID, trackEvent: nil) { (success:Bool) in
                DispatchQueue.main.async {
                    if let obj = item.chartInfos[self.selectedInfoID] {
                        self.chartView.alpha = 1.0
                        self.chartView.updateValues(item: obj, animationTime: animationTime)
                    }
                }
            }
            
            return
        }
        self.chartView.alpha = 1.0
        self.chartView.updateValues(item: info, animationTime: animationTime)
    }
    
    
    private func updateActions() {
        for sub in self.stackView.arrangedSubviews {
            sub.removeFromSuperview()
        }
        
        let actions:[BasicInfo] = [
//            BasicInfo(id: 1, title: "Todos os Jogos"),
//            BasicInfo(id: 2, title: "Jogos como titular"),
//            BasicInfo(id: 3, title: "Saindo do banco")
        ]
        for item in actions {
            let btn = CustomButton()
            btn.addWidthConstraint(120)
            btn.addHeightConstraint(26)
            btn.setTitle(item.title, for: .normal)
            btn.tag = item.id
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 13.0
            btn.layer.borderWidth = 1.0
            btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 11)
            btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
            if item.id == self.selectedInfoID {
                btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
                btn.layer.borderColor = UIColor.clear.cgColor
            } else {
                btn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                btn.layer.borderColor = UIColor.white.cgColor
            }
            btn.highlightedAlpha = 0.6
            btn.highlightedScale = 0.95
            btn.addTarget(self, action: #selector(self.actionMethod(_:)), for: .touchUpInside)
            self.stackView.addArrangedSubview(btn)
        }
        
    }
    
    @objc func actionMethod(_ sender:UIButton) {
        guard let item = self.currentItem else {return}
        self.selectedInfoID = sender.tag
        self.updateContent(item: item)
        // track
        let trackValue = "\(self.selectedInfoID)@\(item.id)"
        ServerManager.shared.setTrack(trackEvent: EventTrack.PlayerProfile.changeChartData, trackValue: trackValue)
    }
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // chart
        self.addSubview(self.chartView)
        self.addCenterXAlignmentConstraintTo(subView: self.chartView, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.chartView, constant: 0)
        self.addTopAlignmentConstraintTo(subView: self.chartView, relatedBy: .greaterThanOrEqual, constant: 10, priority: 999)
        self.addBottomAlignmentConstraintTo(subView: self.chartView, relatedBy: .lessThanOrEqual, constant: -5, priority: 999)
        self.addLeadingAlignmentConstraintTo(subView: self.chartView, relatedBy: .greaterThanOrEqual, constant: 10, priority: 999)
        self.addTrailingAlignmentConstraintTo(subView: self.chartView, relatedBy: .lessThanOrEqual, constant: -10, priority: 999)
        self.addTopAlignmentConstraintTo(subView: self.chartView, relatedBy: .equal, constant: 0, priority: 750)
        self.addBottomAlignmentConstraintTo(subView: self.chartView, relatedBy: .equal, constant: 0, priority: 750)
        self.addLeadingAlignmentConstraintTo(subView: self.chartView, relatedBy: .equal, constant: 0, priority: 750)
        self.addTrailingAlignmentConstraintTo(subView: self.chartView, relatedBy: .equal, constant: 0, priority: 750)
        self.addConstraint(NSLayoutConstraint(item: self.chartView, attribute: .width, relatedBy: .equal, toItem: self.chartView, attribute: .height, multiplier: 1.0, constant: 20))
        // Back view
        self.insertSubview(self.backView, belowSubview: self.chartView)
        self.addCenterXAlignmentRelatedConstraintTo(subView: self.backView, reference: self.chartView, constant: 0)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.backView, reference: self.chartView, constant: 0)
        self.addHeightRelatedConstraintTo(subView: self.backView, reference: self.chartView, relatedBy: .equal, multiplier: 1.0, constant: 10.0, priority: 999)
        self.addWidthRelatedConstraintTo(subView: self.backView, reference: self.chartView, relatedBy: .equal, multiplier: 1.0, constant: 10.0, priority: 999)
        // Stack
        self.addSubview(self.stackView)
        self.addCenterXAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.stackView, constant: 0)
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
