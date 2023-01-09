//
//  QuizGroupsContentView.swift
//  
//
//  Created by Roberto Oliveira on 07/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol QuizGroupsContentViewDelegate:AnyObject {
    func quizGroupsContentView(quizGroupsContentView:QuizGroupsContentView, didSelectGroup group:QuizGroup, atIndexPath indexPath:IndexPath)
}

class QuizGroupsContentView: PaginationContentView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    weak var delegate:QuizGroupsContentViewDelegate?
    
    
    
    // MARK: - Methods
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource[indexPath.item] as? QuizGroup else {return}
        self.delegate?.quizGroupsContentView(quizGroupsContentView: self, didSelectGroup: item, atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                collectionView.cellForItem(at: indexPath)?.alpha = 0.7
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                collectionView.cellForItem(at: indexPath)?.alpha = 1.0
            }
        }
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
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
        self.handlePagination(indexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizGroupItemCell", for: indexPath) as! QuizGroupItemCell
        guard let item = self.dataSource[indexPath.item] as? QuizGroup else {return cell}
        cell.updateContent(item: item, colorScheme: ColorScheme.schemeAt(index: indexPath.item))
        return cell
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.refreshControl.tintColor = Theme.color(.PrimaryAnchor)
        self.backgroundColor = UIColor.clear
        self.collectionView.register(QuizGroupItemCell.self, forCellWithReuseIdentifier: "QuizGroupItemCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
}






class QuizGroupItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let ivCover:OverlayImageView = OverlayImageView()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 2.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 22)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 11)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(item:QuizGroup, colorScheme:ColorScheme) {
        self.ivCover.backgroundColor = colorScheme.primaryColor()
        self.ivCover.updateColor(colorScheme.primaryColor())
        self.lblTitle.textColor = colorScheme.elementsColor()
        self.lblSubtitle.textColor = colorScheme.elementsColor()
        
        self.ivCover.setServerImage(urlString: item.imageUrlString)
        self.lblTitle.text = item.title
        var subtitle:String = ""
        
        let answered = item.answeredQuestions ?? 0
        if answered > 0 {
            subtitle = "\(item.correctAnswers.descriptionWithThousandsSeparator())/\(answered.descriptionWithThousandsSeparator())"
        }
        
        self.lblSubtitle.text = subtitle
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.addSubview(self.ivCover)
        self.addFullBoundsConstraintsTo(subView: self.ivCover, constant: 0)
        self.addSubview(self.stackView)
        self.addCenterYAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.addBoundsConstraintsTo(subView: self.stackView, leading: 10, trailing: -10, top: nil, bottom: nil)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.lblSubtitle)
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
