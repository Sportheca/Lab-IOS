//
//  AdsView.swift
//  
//
//  Created by Roberto Oliveira on 24/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

enum AdsPosition:Int {
    case Splash = 1
    case QuizDashboard = 2
    case Selecaoideal = 3
    case ResultadosDasUltimasPesquisas = 4
    case Quiz = 5
    case QuizInterna = 6
    case PesquisaInterna = 7
    case Palpite = 8
}

class AdsView: UIView {
    
    // MARK: - Objects
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 10.0
        return vw
    }()
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 14)
        lbl.text = "OFERECIMENTO"
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    let ivLogo:ServerImageView = {
        let iv = ServerImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    // MARK: - Methods
    func updateContent(position:AdsPosition) {
        let schemeID = 1
        DispatchQueue.main.async {
            self.ivLogo.setServerImage(urlString: "")
        }
        ServerManager.shared.getAds(position: position, schemeID: schemeID) { (imageUrl:String?) in
            DispatchQueue.main.async {
                let img = imageUrl ?? ""
                self.ivLogo.setServerImage(urlString: img)
                self.stackView.isHidden = img == ""
            }
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.stackView)
        self.addCenterXAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.ivLogo)
        self.ivLogo.addHeightConstraint(40)
        self.ivLogo.addWidthConstraint(constant: 60, relatedBy: .lessThanOrEqual, priority: 999)
        self.stackView.isHidden = true
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
