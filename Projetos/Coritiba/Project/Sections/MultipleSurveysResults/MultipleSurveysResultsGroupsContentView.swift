//
//  MultipleSurveysResultsGroupsContentView.swift
//  
//
//  Created by Roberto Oliveira on 3/17/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol MultipleSurveysResultsGroupsContentViewDelegate:AnyObject {
    func multipleSurveysResultsGroupsContentView(multipleSurveysResultsGroupsContentView:MultipleSurveysResultsGroupsContentView, didSelectGroup group:MultipleSurveysResultsGroup)
}


class MultipleSurveysResultsGroupsContentView: PaginationContentView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    weak var delegate:MultipleSurveysResultsGroupsContentViewDelegate?
    
    // MARK: - Objects
    let loadingView:ContentLoadingView = ContentLoadingView()
    
    
    
    // MARK: - Methods
    // Layout
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                collectionView.cellForItem(at: indexPath)?.scaleTo(0.95)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                collectionView.cellForItem(at: indexPath)?.scaleTo(nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: MultipleSurveysResultsGroupItemCell.defaultHeight)
    }
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource[indexPath.item] as? MultipleSurveysResultsGroup else {return}
        self.delegate?.multipleSurveysResultsGroupsContentView(multipleSurveysResultsGroupsContentView: self, didSelectGroup: item)
    }
    
    
    
    // Layout
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
        self.handlePagination(indexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultipleSurveysResultsGroupItemCell", for: indexPath) as! MultipleSurveysResultsGroupItemCell
        guard let item = self.dataSource[indexPath.item] as? MultipleSurveysResultsGroup else {return cell}
        cell.updateContent(item: item)
        return cell
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.refreshControl.tintColor = Theme.color(.PrimaryAnchor)
        self.backgroundColor = UIColor.clear
        self.collectionView.register(MultipleSurveysResultsGroupItemCell.self, forCellWithReuseIdentifier: "MultipleSurveysResultsGroupItemCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: -50)
    }
    
}





class MultipleSurveysResultsGroupItemCell: UICollectionViewCell {
    
