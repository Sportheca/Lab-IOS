//
//  MenuView.swift
//
//
//  Created by Roberto Oliveira on 17/01/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol MenuViewDelegate {
    func didSelect(item:MenuItem)
}

class MenuView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    var delegate:MenuViewDelegate?
    var dataSource:[MenuSection] = []
    private var expandedSections:Set<Int> = []
    private let itemHeight:CGFloat = 65
    
    
    // MARK: - Objects
    private lazy var tableView:UITableView = {
        let tbv = UITableView()
        tbv.register(MenuItemTableViewCell.self, forCellReuseIdentifier: "MenuItemTableViewCell")
        tbv.dataSource = self
        tbv.delegate = self
        tbv.separatorStyle = .none
        tbv.showsVerticalScrollIndicator = false
        tbv.backgroundColor = UIColor.clear
        tbv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        return tbv
    }()
    
    
    
    
    
    // MARK: - Methods
    func updateContent(items:[MenuSection]) {
        self.dataSource.removeAll()
        self.dataSource = items
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    
    // MARK: - Table View Stack
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = self.dataSource[indexPath.section]
        let item = section.items[indexPath.row]
        self.delegate?.didSelect(item: item)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard let cell = tableView.cellForRow(at: indexPath) as? MenuItemTableViewCell else {return}
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .allowUserInteraction, animations: {
                cell.lblTitle.alpha = 0.5
                cell.ivIcon.alpha = 0.5
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard let cell = tableView.cellForRow(at: indexPath) as? MenuItemTableViewCell else {return}
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .allowUserInteraction, animations: {
                cell.lblTitle.alpha = 1.0
                cell.ivIcon.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.dataSource[section].isColapsable {
            return self.itemHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = MenuSectionHeaderView()
        if !self.expandedSections.contains(section) {
            vw.ivDisclosure.transform = CGAffineTransform(rotationAngle: CGFloat.pi) // point down
        }
        vw.currentSection = section
        vw.delegate = self
        vw.updateContent(section: self.dataSource[section])
        return vw
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.itemHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.itemHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = self.dataSource[section]
        if item.isColapsable == true && !self.expandedSections.contains(section) {
            return 0
        }
        return item.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell", for: indexPath) as! MenuItemTableViewCell
        let section = self.dataSource[indexPath.section]
        let item = section.items[indexPath.row]
        cell.updateContent(item: item, section: section)
        return cell
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.tableView)
        self.addBoundsConstraintsTo(subView: self.tableView, leading: 0, trailing: 0, top: 0, bottom: 0)
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



extension MenuView: MenuSectionHeaderViewDelegate {
    
    func menuSectionHeaderView(menuSectionHeaderView: MenuSectionHeaderView, didTapHeaderAtSection section: Int) {
        var indexPaths:[IndexPath] = []
        let total = self.dataSource[section].items.count
        if total > 0 {
            for row in 0..<total {
                indexPaths.append(IndexPath(row: row, section: section))
            }
        }
        if self.expandedSections.contains(section) {
            self.expandedSections.remove(section)
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.top)
                UIView.animate(withDuration: 0.3) {
                    menuSectionHeaderView.ivDisclosure.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }
            }
        } else {
            self.expandedSections.insert(section)
            DispatchQueue.main.async {
                self.tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.top)
                UIView.animate(withDuration: 0.3) {
                    menuSectionHeaderView.ivDisclosure.transform = CGAffineTransform.identity
                }
            }
        }
    }
    
}
