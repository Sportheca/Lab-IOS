//
//  HomeExpandedBannersView.swift
//
//  Created by Jhonathan Mattos on 06/04/22.
//  Copyright © 2022 Roberto Oliveira. All rights reserved.
//

import UIKit

class HomeExpandedBannersView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
        // MARK: - Properties
        weak var delegate:HomeBannersViewDelegate?
        var dataSource:[AllNewsItem] = []
        
        
        
        // MARK: - Objects
        let loadingView:ContentLoadingView = ContentLoadingView()
        private let pageControl:CustomPageControl = CustomPageControl()
        private let collectionContainerView:UIView = {
            let vw = UIView()
            vw.backgroundColor = UIColor.clear
            return vw
        }()
        private lazy var collectionView:UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            cv.showsVerticalScrollIndicator = false
            cv.showsHorizontalScrollIndicator = false
            cv.backgroundColor = UIColor.clear
            cv.register(HomeNewsBannersItemCell.self, forCellWithReuseIdentifier: "HomeNewsBannersItemCell")
            cv.dataSource = self
            cv.delegate = self
            cv.isPagingEnabled = true
            return cv
        }()
        
        
        
        
        
        
        // MARK: - Content Methods
        func updateContent(items:[AllNewsItem]) {
            self.dataSource.removeAll()
            self.dataSource = items
            DispatchQueue.main.async {
                self.updateContentHeight()
                self.collectionView.reloadData()
                self.pageControl.updateContent(totalItems: items.count, currentIndex: 0)
                self.pageControl.alpha = items.count > 1 ? 1.0 : 0.0
            }
        }
        
        private func updateContentHeight() {
            self.collectionView.removeFromSuperview()
            self.collectionContainerView.addSubview(self.collectionView)
            self.collectionContainerView.addFullBoundsConstraintsTo(subView: self.collectionView, constant: 0)
            let statusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.height
            let topSpace:CGFloat = statusBarHeight + (UserHeaderView.avatarButtonSize/2) + 3
            let tabBarHeight:CGFloat = UIApplication.topViewController()?.tabBarController?.tabBar.frame.height ?? 0
            let cardHeight:CGFloat = UIScreen.main.bounds.height - topSpace - tabBarHeight
            self.collectionView.addHeightConstraint(cardHeight)
        }
        
        @objc func allAction() {
            self.delegate?.didSelectAllBanners()
        }
        
        
        
        
        
        // MARK: - CollectionView Methods
        // Delegate
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            self.delegate?.didSelectBanner(item: self.dataSource[indexPath.item])
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let page:CGFloat = (scrollView.bounds.width == 0) ? 0 : scrollView.contentOffset.x / scrollView.bounds.width
            let index = Int(page)
            self.pageControl.updateContent(totalItems: self.dataSource.count, currentIndex: index)
        }
        
        // Layout
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return collectionView.frame.size
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeNewsBannersItemCell", for: indexPath) as! HomeNewsBannersItemCell
            let item = self.dataSource[indexPath.item]
            cell.updateContent(item: item)
            return cell
        }
        
        
        
        
        
        
        
        
        // MARK: - Init Methods
        private func prepareElements() {
            self.backgroundColor = UIColor.clear
            // Collection
            self.addSubview(self.collectionContainerView)
            self.addBoundsConstraintsTo(subView: self.collectionContainerView, leading: 0, trailing: 0, top: 0, bottom: -10)
            self.updateContentHeight()
            // Page Control
            self.addSubview(self.pageControl)
            self.addCenterXAlignmentConstraintTo(subView: self.pageControl, constant: 0)
            self.addBottomAlignmentRelatedConstraintTo(subView: self.pageControl, reference: self.collectionContainerView, constant: -25)
            // Loading
            self.addSubview(self.loadingView)
            self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
            self.addCenterYAlignmentRelatedConstraintTo(subView: self.loadingView, reference: self.collectionContainerView, constant: 0)
            
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









    class HomeNewsBannersItemCell: UICollectionViewCell {
        
        // MARK: - Objects
        private let containerView:UIView = {
            let vw = UIView()
            vw.backgroundColor = UIColor.clear
            return vw
        }()
        private let backView:UIView = {
            let vw = UIView()
            vw.backgroundColor = UIColor.clear
            vw.layer.cornerRadius = 0.0
            vw.clipsToBounds = true
            return vw
        }()
        private let ivCover:ServerImageView = {
            let iv = ServerImageView()
            iv.backgroundColor = Theme.color(.MutedText)
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            return iv
        }()
        private let fadeView:TransparentGradientView = {
            let vw = TransparentGradientView()
            vw.backgroundColor = UIColor.black
            vw.updateGradient(references: [
                GradientReference(location: 0, transparent: true),
                GradientReference(location: 1, transparent: false),
            ])
            vw.updateGradient(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 1))
            return vw
        }()
        private let stackView:UIStackView = {
            let vw = UIStackView()
            vw.axis = .vertical
            vw.alignment = .fill
            vw.distribution = .fill
            vw.spacing = 10.0
            return vw
        }()
        private let lblDate:UILabel = {
            let lbl = UILabel()
            lbl.numberOfLines = 1
            lbl.textAlignment = .left
            lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
            lbl.textColor = Theme.color(.PrimaryAnchor)
            return lbl
        }()
        private let lblTitle:RootLabel = {
            let lbl = RootLabel()
            lbl.topInset = 20.0
            lbl.numberOfLines = 4
            lbl.textAlignment = .left
            lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 45)
            lbl.textColor = UIColor.white
            lbl.adjustsFontSizeToFitWidth = true
            lbl.minimumScaleFactor = 0.3
            return lbl
        }()
        private let lblSubtitle:UILabel = {
            let lbl = UILabel()
            lbl.numberOfLines = 2
            lbl.textAlignment = .left
            lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 14)
            lbl.textColor = UIColor(hexString: "F4F5F7")
            return lbl
        }()
        private let tagBackView:UIView = {
            let vw = UIView()
            vw.backgroundColor = Theme.color(.PrimaryButtonBackground)
            vw.layer.cornerRadius = 25/2
            return vw
        }()
        private let lblTag:UILabel = {
            let lbl = UILabel()
            lbl.numberOfLines = 2
            lbl.textAlignment = .left
            lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
            lbl.textColor = Theme.color(.PrimaryButtonText)
            return lbl
        }()
        private let ivVideo:UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named: "icon_news_video")
            iv.contentMode = .scaleAspectFit
            iv.backgroundColor = UIColor.clear
            return iv
        }()
        
        
        
        
        
        
        // MARK: - Methods
        func updateContent(item:AllNewsItem) {
            // Cover
            self.ivCover.setServerImage(urlString: item.imageUrl)
            self.lblTitle.text = item.title?.uppercased()
            self.lblSubtitle.text = item.subtitle
            self.lblSubtitle.setSpaceBetweenLines(space: 0)
            self.lblTag.text = item.category
            self.tagBackView.isHidden = (item.category ?? "") == ""
            var dateDescription:String = ""
            if let value = item.date {
                dateDescription = value.stringWith(format: "dd") + " de " + value.monthDescription(short: false)
            }
            self.lblDate.text = dateDescription
//            self.ivVideo.isHidden = item.mode != .Video
            
        }
        
        
        private func prepareElements() {
            self.backgroundColor = UIColor.clear
            // Container
            self.addSubview(self.containerView)
            self.addBoundsConstraintsTo(subView: self.containerView, leading: 0, trailing: 0, top: 0, bottom: 0)
            self.containerView.addSubview(self.backView)
            self.containerView.addBoundsConstraintsTo(subView: self.backView, leading: 0, trailing: 0, top: 0, bottom: 0)
            // Cover
            self.backView.addSubview(self.ivCover)
            self.backView.addBoundsConstraintsTo(subView: self.ivCover, leading: 0, trailing: 0, top: 0, bottom: 0)
            // gradient
            self.backView.addSubview(self.fadeView)
            self.backView.addBoundsConstraintsTo(subView: self.fadeView, leading: 0, trailing: 0, top: 150, bottom: 0)
            // Date
            self.backView.addSubview(self.stackView)
            self.backView.addBoundsConstraintsTo(subView: self.stackView, leading: 20, trailing: -20, top: nil, bottom: -40)
            // title
            self.stackView.addArrangedSubview(self.lblTitle)
            // subtitle
            self.stackView.addArrangedSubview(self.lblSubtitle)
            // Video
            self.addSubview(self.ivVideo)
            self.addLeadingAlignmentRelatedConstraintTo(subView: self.ivVideo, reference: self.lblTitle, constant: 0)
            self.addVerticalSpacingTo(subView1: self.ivVideo, subView2: self.lblTitle, constant: 17)
            self.ivVideo.addSquareSizeConstraint(51)
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
