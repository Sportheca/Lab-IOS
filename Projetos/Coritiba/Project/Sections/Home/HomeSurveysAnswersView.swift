//
//  HomeSurveysAnswersView.swift
//  
//
//  Created by Roberto Oliveira on 27/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

struct HomeSurveysAnswersItem {
    var id:Int
    var imageUrl:String?
    var title:String
    var subtitle:String
    var infos:[HomeSurveysAnswersItemInfo]
}

struct HomeSurveysAnswersItemInfo {
    var id:Int
    var title:String
    var progress:Float
    var isHighlighted:Bool
}

class HomeSurveysAnswersView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    var dataSource:[HomeSurveysAnswersItem] = []
    
    
    // MARK: - Objects
    let loadingView:ContentLoadingView = ContentLoadingView()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "PESQUISAS"
        return lbl
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(HomeSurveysAnswersItemCell.self, forCellWithReuseIdentifier: "HomeSurveysAnswersItemCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    
    // MARK: - Methods
    func updateContent(items:[HomeSurveysAnswersItem]) {
        self.dataSource.removeAll()
        self.dataSource = items
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 315, height: 495)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSurveysAnswersItemCell", for: indexPath) as! HomeSurveysAnswersItemCell
        cell.updateContent(item: self.dataSource[indexPath.item], index: indexPath.item)
        return cell
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 20, trailing: -20, top: 12, bottom: nil)
        self.addSubview(self.collectionView)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.collectionView, constant: 5)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: -15)
        self.collectionView.addHeightConstraint(510)
        // Loading
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.loadingView, reference: self.collectionView, constant: 0)
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




class HomeSurveysAnswersItemCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    private var currentItem:HomeSurveysAnswersItem?
    
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 25.0
        return vw
    }()
    private let ivCover:OverlayImageView = OverlayImageView()
    private let ivShape:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "custom_shape_1")
        iv.alpha = 0.75
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        return iv
    }()
    private let adsView:AdsView = AdsView()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 22)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 4
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 14)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(HomeSurveysAnswersItemInfoCell.self, forCellWithReuseIdentifier: "HomeSurveysAnswersItemInfoCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    // MARK: - Methods
    func updateContent(item:HomeSurveysAnswersItem, index:Int) {
        self.currentItem = item
        // Color scheme
        let scheme:ColorScheme = ColorScheme.schemeAt(index: index)
        let textColor = scheme.elementsColor()
        // Cover
        self.ivCover.updateColor(scheme.primaryColor())
        self.ivCover.setServerImage(urlString: item.imageUrl)
        // Ads
        self.adsView.updateContent(position: AdsPosition.ResultadosDasUltimasPesquisas)
        // Title
        self.lblTitle.textColor = textColor
        self.lblTitle.text = item.title
        // Subtitle
        self.lblSubtitle.textColor = textColor
        self.lblSubtitle.text = item.subtitle
        // infos
        self.collectionView.reloadData()
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
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
        return self.currentItem?.infos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSurveysAnswersItemInfoCell", for: indexPath) as! HomeSurveysAnswersItemInfoCell
        guard let item = self.currentItem else {return cell}
        cell.updateContent(item: item.infos[indexPath.item])
        return cell
    }
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3.0
        self.addSubview(self.backView)
        self.addFullBoundsConstraintsTo(subView: self.backView, constant: 0)
        self.backView.addSubview(self.ivCover)
        self.backView.addFullBoundsConstraintsTo(subView: self.ivCover, constant: 0)
        self.backView.addSubview(self.ivShape)
        self.backView.addConstraint(NSLayoutConstraint(item: self.ivShape, attribute: .height, relatedBy: .equal, toItem: self.backView, attribute: .height, multiplier: 0.45, constant: 0))
        self.backView.addBoundsConstraintsTo(subView: self.ivShape, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Ads
        self.backView.addSubview(self.adsView)
        self.backView.addBoundsConstraintsTo(subView: self.adsView, leading: 10, trailing: -10, top: 10, bottom: nil)
        self.adsView.addHeightConstraint(50)
        // Title
        self.backView.addSubview(self.lblTitle)
        self.backView.addVerticalSpacingTo(subView1: self.adsView, subView2: self.lblTitle, constant: 5)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 8, trailing: -8, top: nil, bottom: nil)
        self.lblTitle.addHeightConstraint(40)
        // Subtitle
        self.backView.addSubview(self.lblSubtitle)
        self.backView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.lblSubtitle, constant: 2)
        self.backView.addBoundsConstraintsTo(subView: self.lblSubtitle, leading: 8, trailing: -8, top: nil, bottom: nil)
        self.lblSubtitle.addHeightConstraint(70)
        // Infos
        self.backView.addSubview(self.collectionView)
        self.backView.addBoundsConstraintsTo(subView: self.collectionView, leading: 30, trailing: -30, top: nil, bottom: 0)
        self.backView.addVerticalSpacingTo(subView1: self.lblSubtitle, subView2: self.collectionView, constant: 20)
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





class HomeSurveysAnswersItemInfoCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.SurveyOptionBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 10.0
        return vw
    }()
    private var progressConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private let progressView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.SurveyOptionProgress)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 10.0
        return vw
    }()
    private let lblTitleBack:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 17)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblProgressBack:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 17)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblTitleFront:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 17)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblProgressFront:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 17)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    
    
    
    // MARK: - Methods
    func updateContent(item:HomeSurveysAnswersItemInfo) {
        var backTextColor = Theme.color(.SurveyOptionText).withAlphaComponent(0.7)
        var frontTextColor = Theme.color(.SurveyOptionText).withAlphaComponent(0.7)
        if item.isHighlighted {
            backTextColor = Theme.color(.SurveyOptionText)
            frontTextColor = Theme.color(.SurveyOptionText)
        }
        // Title
        self.lblTitleBack.textColor = backTextColor
        self.lblTitleFront.textColor = frontTextColor
        self.lblTitleBack.text = item.title
        self.lblTitleFront.text = item.title
        // Progress
        self.lblProgressBack.textColor = backTextColor
        self.lblProgressFront.textColor = frontTextColor
        let progressText = "\(Float(item.progress*100).formattedDescription(places: 2, grouping: "", decimal: ","))%"
        self.lblProgressBack.text = progressText
        self.lblProgressFront.text = progressText
        // Constraint
        self.removeConstraint(self.progressConstraint)
        self.progressConstraint = NSLayoutConstraint(item: self.progressView, attribute: .width, relatedBy: .equal, toItem: self.backView, attribute: .width, multiplier: CGFloat(item.progress), constant: 0)
        self.progressConstraint.priority = UILayoutPriority(999)
        self.addConstraint(self.progressConstraint)
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.backView)
        self.addFullBoundsConstraintsTo(subView: self.backView, constant: 0)
        self.backView.addSubview(self.lblTitleBack)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitleBack, leading: 40, trailing: -40, top: 0, bottom: 0)
        self.backView.addSubview(self.lblProgressBack)
        self.backView.addBoundsConstraintsTo(subView: self.lblProgressBack, leading: nil, trailing: 0, top: 0, bottom: 0)
        self.lblProgressBack.addWidthConstraint(40)
        self.backView.addSubview(self.progressView)
        self.backView.addBoundsConstraintsTo(subView: self.progressView, leading: 0, trailing: nil, top: 0, bottom: 0)
        self.progressConstraint = NSLayoutConstraint(item: self.progressView, attribute: .width, relatedBy: .equal, toItem: self.backView, attribute: .width, multiplier: 1.0, constant: 0)
        self.progressConstraint.priority = UILayoutPriority(999)
        self.addConstraint(self.progressConstraint)
        self.progressView.addSubview(self.lblTitleFront)
        self.addBoundsConstraintsTo(subView: self.lblTitleFront, leading: 40, trailing: -40, top: 0, bottom: 0)
        self.progressView.addSubview(self.lblProgressFront)
        self.addBoundsConstraintsTo(subView: self.lblProgressFront, leading: nil, trailing: 0, top: 0, bottom: 0)
        self.lblProgressFront.addWidthConstraint(40)
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
