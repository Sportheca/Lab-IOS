//
//  PlayerProfileInfosCell.swift
//  
//
//  Created by Roberto Oliveira on 20/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class PlayerProfileInfosCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var currentItem:PlayerProfile?
    
    
    // MARK: - Objects
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(PlayerProfileInfoCell1.self, forCellWithReuseIdentifier: "PlayerProfileInfoCell1")
        cv.register(PlayerProfileInfoCell2.self, forCellWithReuseIdentifier: "PlayerProfileInfoCell2")
        cv.register(PlayerProfileInfoCell3.self, forCellWithReuseIdentifier: "PlayerProfileInfoCell3")
        cv.register(PlayerProfileInfoCell4.self, forCellWithReuseIdentifier: "PlayerProfileInfoCell4")
        cv.dataSource = self
        cv.delegate = self
        cv.isScrollEnabled = false
        return cv
    }()
    
    // MARK: - Methods
    func updateContent(item:PlayerProfile) {
        DispatchQueue.main.async {
            self.currentItem = item
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.collectionView)
        self.addFullBoundsConstraintsTo(subView: self.collectionView, constant: 0)
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


extension PlayerProfileInfosCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // didSelectItemAt
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width:CGFloat = (collectionView.bounds.width - 30)
        var height:CGFloat = 155
        
        switch indexPath.item {
        case 0, 1:
            width = (collectionView.bounds.width - 45)/2
            if UIScreen.main.bounds.width < 375 {
                height = 125
            }
        case 2:
            height = 70
//        case 3:
//            width = (collectionView.bounds.width - 45) * 0.4
//            height = 70
//        case 4:
//            width = (collectionView.bounds.width - 45) * 0.6
//            height = 70
            
        default: break
        }
        height = (collectionView.bounds.height-60)/2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerProfileInfoCell1", for: indexPath) as! PlayerProfileInfoCell1
            guard let item = self.currentItem else {return cell}
            if item.category == .GoalKeeper {
                cell.updateContent(icon: "icon_goal", title: "GOLS SOFRIDOS", subtitle: "PELO CLUBE", info: item.goalsAgainst.descriptionWithThousandsSeparator())
            } else {
                cell.updateContent(icon: "icon_goal", title: "GOLS", subtitle: "MARCADOS PELO CLUBE", info: item.goals.descriptionWithThousandsSeparator())
            }
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerProfileInfoCell1", for: indexPath) as! PlayerProfileInfoCell1
            guard let item = self.currentItem else {return cell}
            if item.category == .GoalKeeper {
                cell.updateContent(icon: "icon_goalkeeper", title: "JOGOS", subtitle: "COMO TITULAR", info: item.penaltiesSaved.descriptionWithThousandsSeparator())
            } else {
                cell.updateContent(icon: "icon_assists", title: "JOGOS", subtitle: "COMO TITULAR", info: item.matches.descriptionWithThousandsSeparator())
            }
//            if item.category == .GoalKeeper {
//                cell.updateContent(icon: "icon_goalkeeper", title: "PÊNALTIS DEFENDIDOS", subtitle: "PELO CLUBE", info: item.penaltiesSaved.descriptionWithThousandsSeparator())
//            } else {
//                cell.updateContent(icon: "icon_assists", title: "ASSISTÊNCIAS", subtitle: "MARCADAS PELO CLUBE", info: item.assists.descriptionWithThousandsSeparator())
//            }
            return cell
            
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerProfileInfoCell4", for: indexPath) as! PlayerProfileInfoCell4
            guard let item = self.currentItem else {return cell}
            cell.updateContent(title: "ESTREIA", info: item.startDescription ?? "-")
            return cell
        }
    }
    
}











