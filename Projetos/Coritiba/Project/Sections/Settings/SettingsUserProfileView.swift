//
//  SettingsUserProfileView.swift
//  
//
//  Created by Roberto Oliveira on 27/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

enum SettingsUserProfileItemMode {
    case Info
    case Password
    case EditProfile
}

struct SettingsUserProfileItem {
    var mode:SettingsUserProfileItemMode
    var title:String?
    var info:String?
    var actionTitle:String?
}

protocol SettingsUserProfileViewDelegate:AnyObject {
    func settingsUserProfileView(settingsUserProfileView:SettingsUserProfileView, didSelectItem item:SettingsUserProfileItem)
}

class SettingsUserProfileView: UIView, SettingsUserProfileItemCellDelegate {
    
    // MARK: - Properties
    weak var delegate:SettingsUserProfileViewDelegate?
    private var dataSource:[SettingsUserProfileItem] = []
    
    // MARK: - Objects
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 15)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Dados Cadastrais"
        return lbl
    }()
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.AlternativeCardBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 25.0
        return vw
    }()
    private var contentHeightConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(SettingsUserProfileItemCell.self, forCellWithReuseIdentifier: "SettingsUserProfileItemCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    // MARK: - Methods
    func updateContent() {
        guard let user = ServerManager.shared.user else {return}
        self.dataSource = [
            SettingsUserProfileItem(mode: .Info, title: "NOME", info: user.name, actionTitle: nil),
            SettingsUserProfileItem(mode: .Info, title: "E-MAIL", info: user.email, actionTitle: nil),
            SettingsUserProfileItem(mode: .Password, title: "SENHA", info: "******", actionTitle: "ALTERAR SENHA"),
            SettingsUserProfileItem(mode: .Info, title: "GÊNERO", info: user.gender?.genderDescription(), actionTitle: nil),
            SettingsUserProfileItem(mode: .Info, title: "DATA DE NASCIMENTO", info: user.born?.stringWith(format: "dd/MM/yyyy"), actionTitle: nil),
            SettingsUserProfileItem(mode: .Info, title: "TELEFONE", info: user.phone, actionTitle: nil),
            SettingsUserProfileItem(mode: .Info, title: "CPF", info: user.cpf?.withMaskCPF() ?? "-", actionTitle: nil),
            SettingsUserProfileItem(mode: .EditProfile, title: nil, info: nil, actionTitle: "ALTERAR DADOS"),
        ]
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.contentHeightConstraint.constant = 70*CGFloat(self.dataSource.count)
        }
    }
    
    func settingsUserProfileItemCell(settingsUserProfileItemCell: SettingsUserProfileItemCell, didSelectItem item: SettingsUserProfileItem) {
        self.delegate?.settingsUserProfileView(settingsUserProfileView: self, didSelectItem: item)
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 20, trailing: -20, top: 10, bottom: nil)
        self.addSubview(self.containerView)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.containerView, constant: 10)
        self.addBoundsConstraintsTo(subView: self.containerView, leading: 10, trailing: -10, top: nil, bottom: -10)
        self.contentHeightConstraint = NSLayoutConstraint(item: self.containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 280)
        self.contentHeightConstraint.priority = UILayoutPriority(999)
        self.addConstraint(self.contentHeightConstraint)
        self.containerView.addSubview(self.collectionView)
        self.containerView.addFullBoundsConstraintsTo(subView: self.collectionView, constant: 0)
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

extension SettingsUserProfileView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsUserProfileItemCell", for: indexPath) as! SettingsUserProfileItemCell
        cell.updateContent(item: self.dataSource[indexPath.item])
        cell.separatorView.isHidden = indexPath.item == 0
        cell.delegate = self
        return cell
    }
    
}



protocol SettingsUserProfileItemCellDelegate:AnyObject {
    func settingsUserProfileItemCell(settingsUserProfileItemCell:SettingsUserProfileItemCell, didSelectItem item:SettingsUserProfileItem)
}

class SettingsUserProfileItemCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var currentItem:SettingsUserProfileItem?
    weak var delegate:SettingsUserProfileItemCellDelegate?
    
    // MARK: - Objects
    let separatorView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.MutedText)
        return vw
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        vw.distribution = .equalCentering
        return vw
    }()
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        return lbl
    }()
    private lazy var btnAction:CustomButton = {
        let btn = CustomButton()
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 10)
        btn.highlightedAlpha = 0.8
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    @objc func confirm() {
        guard let item = self.currentItem else {return}
        self.delegate?.settingsUserProfileItemCell(settingsUserProfileItemCell: self, didSelectItem: item)
    }
    
    
    // MARK: - Methods
    func updateContent(item:SettingsUserProfileItem) {
        self.currentItem = item
        self.btnAction.setTitle(item.actionTitle, for: .normal)
        self.btnAction.isHidden = item.actionTitle == nil
        guard let title = item.title else {
            self.lblTitle.isHidden = true
            return
        }
        self.lblTitle.isHidden = false
        let attributed = NSMutableAttributedString()
        attributed.append(NSAttributedString(string: title+"\n", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 10),
            NSAttributedString.Key.foregroundColor : Theme.color(.MutedText)
        ]))
        attributed.append(NSAttributedString(string: item.info ?? "-", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 14),
            NSAttributedString.Key.foregroundColor : Theme.color(.AlternativeCardElements)
        ]))
        self.lblTitle.attributedText = attributed
    }
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.separatorView)
        self.separatorView.addHeightConstraint(1)
        self.addBoundsConstraintsTo(subView: self.separatorView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.addSubview(self.stackView)
        self.addBoundsConstraintsTo(subView: self.stackView, leading: 25, trailing: -25, top: 0, bottom: 0)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.btnAction)
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
