//
//  RankingItemTableViewCell.swift
//  
//
//  Created by Roberto Oliveira on 13/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class RankingItemTableViewCell: UITableViewCell {
    
    // MARK: - Objects
    let itemView:RankingItemView = RankingItemView()
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.addSubview(self.itemView)
        self.itemView.addHeightConstraint(RankingItemView.defaultHeight)
        self.addFullBoundsConstraintsTo(subView: self.itemView, constant: 0)
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






