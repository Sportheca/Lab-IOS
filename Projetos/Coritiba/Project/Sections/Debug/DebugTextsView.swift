//
//  DebugTextsView.swift
//  
//
//  Created by Roberto Oliveira on 27/11/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class DebugTextsView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    private let dataSource:[(title:String, item:ProjectInfoManager.TextInfo)] = [
        (title: "Compartilhar Notícia", item: .baixe_agora_o_app),
        (title: "Solicitar Notificações", item: .ativar_notificacoes),
        (title: "Título da Loja", item: .loja_titulo),
        (title: "Subtítulo da Loja", item: .loja_subtitulo),
        (title: "Rodapé da Loja", item: .loja_rodape),
        (title: "Bem Vindo", item: .ola_clube),
        (title: "Compartilhar Campinho", item: .faca_o_seu_no_app_oficial),
    ]
    private let itemSize:CGFloat = 250
    
    
    // MARK: - Objects
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 16)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Textos Personalizados"
        return lbl
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(DebugTextItemCell.self, forCellWithReuseIdentifier: "DebugTextItemCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    
    
    // MARK: - CollectionView Methods
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // --
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.itemSize, height: self.itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 15, height: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 15, height: 15)
    }
    
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DebugTextItemCell", for: indexPath) as! DebugTextItemCell
        let item = self.dataSource[indexPath.item]
        cell.updateContent(title: item.title, info: item.item.rawValue)
        return cell
    }
    
    
    
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Title
        self.addSubview(self.lblTitle)
        self.lblTitle.addHeightConstraint(25)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 22, trailing: nil, top: 12, bottom: nil)
        // Collection
        self.addSubview(self.collectionView)
        self.collectionView.addHeightConstraint(self.itemSize)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.collectionView, constant: 5)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: -10)
        
        
        // This is a Switch just to force an error if a new Info Text is added to the project
        guard let first = self.dataSource.first else {return}
        switch first.item {
            case .baixe_agora_o_app: break
            case .ativar_notificacoes: break
            case .loja_titulo: break
            case .loja_subtitulo: break
            case .loja_rodape: break
            case .ola_clube: break
            case .faca_o_seu_no_app_oficial: break
        }
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









class DebugTextItemCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var isCopyAlertVisible:Bool = false
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        vw.layer.borderWidth = 2.0
        vw.layer.borderColor = Theme.color(.PrimaryCardBackground).cgColor
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.backgroundColor = Theme.color(.PrimaryCardBackground)
        return lbl
    }()
    private let lblInfo:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(title:String, info:String) {
        self.lblTitle.text = title
        self.lblInfo.text = info
    }
    
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        // Back View
        self.addSubview(self.backView)
        self.addFullBoundsConstraintsTo(subView: self.backView, constant: 5)
        // Title
        self.backView.addSubview(self.lblTitle)
        self.lblTitle.addHeightConstraint(25)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Info
        self.backView.addSubview(self.lblInfo)
        self.backView.addBoundsConstraintsTo(subView: self.lblInfo, leading: 20, trailing: -20, top: 20, bottom: nil)
        self.backView.addVerticalSpacingTo(subView1: self.lblInfo, subView2: self.lblTitle, constant: 20)
        
        self.lblInfo.isUserInteractionEnabled = true
        self.lblInfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.labelAction)))
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.labelAction))
        gesture.minimumPressDuration = 1.0
        self.lblInfo.addGestureRecognizer(gesture)
    }
    
    
    @objc func labelAction() {
        guard !self.isCopyAlertVisible else {return}
        self.isCopyAlertVisible = true
        DispatchQueue.main.async {
            let txt = self.lblInfo.text ?? ""
            UIApplication.topViewController()?.actionAlert(title: txt, items: ["Copiar"], senderView: self.lblTitle, handler: { (title:String?, index:Int?) in
                self.isCopyAlertVisible = false
                DispatchQueue.main.async {
                    if index == 0 {
                        UIPasteboard.general.string = txt
                        UIApplication.topViewController()?.statusAlert(message: "Copiado!", style: .Positive)
                    }
                }
            })
        }
    }
    
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}



