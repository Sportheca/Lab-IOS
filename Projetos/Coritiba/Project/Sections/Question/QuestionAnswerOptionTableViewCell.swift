//
//  QuestionAnswerOptionTableViewCell.swift
//
//
//  Created by Roberto Oliveira on 13/07/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class QuestionAnswerOptionTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var indexPath:IndexPath = IndexPath()
    private let correct_color:UIColor = Theme.color(.PrimaryText)
    private let wrong_color:UIColor = Theme.color(.PrimaryText)
    
    
    
    // MARK: - Objects
    let separator:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        vw.layer.cornerRadius = 10.0
//        vw.layer.shadowOpacity = 0.0
//        vw.layer.shadowRadius = 3.0
//        vw.layer.shadowOffset = CGSize.zero
        vw.layer.borderWidth = 1.0
        vw.layer.borderColor = Theme.color(.PrimaryText).cgColor
        return vw
    }()
    private let progressContainerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        vw.layer.cornerRadius = 10.0
        vw.clipsToBounds = true
        return vw
    }()
    private var progressWidthConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private let progressView:UIView = UIView()
    private let lblProgress:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Medium, size: 12)
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    private let marker:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        vw.layer.borderColor = Theme.color(.PrimaryText).cgColor
        vw.layer.cornerRadius = 8.0
        vw.clipsToBounds = true
        vw.alpha = 0.7
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 18)
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    private let ivIcon:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(title:String) {
        self.alpha = 1.0
        self.lblTitle.text = title
        self.containerView.scaleTo(nil)
        self.containerView.layer.shadowOpacity = 0.0
        self.ivIcon.alpha = 0.0
        self.marker.backgroundColor = UIColor.clear
        self.marker.layer.borderWidth = 2.0
        self.lblProgress.text = nil
        self.removeConstraint(self.progressWidthConstraint)
        self.progressWidthConstraint = NSLayoutConstraint(item: self.progressView, attribute: .width, relatedBy: .equal, toItem: self.progressContainerView, attribute: .width, multiplier: 0.0, constant: 0.0)
        self.addConstraint(self.progressWidthConstraint)
        self.layoutIfNeeded()
    }
    
    func showResult(correct:Bool, scale:Bool) {
        let duration:TimeInterval = 0.25
        // Change Icon and marker color
        self.ivIcon.tintColor = correct ? self.correct_color : self.wrong_color
        let imageName = correct ? "icon_question_answer_right" : "icon_question_answer_wrong"
        self.ivIcon.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        UIView.animate(withDuration: duration) {
            self.ivIcon.alpha = 1.0
            self.marker.backgroundColor = correct ? self.correct_color : self.wrong_color
            self.marker.layer.borderWidth = 0.0
        }
        if scale {
            // Animate Scale and Icon
//            self.containerView.scaleTo(1.075, duration: duration)
            // Animate Shadow
//            let animation = CABasicAnimation(keyPath: "shadowOpacity")
//            animation.toValue = 0.3
//            animation.duration = duration
//            animation.fillMode = CAMediaTimingFillMode.forwards
//            animation.isRemovedOnCompletion = false
//            self.containerView.layer.add(animation, forKey: nil)
        }
    }
    
    func showPercentage(value:Float, scale:Bool, color:UIColor) {
        let duration:TimeInterval = 0.25
        // Update Progress Text
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "%", attributes: [NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Avenir.Medium, size: 9)]))
        att.append(NSAttributedString(string: "\n"+value.roundTo(places: 2).description, attributes: [NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Avenir.Medium, size: 11)]))
        self.lblProgress.attributedText = att
        // Update Progress bar
        self.progressView.backgroundColor = color
        self.progressContainerView.layer.cornerRadius = scale ? 10.0 : 0.0
        self.removeConstraint(self.progressWidthConstraint)
        self.progressWidthConstraint = NSLayoutConstraint(item: self.progressView, attribute: .width, relatedBy: .equal, toItem: self.progressContainerView, attribute: .width, multiplier: CGFloat(value/100), constant: 0.0)
        self.addConstraint(self.progressWidthConstraint)
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
//        if scale {
//            // Animate Scale and Icon
//            self.containerView.scaleTo(1.075, duration: duration)
//            // Animate Shadow
//            let animation = CABasicAnimation(keyPath: "shadowOpacity")
//            animation.toValue = 0.3
//            animation.duration = duration
//            animation.fillMode = CAMediaTimingFillMode.forwards
//            animation.isRemovedOnCompletion = false
//            self.containerView.layer.add(animation, forKey: nil)
//        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        // Separator
        self.addSubview(self.separator)
        self.separator.addHeightConstraint(1)
        self.addBoundsConstraintsTo(subView: self.separator, leading: 20, trailing: -10, top: 0, bottom: nil)
        // Container
        self.addSubview(self.containerView)
        self.addBoundsConstraintsTo(subView: self.containerView, leading: 0, trailing: 0, top: 6, bottom: -6)
        // Progress
        self.containerView.addSubview(self.progressContainerView)
        self.containerView.addFullBoundsConstraintsTo(subView: self.progressContainerView, constant: 0)
        self.progressContainerView.addSubview(self.progressView)
        self.progressContainerView.addBoundsConstraintsTo(subView: self.progressView, leading: 0, trailing: nil, top: 0, bottom: 0)
        self.progressWidthConstraint = NSLayoutConstraint(item: self.progressView, attribute: .width, relatedBy: .equal, toItem: self.progressContainerView, attribute: .width, multiplier: 0.0, constant: 0.0)
        self.addConstraint(self.progressWidthConstraint)
        // Marker
//        self.containerView.addSubview(self.marker)
//        self.marker.addHeightConstraint(16)
//        self.marker.addWidthConstraint(16)
//        self.containerView.addLeadingAlignmentConstraintTo(subView: self.marker, constant: 10)
//        self.containerView.addCenterYAlignmentConstraintTo(subView: self.marker, constant: 0)
//        self.marker.alpha = 0.0
        // Title
        self.containerView.addSubview(self.lblTitle)
        self.lblTitle.addHeightConstraint(constant: 50, relatedBy: .greaterThanOrEqual, priority: 999)
//        self.containerView.addHorizontalSpacingTo(subView1: self.marker, subView2: self.lblTitle, constant: 14)
        self.containerView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 40, trailing: -40, top: 5, bottom: -5)
        // Icon
        self.containerView.addSubview(self.ivIcon)
        self.containerView.addCenterYAlignmentConstraintTo(subView: self.ivIcon, constant: 0)
        self.containerView.addTrailingAlignmentConstraintTo(subView: self.ivIcon, constant: -11)
        self.ivIcon.addHeightConstraint(22)
        self.ivIcon.addWidthConstraint(22)
        // Progress
        self.containerView.addSubview(self.lblProgress)
        self.containerView.addCenterYAlignmentConstraintTo(subView: self.lblProgress, constant: 0)
        self.containerView.addTrailingAlignmentConstraintTo(subView: self.lblProgress, constant: -2)
        self.containerView.addHorizontalSpacingTo(subView1: self.lblTitle, subView2: self.lblProgress, constant: 2)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}