class PlayerProfileInfoCell1: UICollectionViewCell {
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.AlternativeCardElements).withAlphaComponent(0.08)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    private let ivIcon:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.tintColor = Theme.color(.PrimaryAnchor)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 12)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 10)
        lbl.textColor = Theme.color(.MutedText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblInfo:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 40)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    
    
    
    // MARK: - Methods
    func updateContent(icon:String, title:String, subtitle:String, info:String) {
        self.ivIcon.image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
        self.lblTitle.text = title
        self.lblSubtitle.text = subtitle
        self.lblInfo.text = info
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // back view
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: 0, trailing: 0, top: 0, bottom: 0)
        // icon
        self.backView.addSubview(self.ivIcon)
        self.ivIcon.addHeightConstraint(24)
        self.ivIcon.addWidthConstraint(24)
        self.backView.addBoundsConstraintsTo(subView: self.ivIcon, leading: 15, trailing: nil, top: 15, bottom: nil)
        // title
        self.backView.addSubview(self.lblTitle)
        self.backView.addVerticalSpacingTo(subView1: self.ivIcon, subView2: self.lblTitle, constant: 5)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 15, trailing: -15, top: nil, bottom: nil)
        // Subtitle
        self.backView.addSubview(self.lblSubtitle)
        self.backView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.lblSubtitle, constant: 1)
        self.backView.addBoundsConstraintsTo(subView: self.lblSubtitle, leading: 15, trailing: -15, top: nil, bottom: nil)
        // Info
        self.backView.addSubview(self.lblInfo)
        self.backView.addBoundsConstraintsTo(subView: self.lblInfo, leading: 15, trailing: -15, top: nil, bottom: -10)
        
        if UIScreen.main.bounds.width < 375 {
            self.lblInfo.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 20)
        }
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












