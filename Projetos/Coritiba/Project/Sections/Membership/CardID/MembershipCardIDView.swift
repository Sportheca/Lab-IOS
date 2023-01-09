//
//  MembershipCardIDView.swift
//
//
//  Created by Roberto Oliveira on 20/08/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MembershipCardIDView: UIView {
    
    // MARK: - Objects
    private let ivBackground:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "membership_card_bg")
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let btnAvatar:AvatarButton = {
        let iv = AvatarButton()
        iv.customTintColor = Theme.color(.MembershipCardPrimaryElements)
        iv.isUserInteractionEnabled = false
        iv.isCircle = false
        return iv
    }()
    private let infoView0:MembershipCardIDInfoView = MembershipCardIDInfoView()
    private let infoView1:MembershipCardIDInfoView = MembershipCardIDInfoView()
    
    
    
    
    // MARK: - Methods
    func updateContent() {
        guard let user = ServerManager.shared.user else {return}
        self.btnAvatar.updateWithCurrentUserImage()
        let nameComponents = user.name?.components(separatedBy: " ") ?? []
        let firstName = nameComponents.first ?? ""
        let lastName = (nameComponents.count > 1) ? nameComponents.last ?? "" : ""
        var sinceDescription = user.born?.stringWith(format: "yyyy") ?? ""
        if sinceDescription.isEmpty {
            sinceDescription = "Sempre"
        }
        // infos
        self.infoView0.updateContent(info0: "NOME", info1: "\(firstName) \(lastName)".uppercased())
        self.infoView1.updateContent(info0: "TORCEDOR DESDE", info1: sinceDescription)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.bounds.width
        let height = self.bounds.height
        
        self.btnAvatar.frame = CGRect(x: width*0.05, y: height*0.25, width: width*0.18, height: width*0.18)
        self.infoView0.frame = CGRect(x: width*0.05, y: height*0.60, width: width*0.5, height: 30)
        self.infoView1.frame = CGRect(x: width*0.05, y: (height*0.60)+30+10, width: width*0.5, height: 30)
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Background
        self.addSubview(self.ivBackground)
        self.addFullBoundsConstraintsTo(subView: self.ivBackground, constant: 0)
        self.addConstraint(NSLayoutConstraint(item: self.ivBackground, attribute: .height, relatedBy: .equal, toItem: self.ivBackground, attribute: .width, multiplier: 0.63, constant: 0))
        // Infos
        self.addSubview(self.infoView0)
        self.addSubview(self.infoView1)
        // Avatar
        self.addSubview(self.btnAvatar)
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






class MembershipCardIDInfoView: UIView {
    
    // MARK: - Objects
    private let separator:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.MembershipCardSecondaryElements)
        return vw
    }()
    private let lblInfo0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.BookOblique, size: 8)
        lbl.textColor = Theme.color(.MembershipCardSecondaryElements)
        return lbl
    }()
    private let lblInfo1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 12)
        lbl.textColor = Theme.color(.MembershipCardPrimaryElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(info0:String, info1:String) {
        self.lblInfo0.text = info0
        self.lblInfo1.text = info1
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.separator)
        self.addBoundsConstraintsTo(subView: self.separator, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.separator.addHeightConstraint(1)
        self.addSubview(self.lblInfo0)
        self.addBoundsConstraintsTo(subView: self.lblInfo0, leading: 0, trailing: 0, top: 1, bottom: nil)
        self.addSubview(self.lblInfo1)
        self.addVerticalSpacingTo(subView1: self.lblInfo0, subView2: self.lblInfo1, constant: -1)
        self.addBoundsConstraintsTo(subView: self.lblInfo1, leading: 0, trailing: 0, top: nil, bottom: nil)
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
