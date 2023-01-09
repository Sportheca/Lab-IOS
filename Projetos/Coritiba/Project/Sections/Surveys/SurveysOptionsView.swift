//
//  SurveysOptionsView.swift
//  
//
//  Created by Roberto Oliveira on 12/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class SurveysOptionsView: UIView {
    
    // MARK: - Properties
    private var currentQuestion:SurveyQuestion?
    
    
    
    // MARK: - Objects
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(SurveysOptionCell.self, forCellWithReuseIdentifier: "SurveysOptionCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    // MARK: - Methods
    func updateContent(item:SurveyQuestion) {
        DispatchQueue.main.async {
            self.currentQuestion = item
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.collectionView)
        self.addCenterXAlignmentConstraintTo(subView: self.collectionView, constant: 0)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: nil, trailing: nil, top: 0, bottom: 0)
        self.collectionView.addWidthConstraint(255)
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


extension SurveysOptionsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let question = self.currentQuestion else {return}
        ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
            guard confirmed else {return}
            question.selectedOptionID = question.options[indexPath.item].id
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            NotificationCenter.default.post(name: NSNotification.Name(SurveysViewController.answerNotificationName), object: nil)
        }
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
        guard let question = self.currentQuestion else {return CGSize.zero}
        
        if (UIScreen.main.bounds.height < 667) {
            let height:CGFloat = question.options.count > 4 ? 35 : 38
            return CGSize(width: collectionView.bounds.width, height: height)
        } else {
            let height:CGFloat = question.options.count > 4 ? 38 : 40
            return CGSize(width: collectionView.bounds.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let question = self.currentQuestion else {return 0}
        
        if (UIScreen.main.bounds.height < 667) {
            return question.options.count > 4 ? 5 : 8
        } else {
            return question.options.count > 4 ? 8 : 20
        }
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
        guard let question = self.currentQuestion else {return 0}
        return question.options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurveysOptionCell", for: indexPath) as! SurveysOptionCell
        guard let question = self.currentQuestion else {return cell}
        let item = question.options[indexPath.item]
        var progress:Float?
        if let selected = question.selectedOptionID {
            if question.showAnswersPercentage {
                progress = question.answerPercentageAt(index: indexPath.item, selectedId: selected)
            } else {
                cell.highlight(selected: selected == item.id)
                cell.updateContent(title: item.title, progress: nil)
                return cell
            }
        }
        cell.highlight(selected: false)
        cell.updateContent(title: item.title, progress: progress)
        return cell
    }
    
}






class SurveysOptionCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.SurveyOptionBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 10.0
        return vw
    }()
    private var progressWidthConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private let progressView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.SurveyOptionProgress)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 10.0
        return vw
    }()
    private let lblTitle0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = Theme.color(.SurveyOptionText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    private let lblProgress0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = Theme.color(.SurveyOptionText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    private let lblTitle1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = Theme.color(.SurveyOptionText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    private let lblProgress1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = Theme.color(.SurveyOptionText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    
    
    // MARK: - Methods
    func updateContent(title:String, progress:Float?) {
        self.lblTitle0.text = title
        self.lblTitle1.text = title
        self.removeConstraint(self.progressWidthConstraint)
        var txt:String = ""
        if let value = progress {
//            txt = "\(Int(value*100))%"
            txt = "\(Float(value*100).formattedDescription(places: 2, grouping: "", decimal: ","))%"
            self.progressWidthConstraint = NSLayoutConstraint(item: self.progressView, attribute: .width, relatedBy: .equal, toItem: self.backView, attribute: .width, multiplier: CGFloat(value), constant: 0)
            self.addConstraint(self.progressWidthConstraint)
            UIView.animate(withDuration: 0.7) {
                self.layoutIfNeeded()
            }
        }
        self.lblProgress0.text = txt
        self.lblProgress1.text = txt
    }
    
    func highlight(selected:Bool) {
        self.backView.backgroundColor = selected ? Theme.color(.SurveyOptionProgress) : Theme.color(.SurveyOptionBackground)
        self.lblTitle0.textColor = selected ? Theme.color(.SurveyOptionText) : Theme.color(.SurveyOptionText)
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.backView)
        self.addFullBoundsConstraintsTo(subView: self.backView, constant: 0)
        // title 0
        self.backView.addSubview(self.lblTitle0)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle0, leading: 40, trailing: -40, top: 0, bottom: 0)
        // progress 0
        self.backView.addSubview(self.lblProgress0)
        self.addBoundsConstraintsTo(subView: self.lblProgress0, leading: nil, trailing: 0, top: 0, bottom: 0)
        self.lblProgress0.addWidthConstraint(38)
        // progress
        self.backView.addSubview(self.progressView)
        self.addBoundsConstraintsTo(subView: self.progressView, leading: 0, trailing: nil, top: 0, bottom: 0)
        self.progressView.addWidthConstraint(constant: 0, relatedBy: .equal, priority: 500)
        // title 1
        self.progressView.addSubview(self.lblTitle1)
        self.addCenterXAlignmentRelatedConstraintTo(subView: self.lblTitle1, reference: self.lblTitle0, constant: 0)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.lblTitle1, reference: self.lblTitle0, constant: 0)
        self.addHeightRelatedConstraintTo(subView: self.lblTitle1, reference: self.lblTitle0)
        self.addWidthRelatedConstraintTo(subView: self.lblTitle1, reference: self.lblTitle0)
        // progress 1
        self.progressView.addSubview(self.lblProgress1)
        self.addCenterXAlignmentRelatedConstraintTo(subView: self.lblProgress1, reference: self.lblProgress0, constant: 0)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.lblProgress1, reference: self.lblProgress0, constant: 0)
        self.addHeightRelatedConstraintTo(subView: self.lblProgress1, reference: self.lblProgress0)
        self.addWidthRelatedConstraintTo(subView: self.lblProgress1, reference: self.lblProgress0)
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
