//
//  HorizontalSectionsView.swift
//
//
//  Created by Roberto Oliveira on 04/09/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

//---------------------------------------------------------------------
// README:
// HorizontalSectionsView is composed by two main components: HorizontalMenuBar and mainCollectionView
// call "updateContent" to set up dataSource
//---------------------------------------------------------------------

protocol HorizontalSectionsViewDelegate:AnyObject {
    func didSelectTab(at index:Int)
}

// MARK: - HorizontalSectionsView
class HorizontalSectionsView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, HorizontalSelectorDelegate {
    
    // MARK: - Options
    private let horizontalMenuHeight:CGFloat = 40.0
    
    // MARK: - Properties
    private var menuDataSource:[HorizontalSelectorItem] = []
    private var sectionsDataSource:[UIView] = []
    private var fixAtBottom:Bool = true
    weak var delegate:HorizontalSectionsViewDelegate?
    
    
    
    // MARK: - Objects
    let menuBar:HorizontalSelectorBar = HorizontalSelectorBar()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.isPagingEnabled = true
        cv.register(HorizontalSectionsCell.self, forCellWithReuseIdentifier: "HorizontalSectionsCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    
    
    
    
    
    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionsDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalSectionsCell", for: indexPath) as! HorizontalSectionsCell
        let currentView = sectionsDataSource[indexPath.item]
        cell.updateContent(subView: currentView, fixAtBottom: self.fixAtBottom)
        return cell
    }
    
    
    // MARK: - UICollectionView Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.size.width, height: self.frame.size.height-horizontalMenuHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - UIScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let selectedPage = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        if scrollView == self.collectionView {
            self.menuBar.collectionView.selectItem(at: IndexPath(item: selectedPage, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            self.menuBar.selectedIndexPath = IndexPath(item: selectedPage, section: 0)
            self.delegate?.didSelectTab(at: selectedPage)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let selectedPage = Int(targetContentOffset.pointee.x/scrollView.frame.size.width)
        if scrollView == self.collectionView {
            self.menuBar.collectionView.selectItem(at: IndexPath(item: selectedPage, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            self.menuBar.selectedIndexPath = IndexPath(item: selectedPage, section: 0)
            self.menuBar.updateHorizontalBar()
        }
    }
    
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            let pageXPosition:CGFloat = scrollView.frame.width * CGFloat(self.menuBar.selectedIndexPath.item)
            let difference = pageXPosition - scrollView.contentOffset.x
        }
    }*/
    
    
    
    
    // MARK: - HorizontalMenuBarDelegate
    func didSelectItem(with: HorizontalSelectorBar, at indexPath: IndexPath) {
        self.delegate?.didSelectTab(at: indexPath.item)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    
    
    
    // MARK: - Setup Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        
        // Horizontal Menu Bar
        self.addSubview(self.menuBar)
        self.addTopAlignmentConstraintTo(subView: self.menuBar, constant: 0)
        self.addLeadingAlignmentConstraintTo(subView: self.menuBar, constant: 0)
        self.addTrailingAlignmentConstraintTo(subView: self.menuBar, constant: 0)
        self.menuBar.addHeightConstraint(self.horizontalMenuHeight)
        
        self.insertSubview(self.collectionView, belowSubview: self.menuBar)
        self.addBottomAlignmentConstraintTo(subView: self.collectionView, constant: 0)
        self.addLeadingAlignmentConstraintTo(subView: self.collectionView, constant: 0)
        self.addTrailingAlignmentConstraintTo(subView: self.collectionView, constant: 0)
        self.addConstraint(NSLayoutConstraint(item: self.menuBar, attribute: .bottom, relatedBy: .equal, toItem: self.collectionView, attribute: .top, multiplier: 1.0, constant: 0))
    }
    
    func updateContent(menuDataSource:[HorizontalSelectorItem], sectionsDataSource:[UIView], fixAtBottom:Bool) {
        self.fixAtBottom = fixAtBottom
        // Menu Items
        self.menuDataSource.removeAll()
        self.menuDataSource = menuDataSource
        self.menuBar.setDataSource(items: self.menuDataSource, delegate: self)
        
        // Sections
        self.sectionsDataSource = sectionsDataSource
        self.collectionView.reloadData()
    }
    
    
    // MARK: - Init Methods
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
}

class HorizontalSectionsCell: UICollectionViewCell {
    
    // MARK: - Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
    }
    
    func updateContent(subView:UIView, fixAtBottom:Bool) {
        for subView in self.contentView.subviews {
            subView.removeFromSuperview()
        }
        self.contentView.addSubview(subView)
//        self.contentView.addFullBoundsConstraintsTo(subView: subView, constant: 0)
        self.contentView.addBoundsConstraintsTo(subView: subView, leading: 0, trailing: 0, top: 0, bottom: nil)
        if fixAtBottom {
            self.contentView.addBottomAlignmentConstraintTo(subView: subView, constant: 0)
        }
    }
    
    
    // MARK: - Init Methods
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
}





















