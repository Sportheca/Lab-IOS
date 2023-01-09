//
//  MatchDetailsHeaderView.swift
//  
//
//  Created by Roberto Oliveira on 3/16/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MatchDetailsHeaderView: UIView {
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.AlternativeCardBackground)
        vw.layer.cornerRadius = 25.0
        vw.layer.shadowOpacity = 0.2
        vw.layer.shadowRadius = 5.0
        vw.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 10)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        return lbl
    }()
    private let lblX:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        return lbl
    }()
    private let horizontalStack:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .top
        vw.distribution = .fillEqually
        vw.spacing = 10.0
        return vw
    }()
    // club 0
    private let ivCover0:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblTitle0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 10)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        return lbl
    }()
    private let lblScore0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 24)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        return lbl
    }()
    private let goals0StackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 10.0
        return vw
    }()
    // club 1
    private let ivCover1:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblTitle1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 10)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        return lbl
    }()
    private let lblScore1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 24)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        return lbl
    }()
    private let goals1StackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 10.0
        return vw
    }()
    
    
    
    // MARK: - Methods
    func updateContent(item:MatchDetails) {
        DispatchQueue.main.async {
            self.lblTitle.text = item.title
            self.lblSubtitle.text = item.subtitle
            
            self.lblTitle0.text = item.club0.title
            self.lblTitle1.text = item.club1.title
            self.lblScore0.text = item.club0.score.descriptionWithThousandsSeparator()
            self.lblScore1.text = item.club1.score.descriptionWithThousandsSeparator()
            self.ivCover0.setServerImage(urlString: item.club0.imageUrl)
            self.ivCover1.setServerImage(urlString: item.club1.imageUrl)
            
            // goals 0
            for sub in self.goals0StackView.arrangedSubviews {
                sub.removeFromSuperview()
            }
            for goalInfo in item.club0.goalsInfos {
                let vw = MatchDetailsGoalInfoView()
                vw.updateContent(title: goalInfo, isLeft: true)
                self.goals0StackView.addArrangedSubview(vw)
            }
            
            
            // goals 1
            for sub in self.goals1StackView.arrangedSubviews {
                sub.removeFromSuperview()
            }
            for goalInfo in item.club1.goalsInfos {
                let vw = MatchDetailsGoalInfoView()
                vw.updateContent(title: goalInfo, isLeft: false)
                self.goals1StackView.addArrangedSubview(vw)
            }
            
            
            guard let p0 = item.club0.penaltiesScore, let p1 = item.club1.penaltiesScore else {
                self.lblX.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 24)
                self.lblX.textColor = Theme.color(.MutedText)
                self.lblX.text = "x"
                return
            }
            self.lblX.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 13)
            self.lblX.textColor = Theme.color(.AlternativeCardElements)
            self.lblX.text = "(\(p0.description) x \(p1.description))"
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // back
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: nil, trailing: nil, top: 15, bottom: -15)
        self.addCenterXAlignmentConstraintTo(subView: self.backView, constant: 0)
        self.backView.addWidthConstraint(constant: 500, relatedBy: .lessThanOrEqual, priority: 999)
        self.addLeadingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: 10, priority: 750)
        self.addTrailingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: -10, priority: 750)
        // title
        self.backView.addSubview(self.lblTitle)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 10, trailing: -10, top: 9, bottom: nil)
        // Subtitle
        self.backView.addSubview(self.lblSubtitle)
        self.backView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.lblSubtitle, constant: 0)
        self.backView.addBoundsConstraintsTo(subView: self.lblSubtitle, leading: 10, trailing: -10, top: nil, bottom: nil)
        
        // X
        self.backView.addSubview(self.lblX)
        self.backView.addCenterXAlignmentConstraintTo(subView: self.lblX, constant: 0)
        // Score 0
        self.backView.addSubview(self.lblScore0)
        self.backView.addHorizontalSpacingTo(subView1: self.lblScore0, subView2: self.lblX, constant: 20)
        self.backView.addCenterYAlignmentRelatedConstraintTo(subView: self.lblScore0, reference: self.lblX, constant: 0)
        // Score 1
        self.backView.addSubview(self.lblScore1)
        self.backView.addHorizontalSpacingTo(subView1: self.lblX, subView2: self.lblScore1, constant: 20)
        self.backView.addCenterYAlignmentRelatedConstraintTo(subView: self.lblScore1, reference: self.lblX, constant: 0)
        // Cover 0
        self.backView.addSubview(self.ivCover0)
        self.ivCover0.addWidthConstraint(74)
        self.ivCover0.addHeightConstraint(74)
        self.backView.addVerticalSpacingTo(subView1: self.lblSubtitle, subView2: self.ivCover0, constant: 0)
        self.backView.addCenterYAlignmentRelatedConstraintTo(subView: self.ivCover0, reference: self.lblX, constant: 0)
        self.backView.addHorizontalSpacingTo(subView1: self.ivCover0, subView2: self.lblScore0, constant: 25)
        // Title 0
        self.backView.addSubview(self.lblTitle0)
        self.backView.addCenterXAlignmentRelatedConstraintTo(subView: self.lblTitle0, reference: self.ivCover0, constant: 0)
        self.backView.addVerticalSpacingTo(subView1: self.ivCover0, subView2: self.lblTitle0, constant: 4)
        // Cover 1
        self.backView.addSubview(self.ivCover1)
        self.ivCover1.addWidthConstraint(74)
        self.ivCover1.addHeightConstraint(74)
        self.backView.addCenterYAlignmentRelatedConstraintTo(subView: self.ivCover1, reference: self.lblX, constant: 0)
        self.backView.addHorizontalSpacingTo(subView1: self.lblScore1, subView2: self.ivCover1, constant: 25)
        // Title 1
        self.backView.addSubview(self.lblTitle1)
        self.backView.addCenterXAlignmentRelatedConstraintTo(subView: self.lblTitle1, reference: self.ivCover1, constant: 0)
        self.backView.addVerticalSpacingTo(subView1: self.ivCover1, subView2: self.lblTitle1, constant: 0)
        // Horizontal Stack
        self.backView.addSubview(self.horizontalStack)
        self.backView.addVerticalSpacingTo(subView1: self.ivCover0, subView2: self.horizontalStack, constant: 20)
        self.backView.addBoundsConstraintsTo(subView: self.horizontalStack, leading: 10, trailing: -10, top: nil, bottom: -30)
        self.horizontalStack.addArrangedSubview(self.goals0StackView)
        self.horizontalStack.addArrangedSubview(self.goals1StackView)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}