    static let defaultHeight:CGFloat = 150.0
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.layer.cornerRadius = 25.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 16)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let lblFooter:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 10)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.text = "TOQUE PARA VER DETALHES"
        return lbl
    }()
    private let lblX:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        return lbl
    }()
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
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let lblScore0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 21)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
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
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let lblScore1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 21)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let lblCorrectAnswersTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.text = "Acertos"
        return lbl
    }()
    private let lblCorrectAnswers:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let lblCoins:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 18)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let ivCoin:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icon_coin")
        return iv
    }()
    
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(item:MultipleSurveysResultsGroup) {
        self.lblTitle.text = item.title
        self.lblSubtitle.text = item.subtitle
        let coinsPrefix:String = item.coins > 0 ? "+" : ""
        self.lblCoins.text = coinsPrefix + item.coins.descriptionWithThousandsSeparator()
        self.lblTitle0.text = item.club0.title
        self.lblTitle1.text = item.club1.title
        self.lblScore0.text = item.club0.goals.descriptionWithThousandsSeparator()
        self.lblScore1.text = item.club1.goals.descriptionWithThousandsSeparator()
        self.ivCover0.setServerImage(urlString: item.club0.imageUrl)
        self.ivCover1.setServerImage(urlString: item.club1.imageUrl)
        self.lblCorrectAnswers.text = item.correctAnswers.descriptionWithThousandsSeparator()
        
        guard let p0 = item.club0.penaltyGoals, let p1 = item.club1.penaltyGoals else {
            self.lblX.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 24)
            self.lblX.textColor = Theme.color(.MutedText)
            self.lblX.text = "x"
            return
        }
        self.lblX.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 16)
        self.lblX.textColor = Theme.color(.PrimaryCardElements)
        self.lblX.text = "(\(p0.description) x \(p1.description))"
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: nil, trailing: nil, top: 5, bottom: -5)
        self.addCenterXAlignmentConstraintTo(subView: self.backView, constant: 0)
        self.backView.addWidthConstraint(constant: 450, relatedBy: .lessThanOrEqual, priority: 999)
        self.addLeadingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: 10, priority: 750)
        self.addTrailingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: -10, priority: 750)
        // Title
        self.backView.addSubview(self.lblTitle)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 17, trailing: nil, top: 14, bottom: nil)
        // Subtitle
        self.backView.addSubview(self.lblSubtitle)
        self.backView.addBoundsConstraintsTo(subView: self.lblSubtitle, leading: nil, trailing: -17, top: 14, bottom: nil)
        self.backView.addHorizontalSpacingTo(subView1: self.lblTitle, subView2: self.lblSubtitle, relatedBy: .greaterThanOrEqual, constant: 5.0, priority: 999)
        
        
        // X
        self.backView.addSubview(self.lblX)
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
        self.ivCover0.addWidthConstraint(39)
        self.ivCover0.addHeightConstraint(39)
        self.backView.addCenterYAlignmentRelatedConstraintTo(subView: self.ivCover0, reference: self.lblX, constant: 0)
        self.backView.addHorizontalSpacingTo(subView1: self.ivCover0, subView2: self.lblScore0, constant: 15)
        self.backView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.ivCover0, constant: 9)
        self.backView.addLeadingAlignmentConstraintTo(subView: self.ivCover0, constant: 20)
        // Title 0
        self.backView.addSubview(self.lblTitle0)
        self.addCenterXAlignmentRelatedConstraintTo(subView: self.lblTitle0, reference: self.ivCover0, constant: 0)
        self.addVerticalSpacingTo(subView1: self.ivCover0, subView2: self.lblTitle0, constant: 4)
        // Cover 1
        self.backView.addSubview(self.ivCover1)
        self.ivCover1.addWidthConstraint(39)
        self.ivCover1.addHeightConstraint(39)
        self.backView.addCenterYAlignmentRelatedConstraintTo(subView: self.ivCover1, reference: self.lblX, constant: 0)
        self.backView.addHorizontalSpacingTo(subView1: self.lblScore1, subView2: self.ivCover1, constant: 15)
        // Title 1
        self.backView.addSubview(self.lblTitle1)
        self.addCenterXAlignmentRelatedConstraintTo(subView: self.lblTitle1, reference: self.ivCover1, constant: 0)
        self.addVerticalSpacingTo(subView1: self.ivCover1, subView2: self.lblTitle1, constant: 4)
        // Correct Answers Title
        self.backView.addSubview(self.lblCorrectAnswersTitle)
        self.backView.addVerticalSpacingTo(subView1: self.lblSubtitle, subView2: self.lblCorrectAnswersTitle, constant: 4)
        self.backView.addTrailingAlignmentConstraintTo(subView: self.lblCorrectAnswersTitle, constant: -17)
        // Correct Answers
        self.backView.addSubview(self.lblCorrectAnswers)
        self.backView.addVerticalSpacingTo(subView1: self.lblCorrectAnswersTitle, subView2: self.lblCorrectAnswers, constant: 0)
        self.backView.addTrailingAlignmentRelatedConstraintTo(subView: self.lblCorrectAnswers, reference: self.lblCorrectAnswersTitle, constant: 0)
        // Coins
        self.backView.addSubview(self.ivCoin)
        self.ivCoin.addWidthConstraint(18)
        self.ivCoin.addHeightConstraint(18)
        self.backView.addTrailingAlignmentRelatedConstraintTo(subView: self.ivCoin, reference: self.lblCorrectAnswers, constant: 0)
        self.backView.addVerticalSpacingTo(subView1: self.lblCorrectAnswers, subView2: self.ivCoin, constant: 6)
        self.backView.addSubview(self.lblCoins)
        self.backView.addHorizontalSpacingTo(subView1: self.lblCoins, subView2: self.ivCoin, constant: 4)
        self.backView.addCenterYAlignmentRelatedConstraintTo(subView: self.lblCoins, reference: self.ivCoin, constant: 0)
        // Footer
        self.backView.addSubview(self.lblFooter)
        self.backView.addBoundsConstraintsTo(subView: self.lblFooter, leading: 10, trailing: -10, top: nil, bottom: -6)
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

