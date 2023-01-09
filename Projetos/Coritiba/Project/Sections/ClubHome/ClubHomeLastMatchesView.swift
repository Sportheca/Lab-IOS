//
//  ClubHomeLastMatchesView.swift
//  
//
//  Created by Roberto Oliveira on 13/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

struct ClubHomeLastMatchItem {
    var id:Int
    var date:Date
    var subtitle:String
    // club 0
    var color0:UIColor
    var club0Score:Int
    var club0ImageUrl:String?
    var penaltiesScore0:Int?
    // club 1
    var color1:UIColor
    var club1Score:Int
    var club1ImageUrl:String?
    var penaltiesScore1:Int?
}

protocol ClubHomeLastMatchesViewDelegate:AnyObject {
    func clubHomeLastMatchesView(clubHomeLastMatchesView:ClubHomeLastMatchesView, didSelectItem item:ClubHomeLastMatchItem)
}

class ClubHomeLastMatchesView: UIView {
    
    // MARK: - Properties
    weak var delegate:ClubHomeLastMatchesViewDelegate?
    var dataSource:[ClubHomeLastMatchItem] = []
    
    
    // MARK: - Objects
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Últimos Resultados".uppercased()
        return lbl
    }()
    let loadingView:ContentLoadingView = ContentLoadingView()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(ClubHomeLastMatchItemCell.self, forCellWithReuseIdentifier: "ClubHomeLastMatchItemCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    
    // MARK: - Methods
    func updateContent(items:[ClubHomeLastMatchItem]) {
        self.dataSource.removeAll()
        self.dataSource = items
        self.collectionView.reloadData()
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 20, trailing: -20, top: 12, bottom: nil)
        self.addSubview(self.collectionView)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.collectionView, constant: 5)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: -15)
        self.collectionView.addHeightConstraint(100)
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

extension ClubHomeLastMatchesView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.clubHomeLastMatchesView(clubHomeLastMatchesView: self, didSelectItem: self.dataSource[indexPath.item])
    }
    
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
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 245, height: 81)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClubHomeLastMatchItemCell", for: indexPath) as! ClubHomeLastMatchItemCell
        cell.updateContent(item: self.dataSource[indexPath.item])
        return cell
    }
    
}



class ClubHomeLastMatchItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 20.0
        return vw
    }()
    private let colorView0:UIView = UIView()
    private let colorView1:UIView = UIView()
    private let lblX:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        return lbl
    }()
    private let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 10)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    private let lblFooter:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 10)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    private let ivCover0:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblScore0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 24)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let ivCover1:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblScore1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 24)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(item:ClubHomeLastMatchItem) {
        self.colorView0.backgroundColor = item.color0
        self.colorView1.backgroundColor = item.color1
        
        let day = item.date.stringWith(format: "dd")
        let month = item.date.monthDescription(short: true)
        let hour = item.date.stringWith(format: "HH:mm")
        let dateString = day + " de " + month + ", " + hour
        self.lblHeader.text = dateString
        self.lblFooter.text = item.subtitle
        self.lblScore0.text = item.club0Score.descriptionWithThousandsSeparator()
        self.lblScore1.text = item.club1Score.descriptionWithThousandsSeparator()
        self.ivCover0.setServerImage(urlString: item.club0ImageUrl)
        self.ivCover1.setServerImage(urlString: item.club1ImageUrl)
        
        guard let p0 = item.penaltiesScore0, let p1 = item.penaltiesScore1 else {
            self.lblX.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 24)
            self.lblX.textColor = Theme.color(.MutedText)
            self.lblX.text = "x"
            return
        }
        self.lblX.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 13)
        self.lblX.textColor = Theme.color(.PrimaryText)
        self.lblX.text = "(\(p0.description) x \(p1.description))"
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.backView)
        self.addFullBoundsConstraintsTo(subView: self.backView, constant: 0)
        self.backView.addSubview(self.colorView0)
        self.backView.addBoundsConstraintsTo(subView: self.colorView0, leading: 0, trailing: nil, top: 0, bottom: 0)
        self.colorView0.addWidthConstraint(10)
        self.backView.addSubview(self.colorView1)
        self.backView.addBoundsConstraintsTo(subView: self.colorView1, leading: nil, trailing: 0, top: 0, bottom: 0)
        self.colorView1.addWidthConstraint(10)
        // X
        self.addSubview(self.lblX)
        self.addCenterXAlignmentConstraintTo(subView: self.lblX, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.lblX, constant: 0)
        // Header
        self.addSubview(self.lblHeader)
        self.addBoundsConstraintsTo(subView: self.lblHeader, leading: 10, trailing: -10, top: 2, bottom: nil)
        // Footer
        self.addSubview(self.lblFooter)
        self.addBoundsConstraintsTo(subView: self.lblFooter, leading: 10, trailing: -10, top: nil, bottom: -2)
        // Score 0
        self.addSubview(self.lblScore0)
        self.addHorizontalSpacingTo(subView1: self.lblScore0, subView2: self.lblX, constant: 20)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.lblScore0, reference: self.lblX, constant: 0)
        // Score 1
        self.addSubview(self.lblScore1)
        self.addHorizontalSpacingTo(subView1: self.lblX, subView2: self.lblScore1, constant: 20)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.lblScore1, reference: self.lblX, constant: 0)
        // Cover 0
        self.addSubview(self.ivCover0)
        self.ivCover0.addWidthConstraint(44)
        self.ivCover0.addHeightConstraint(44)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.ivCover0, reference: self.lblX, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.ivCover0, subView2: self.lblScore0, constant: 15)
        // Cover 1
        self.addSubview(self.ivCover1)
        self.ivCover1.addWidthConstraint(44)
        self.ivCover1.addHeightConstraint(44)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.ivCover1, reference: self.lblX, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.lblScore1, subView2: self.ivCover1, constant: 15)
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