class PlayerProfileInfoCell2: UICollectionViewCell {
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.AlternativeCardElements).withAlphaComponent(0.08)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 12)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblInfo:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 32)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    private let progressContainerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private var progressWidthConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private let progressView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        vw.clipsToBounds = true
        return vw
    }()
    private let stackView0:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 5.0
        return vw
    }()
    private let stackView1:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 5.0
        return vw
    }()
    
    
    
    // MARK: - Methods
    func updateContent(title:String, average:Float) {
        self.lblTitle.text = title
        self.lblInfo.text = average.formattedDescription(places: 2, grouping: "", decimal: ".")
        self.removeConstraint(self.progressWidthConstraint)
        self.progressWidthConstraint = NSLayoutConstraint(item: self.progressView, attribute: .width, relatedBy: .equal, toItem: self.progressContainerView, attribute: .width, multiplier: min(1, CGFloat(average)), constant: 0)
        self.progressWidthConstraint.priority = UILayoutPriority(999)
        self.addConstraint(self.progressWidthConstraint)
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // back view
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: 0, trailing: 0, top: 0, bottom: 0)
        // Info
        self.backView.addSubview(self.lblInfo)
        self.backView.addBoundsConstraintsTo(subView: self.lblInfo, leading: nil, trailing: -15, top: 0, bottom: 0)
        self.lblInfo.addWidthConstraint(70)
        // title
        self.backView.addSubview(self.lblTitle)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 10, trailing: nil, top: 5, bottom: nil)
        self.backView.addHorizontalSpacingTo(subView1: self.lblTitle, subView2: self.lblInfo, constant: 10)
        // Progress
        self.backView.addSubview(self.progressContainerView)
        self.backView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.progressContainerView, constant: 5)
        self.backView.addLeadingAlignmentConstraintTo(subView: self.progressContainerView, constant: 10)
        self.progressContainerView.addHeightConstraint(16)
        self.progressContainerView.addSubview(self.stackView0)
        self.progressContainerView.addFullBoundsConstraintsTo(subView: self.stackView0, constant: 0)
        self.progressContainerView.addSubview(self.progressView)
        self.progressContainerView.addBoundsConstraintsTo(subView: self.progressView, leading: 0, trailing: nil, top: 0, bottom: 0)
        self.progressWidthConstraint = NSLayoutConstraint(item: self.progressView, attribute: .width, relatedBy: .equal, toItem: self.progressContainerView, attribute: .width, multiplier: 1.0, constant: 0)
        self.progressWidthConstraint.priority = UILayoutPriority(999)
        self.addConstraint(self.progressWidthConstraint)
        self.progressView.addSubview(self.stackView1)
        self.progressContainerView.addFullBoundsConstraintsTo(subView: self.stackView1, constant: 0)
        self.addIconsToStackView(vw: self.stackView0, color: Theme.color(.MutedText))
        self.addIconsToStackView(vw: self.stackView1, color: Theme.color(.AlternativeCardElements))
        
        if UIScreen.main.bounds.width < 375 {
            self.lblInfo.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 20)
            self.stackView0.spacing = 2.0
            self.stackView1.spacing = 2.0
        }
        
    }
    
    func addIconsToStackView(vw:UIStackView, color:UIColor) {
        for _ in 1...10 {
            let iv = UIImageView()
            iv.backgroundColor = UIColor.clear
            iv.tintColor = color
            iv.contentMode = .scaleAspectFit
            iv.image = UIImage(named: "icon_goal")?.withRenderingMode(.alwaysTemplate)
            vw.addArrangedSubview(iv)
            iv.addWidthConstraint(16)
        }
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








class PlayerProfileInfoCell3: UICollectionViewCell {
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.AlternativeCardElements).withAlphaComponent(0.08)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 12)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 15.0
        return vw
    }()
    //
    private let stackView0:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 6.0
        return vw
    }()
    private let ivIcon0:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        iv.image = UIImage(named: "red_card")
        return iv
    }()
    private let lblInfo0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 18)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    //
    private let stackView1:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 6.0
        return vw
    }()
    private let ivIcon1:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        iv.image = UIImage(named: "yellow_card")
        return iv
    }()
    private let lblInfo1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 18)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    
    
    // MARK: - Methods
    func updateContent(yellowCards:Int, redCards:Int) {
        self.lblTitle.text = "Cartões"
        self.lblInfo0.text = redCards.descriptionWithThousandsSeparator()
        self.lblInfo1.text = yellowCards.descriptionWithThousandsSeparator()
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // back view
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: 0, trailing: 0, top: 0, bottom: 0)
        // title
        self.backView.addSubview(self.lblTitle)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 10, trailing: -10, top: 5, bottom: nil)
        // stacks
        self.backView.addSubview(self.stackView)
        self.backView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.stackView, constant: 8)
        self.backView.addCenterXAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.backView.addLeadingAlignmentConstraintTo(subView: self.stackView, relatedBy: .greaterThanOrEqual, constant: 5, priority: 999)
        self.backView.addTrailingAlignmentConstraintTo(subView: self.stackView, relatedBy: .lessThanOrEqual, constant: -5, priority: 999)
        self.stackView.addArrangedSubview(self.stackView0)
        self.stackView.addArrangedSubview(self.stackView1)
        
        self.stackView0.addArrangedSubview(self.ivIcon0)
        self.ivIcon0.addWidthConstraint(15)
        self.ivIcon0.addHeightConstraint(28)
        self.stackView0.addArrangedSubview(self.lblInfo0)
        
        self.stackView1.addArrangedSubview(self.ivIcon1)
        self.ivIcon1.addWidthConstraint(15)
        self.ivIcon1.addHeightConstraint(28)
        self.stackView1.addArrangedSubview(self.lblInfo1)
        
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








class PlayerProfileInfoCell4: UICollectionViewCell {
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.AlternativeCardElements).withAlphaComponent(0.08)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 12)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        return lbl
    }()
    private let lblInfo:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 32)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    
    
    // MARK: - Methods
    func updateContent(title:String, info:String) {
        self.lblTitle.text = title
        self.lblInfo.text = info
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // back view
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: 0, trailing: 0, top: 0, bottom: 0)
        // title
        self.backView.addSubview(self.lblTitle)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 15, trailing: -15, top: 10, bottom: nil)
        // Info
        self.backView.addSubview(self.lblInfo)
        self.backView.addBoundsConstraintsTo(subView: self.lblInfo, leading: 15, trailing: -15, top: nil, bottom: nil)
        self.backView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.lblInfo, constant: 5)
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