class MatchDetailsGoalInfoView: UIView {
    
    // MARK: - Objects
    private let ivIcon:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_goal")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = Theme.color(.AlternativeCardElements)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 10)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(title:String, isLeft:Bool) {
        self.lblTitle.removeFromSuperview()
        self.ivIcon.removeFromSuperview()
        self.addSubview(self.lblTitle)
        self.addSubview(self.ivIcon)
        self.lblTitle.textAlignment = isLeft ? .left : .right
        self.lblTitle.text = title
        self.lblTitle.addHeightConstraint(constant: 15, relatedBy: .greaterThanOrEqual, priority: 999)
        self.ivIcon.addWidthConstraint(15)
        self.ivIcon.addHeightConstraint(15)
        if isLeft {
            self.addBoundsConstraintsTo(subView: self.ivIcon, leading: 0, trailing: nil, top: 0, bottom: nil)
            self.addHorizontalSpacingTo(subView1: self.ivIcon, subView2: self.lblTitle, constant: 5)
            self.addBoundsConstraintsTo(subView: self.lblTitle, leading: nil, trailing: 0, top: 0, bottom: 0)
        } else {
            self.addBoundsConstraintsTo(subView: self.ivIcon, leading: nil, trailing: 0, top: 0, bottom: nil)
            self.addHorizontalSpacingTo(subView1: self.lblTitle, subView2: self.ivIcon, constant: 5)
            self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 0, trailing: nil, top: 0, bottom: 0)
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
}
