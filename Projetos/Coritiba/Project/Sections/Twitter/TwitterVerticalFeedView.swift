//
//  TwitterVerticalFeedView.swift
//  
//
//  Created by Roberto Oliveira on 11/05/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class TwitterVerticalFeedView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    private var dataSource:[TweetItem] = []
    
    // MARK: - Objects
    private lazy var tableView:UITableView = {
        let tbv = UITableView()
        tbv.register(TwitterVerticalFeedItemCell.self, forCellReuseIdentifier: "TwitterVerticalFeedItemCell")
        tbv.dataSource = self
        tbv.delegate = self
        tbv.separatorStyle = .none
        tbv.showsVerticalScrollIndicator = false
        tbv.backgroundColor = UIColor.clear
        return tbv
    }()
    
    
    
    // MARK: - Methods
    func updateContent(searchString: String) {
        // Load Tweets
        ServerManager.shared.getTweets(search: searchString, limited: false) { (result:[TweetItem]?) in
            self.dataSource.removeAll()
            self.dataSource = result ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    
    
    
    
    // Table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.dataSource.count {
            guard let cell = tableView.cellForRow(at: indexPath) as? TwitterVerticalFeedItemCell else {return}
            DispatchQueue.main.async {
                cell.tweetView.openFullScreen()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10 + 350 + 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterVerticalFeedItemCell", for: indexPath) as! TwitterVerticalFeedItemCell
        cell.tweetView.updateContent(tweet: self.dataSource[indexPath.row])
        return cell
    }
    
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.tableView)
        self.addFullBoundsConstraintsTo(subView: self.tableView, constant: 0)
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







class TwitterVerticalFeedItemCell: UITableViewCell {
    
    // MARK: - Objects
    let tweetView:TweetView = TweetView()
    
    
    // MARK: - Methods
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.addSubview(self.tweetView)
        self.addBoundsConstraintsTo(subView: self.tweetView, leading: nil, trailing: nil, top: 10, bottom: -10)
        self.addCenterXAlignmentConstraintTo(subView: self.tweetView, constant: 0)
        self.addLeadingAlignmentConstraintTo(subView: self.tweetView, relatedBy: .equal, constant: 10, priority: 750)
        self.addTrailingAlignmentConstraintTo(subView: self.tweetView, relatedBy: .equal, constant: -10, priority: 750)
        let width:CGFloat = min(UIScreen.main.bounds.size.width-30, 345)//400
        self.tweetView.addWidthConstraint(constant: width, relatedBy: .lessThanOrEqual, priority: 999)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}
