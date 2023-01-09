//
//  SquadSelectorView.swift
//
//
//  Created by Roberto Oliveira on 04/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

struct SquadSelectorItem {
    var id:Int
    var title:String
    var description:String?
    var imageUrl:String?
}

protocol SquadSelectorViewDelegate:AnyObject {
    func squadSelectorView(squadSelectorView:SquadSelectorView, didRemoveItemAt position:Int)
    func squadSelectorView(squadSelectorView:SquadSelectorView, didSelectAddAt position:Int)
}

class SquadSelectorView: UIView, SquadSelectorItemViewDelegate {
    
    // MARK: - Properties
    weak var delegate:SquadSelectorViewDelegate?
    var isActionAllowed:Bool = false
    //    private let itemSize:CGFloat = (UIScreen.main.bounds.height < 667) ? 34.0 : 50.0
    private let itemSize:CGFloat = {
        //        iPhone SE: 375.0 x 667.0
        //        iPhone 8: 375.0 x 667.0
        //        iPhone 13 mini: 375.0 x 812.0
        //        iPhone 13: 390.0 x 844.0
        //        iPhone 13 pro: 390.0 x 844.0
        //        iPhone 13 pro max: 428.0 x 926.0
        
        let deviceWidth = UIScreen.main.bounds.width
        if deviceWidth <= 320 {
            return 40.0
        }
        if deviceWidth <= 375 {
            return 55.0
        }
        if deviceWidth < 400 {
            return 65
        }
        return 60.0
    }()
    private var squadViews:[Int:UIView] = [:]
    private var dataSource:[Int:SquadSelectorItem?] = [
        1:nil,
        2:nil,
        3:nil,
        4:nil,
        5:nil,
        6:nil,
        7:nil,
        8:nil,
        9:nil,
        10:nil,
        11:nil,
    ]
    private var currentScheme:SquadScheme = SquadScheme.s343
    private let isReversed:Bool = true
    
    
    
    
    
    // MARK: - Objects
    let ivBackground:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor(hexString: "232323")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 0.0
        iv.image = UIImage(named: "linhas_campo_2")
        iv.alpha = 0.8
        return iv
    }()
    
    
    
    
    
    // MARK: - Methods
    func updateContent(scheme:SquadScheme, items:[Int:SquadSelectorItem?]) {
        // clear
        for (_, vw) in self.squadViews {
            vw.removeFromSuperview()
        }
        self.squadViews.removeAll()
        // update
        self.currentScheme = scheme
        self.dataSource.removeAll()
        self.dataSource = items
        for (i,item) in self.dataSource {
            let vw = SquadSelectorItemView()
            vw.delegate = self
            vw.updateContent(position: i, item: item, isActionAllowed: self.isActionAllowed)
            self.squadViews[i] = vw
            self.addSubview(vw)
            if self.isReversed {
                vw.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        }
        self.updatePositions()
    }
    
    func changeSquadScheme(scheme:SquadScheme, animated:Bool) {
        DispatchQueue.main.async {
            self.currentScheme = scheme
            UIView.animate(withDuration: 0.3) {
                self.updatePositions()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updatePositions()
    }
    
    private func updatePositions() {
        
        for (i,vw) in self.squadViews {
            let itemPosition = self.currentScheme.positionAt(index: i)
            let x = (self.bounds.width*itemPosition.x)-(self.itemSize/2)
            var y = (self.bounds.height*(1-itemPosition.y))-(self.itemSize/2)
            if UIScreen.main.bounds.height < 667 {
                y -= 5
                if i == 1 {
                    vw.frame = CGRect(x: x, y: y-20, width: self.itemSize, height: self.itemSize)
                } else {
                    vw.frame = CGRect(x: x, y: y-30, width: self.itemSize, height: self.itemSize)
                }
            } else {
                y -= 10
                vw.frame = CGRect(x: x, y: y, width: self.itemSize, height: self.itemSize)
            }
        }
    }
    
    func squadSelectorItemView(squadSelectorItemView: SquadSelectorItemView, didSelectItem item: SquadSelectorItem?, atPosition position: Int) {
        if item == nil {
            self.delegate?.squadSelectorView(squadSelectorView: self, didSelectAddAt: position)
        } else {
            self.delegate?.squadSelectorView(squadSelectorView: self, didRemoveItemAt: position)
        }
    }
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.ivBackground)
        self.addFullBoundsConstraintsTo(subView: self.ivBackground, constant: 0)
        if self.isReversed {
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
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
