//
//  PaginationContentView.swift
//  
//
//  Created by Roberto Oliveira on 07/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol PaginationContentViewDelegate:AnyObject {
    func loadNexPage()
    func didPullToReload()
}

class PaginationContentView: UIView {
    
    // MARK: - Properties
    weak var paginationDelegate:PaginationContentViewDelegate?
    var dataSource:[Any] = []
    
    
    
    
    // MARK: - Pagination
    var itemsBeforeNextPage = 30
    var pageInterval:Int = 100
    var currentPage:Int = 1
    
    
    // MARK: - Refresh
    private var refreshRequired:Bool = false
    private var isDragging:Bool = false {
        didSet {
            if self.refreshRequired {
                self.didPullToRefresh()
                self.refreshRequired = false
            }
        }
    }
    
    
    
    
    // MARK: - Objects
    lazy var refreshControl:CustomRefreshControl = {
        let vw = CustomRefreshControl()
        vw.addTarget(self, action: #selector(self.requestRefresh), for: .valueChanged)
        return vw
    }()
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    
    
    
    // MARK: - Methods
    func updateContent(items: [Any], limit:Int?, margin:Int?) {
        self.pageInterval = limit ?? self.pageInterval
        self.itemsBeforeNextPage = margin ?? self.itemsBeforeNextPage
        self.dataSource.removeAll()
        self.dataSource = items
        self.currentPage = 1
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func addContent(items: [Any]) {
        if self.dataSource.isEmpty {
            self.dataSource = items
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            var indexPaths:[IndexPath] = []
            for item in items {
                indexPaths.append(IndexPath(item: self.dataSource.count-1, section: 0))
                self.dataSource.append(item)
            }
            DispatchQueue.main.async {
//                self.collectionView.insertItems(at: indexPaths)
                self.collectionView.reloadData()
            }
        }
    }
    
    func handlePagination(indexPath:IndexPath) {
        let i = (((self.currentPage*self.pageInterval)-self.itemsBeforeNextPage)-1)
        if indexPath.item == i {
            // If it is x items from the end, load next pagination block
            self.currentPage += 1
            self.paginationDelegate?.loadNexPage()
        }
    }
    
    
    
    
    
    // MARK: - Refresh Control Methods
    @objc func requestRefresh() {
        self.refreshRequired = true
    }
    
    @objc func didPullToRefresh() {
        self.dataSource.removeAll()
        self.collectionView.reloadData()
        self.currentPage = 1
        self.paginationDelegate?.didPullToReload()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isDragging = false
    }
    
    @objc func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isDragging = true
    }
    
    
    
    
    // MARK: - Init Methods
    func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Collections
        self.addSubview(self.collectionView)
        self.collectionView.addSubview(self.refreshControl)
        self.addFullBoundsConstraintsTo(subView: self.collectionView, constant: 0)
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

