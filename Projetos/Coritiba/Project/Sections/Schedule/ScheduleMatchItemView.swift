//
//  ScheduleMatchItemView.swift
//  
//
//  Created by Roberto Oliveira on 30/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class ScheduleMatchItemView: UIView {
    
    // MARK: - Properties
    static let defaultHeight:CGFloat = 190.0
    private var currentItem:ScheduleMatchItem?
    var ticketTrackEvent:Int?
    
    // MARK: - Objects
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 0.0
        return vw
    }()
    private let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 12)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    private let topSeparatorView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.MutedText)
        return vw
    }()
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 14)
        lbl.textColor = Theme.color(.ScheduleElements)
        return lbl
    }()
    private let detailsContainerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let leftStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 15.0
        return vw
    }()
    private let ivCover0:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        iv.clipsToBounds = true
        return iv
    }()
    private let lblX:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 24)
        lbl.textColor = Theme.color(.MutedText)
        lbl.text = "X"
        return lbl
    }()
    private let ivCover1:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        iv.clipsToBounds = true
        return iv
    }()
    private let rightDetailsContainerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    let lblDetails:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .right
        lbl.textColor = Theme.color(.ScheduleElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let rightStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .equalSpacing
        vw.spacing = 4.0
        return vw
    }()
    private let actionContainerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let actionStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 10.0
        return vw
    }()
    private lazy var btnAction:TicketButton = {
        let btn = TicketButton()
        btn.addTarget(self, action: #selector(self.actionMethod), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(item:ScheduleMatchItem) {
        self.currentItem = item
        self.lblHeader.text = item.categoryTitle
        self.lblTitle.text = item.title
        self.ivCover0.setServerImage(urlString: item.imageUrl0)
        self.ivCover1.setServerImage(urlString: item.imageUrl1)
        let attributed = NSMutableAttributedString()
        attributed.append(NSAttributedString(string: item.date?.stringWith(format: "HH:mm") ?? "-", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Helvetica.Medium, size: 18)
        ]))
        attributed.append(NSAttributedString(string: "\n"+item.placeDescription, attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Helvetica.Medium, size: 12)
        ]))
        self.lblDetails.attributedText = attributed
        
        for sub in self.rightStackView.arrangedSubviews {
            sub.removeFromSuperview()
        }
        
        for chanel in item.chanels {
            let iv = ServerImageView()
//            iv.image = UIImage(named: "icon_broadcast_chanel_\(chanel)")
            iv.setServerImage(urlString: chanel)
            iv.contentMode = .scaleAspectFit
            iv.addHeightConstraint(constant: 15, relatedBy: .equal, priority: 999)
            iv.addWidthConstraint(constant: 60, relatedBy: .lessThanOrEqual, priority: 999)
            self.rightStackView.addArrangedSubview(iv)
        }
        
        let link = item.linkUrlString?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.btnAction.isHidden = link == ""
    }
    
    @objc func actionMethod() {
        ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
            guard confirmed else {return}
            guard let item = self.currentItem else {return}
            ServerManager.shared.setTrack(trackEvent: self.ticketTrackEvent, trackValue: item.id)
            DispatchQueue.main.async {
                BaseWebViewController.open(urlString: item.linkUrlString, mode: item.isEmbed)
            }
        }
    }
    
    
    @objc func checkinMethod() {
        // disabled
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.stackView)
        self.addBoundsConstraintsTo(subView: self.stackView, leading: 0, trailing: 0, top: 7, bottom: 0)
        self.stackView.addArrangedSubview(self.lblHeader)
        self.lblHeader.addHeightConstraint(20)
        self.stackView.addArrangedSubview(self.topSeparatorView)
        self.topSeparatorView.addHeightConstraint(1)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.lblTitle.addHeightConstraint(25)
        self.stackView.addArrangedSubview(self.detailsContainerView)
        self.detailsContainerView.addSubview(self.leftStackView)
        self.detailsContainerView.addBoundsConstraintsTo(subView: self.leftStackView, leading: 0, trailing: nil, top: 8, bottom: -6)
        self.leftStackView.addArrangedSubview(self.ivCover0)
        self.ivCover0.addWidthConstraint(45)
        self.ivCover0.addHeightConstraint(45)
        self.leftStackView.addArrangedSubview(self.lblX)
        self.leftStackView.addArrangedSubview(self.ivCover1)
        self.ivCover1.addWidthConstraint(45)
        self.ivCover1.addHeightConstraint(45)
        self.detailsContainerView.addSubview(self.rightDetailsContainerView)
        self.detailsContainerView.addBoundsConstraintsTo(subView: self.rightDetailsContainerView, leading: nil, trailing: 0, top: nil, bottom: nil)
        self.rightDetailsContainerView.addSubview(self.lblDetails)
        self.rightDetailsContainerView.addBoundsConstraintsTo(subView: self.lblDetails, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.addHorizontalSpacingTo(subView1: self.leftStackView, subView2: self.rightDetailsContainerView, relatedBy: .greaterThanOrEqual, constant: 0, priority: 999)
        self.rightDetailsContainerView.addSubview(self.rightStackView)
        self.rightDetailsContainerView.addVerticalSpacingTo(subView1: self.lblDetails, subView2: self.rightStackView, constant: 2)
        self.rightDetailsContainerView.addBoundsConstraintsTo(subView: self.rightStackView, leading: nil, trailing: 0, top: nil, bottom: 0)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.rightDetailsContainerView, reference: self.ivCover0, constant: 0)
        
        
        self.stackView.addArrangedSubview(self.actionContainerView)
        self.actionContainerView.addHeightConstraint(35)
        self.actionContainerView.addSubview(self.actionStackView)
        self.actionContainerView.addCenterXAlignmentConstraintTo(subView: self.actionStackView, constant: 0)
        self.actionContainerView.addCenterYAlignmentConstraintTo(subView: self.actionStackView, constant: 0)
        self.actionStackView.addArrangedSubview(self.btnAction)
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