// MARK: - HorizontalMenuBar
struct HorizontalMenuItem {
    var id:Int
    var title:String
}

protocol HorizontalMenuBarDelegate {
    func didSelectHorizontalMenuItemAt(indexPath: IndexPath)
}

class HorizontalMenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    // MARK: - Options
    let numberOfVisibleItems:CGFloat = 2.7
    private lazy var menuItemsWidth:CGFloat = UIScreen.main.bounds.size.width/self.numberOfVisibleItems
    var activeColor:UIColor = UIColor.black
    var inactiveColor:UIColor = UIColor.lightGray
    
    
    // MARK: - Properties
    private var dataSource:[HorizontalMenuItem] = []
    private var delegate:HorizontalMenuBarDelegate?
    
    
    
    // MARK: - Objects
    fileprivate var horizontalLeftConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private lazy var horizontalBar:UIView = {
        let vw = UIView()
        vw.backgroundColor = self.activeColor
        return vw
    }()
    
    fileprivate lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.allowsMultipleSelection = false
        cv.register(HorizontalMenuBarCell.self, forCellWithReuseIdentifier: "HorizontalMenuBarCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    // MARK: - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectHorizontalMenuItemAt(indexPath: indexPath)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalMenuBarCell", for: indexPath) as! HorizontalMenuBarCell
        let item = self.dataSource[indexPath.row]
        cell.updateContent(title: item.title, activeColor: self.activeColor, inactiveColor: self.inactiveColor)
        return cell
    }
    
    
    // MARK: - UICollectionView Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.menuItemsWidth, height: self.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            self.updateHorizontalBar()
        }
    }
    
    private func updateHorizontalBar() {
        if let selectedIndex = self.collectionView.indexPathsForSelectedItems {
            let firstIndex = selectedIndex[0]
            let itemOffSet = (self.menuItemsWidth)*CGFloat(firstIndex.item)
            self.horizontalLeftConstraint.constant = -(itemOffSet-self.collectionView.contentOffset.x)
            DispatchQueue.main.async {
                self.layoutSubviews()
            }
        }
    }
    
    
    
    // MARK: - Setup Methods
    func setDataSource(items:[HorizontalMenuItem], delegate:HorizontalMenuBarDelegate?) {
        self.dataSource.removeAll()
        self.delegate = delegate
        self.dataSource = items
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if items.count > 0 {
                self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            }
        }
    }
    
    func setColors(activeColor:UIColor, inactiveColor:UIColor) {
        self.horizontalBar.backgroundColor = activeColor
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
    }
    
    private func prepareElements() {
        self.backgroundColor = UIColor.white
        self.addSubview(self.collectionView)
        self.addFullBoundsConstraintsTo(subView: self.collectionView, constant: 0)
        
        self.addSubview(self.horizontalBar)
        self.addBottomAlignmentConstraintTo(subView: self.horizontalBar, constant: 0)
        self.horizontalBar.addWidthConstraint(self.menuItemsWidth)
        self.horizontalBar.addHeightConstraint(2)
        self.horizontalLeftConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.horizontalBar, attribute: .leading, multiplier: 1.0, constant: 0)
        self.addConstraint(self.horizontalLeftConstraint)
    }
    
    
    // MARK: - Init Methods
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}















// MARK: - HorizontalMenuBarCell
class HorizontalMenuBarCell: UICollectionViewCell {
    
    // MARK: - Options
    private var activeColor:UIColor = UIColor.darkGray
    private var inactiveColor:UIColor = UIColor.lightGray
    
    // MARK: - Objects
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.6
        return lbl
    }()
    
    
    
    // MARK: - Highlight Methods
    override var isHighlighted: Bool {
        didSet {
            self.updateHighlightColor()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.updateHighlightColor()
        }
    }
    
    
    
    // MARK: - Methods
    func updateContent(title:String, activeColor:UIColor, inactiveColor:UIColor) {
        self.lblTitle.text = title
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.updateHighlightColor()
    }
    
    private func updateHighlightColor() {
        self.lblTitle.textColor = (self.isSelected || self.isHighlighted) ? self.activeColor : self.inactiveColor
        let fontWeight = (self.isSelected || self.isHighlighted) ? UIFont.Weight.semibold : UIFont.Weight.regular
        self.lblTitle.font = UIFont.systemFont(ofSize: 20, weight: fontWeight)
    }
    
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.lblTitle)
        self.addFullBoundsConstraintsTo(subView: self.lblTitle, constant: 5)
    }
    
    
    
    // MARK: - Super Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
}











