//
//  QuestionsHomeViewController.swift
//
//
//  Created by Roberto Oliveira on 06/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

enum QuestionsHomeTab {
    case MultipleSurveys
    case Quiz
    case Surveys
    
    func title() -> String {
        switch self {
        case .MultipleSurveys: return "PALPITES"
        case .Quiz: return "QUIZ"
        case .Surveys: return "PESQUISAS"
        }
    }
}

class QuestionsHomeViewController: HorizontalTabsViewController {
    
    // MARK: - Objects
    let surveysVc:SurveysViewController = SurveysViewController()
    private let multipleSurveysVc:MultipleSurveysViewController = MultipleSurveysViewController()
    let quizVc:QuizGroupsViewController = QuizGroupsViewController()
    private let dataSource:[QuestionsHomeTab] = [.Quiz, .Surveys, .MultipleSurveys]
    
    
    
    
    // MARK: - Methods
    private func cardContainerFor(viewController vc:UIViewController) -> UIView {
        let color = Theme.color(.PrimaryCardBackground)
        // card
        let cardView = UIView()
        cardView.backgroundColor = color
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 25.0
        // child view controller
        vc.extendedLayoutIncludesOpaqueBars = true
        vc.edgesForExtendedLayout = [.all]
        let controller = UINavigationController(rootViewController: vc)
        controller.navigationBar.isHidden = true
        controller.willMove(toParent: self)
        cardView.addSubview(controller.view)
        cardView.addBoundsConstraintsTo(subView: controller.view, leading: 0, trailing: 0, top: 0, bottom: 0)
        self.addChild(controller)
        controller.didMove(toParent: self)
        // container
        let container = UIView()
        container.backgroundColor = UIColor.clear
        //container.layer.shadowColor = color.cgColor
        container.layer.shadowOpacity = 0.3
        container.layer.shadowRadius = 5.0
        container.layer.shadowOffset = CGSize(width: 0, height: 10.0)
        container.addSubview(cardView)
        // horizontal
        container.addCenterXAlignmentConstraintTo(subView: cardView, constant: 0)
        container.addLeadingAlignmentConstraintTo(subView: cardView, relatedBy: .equal, constant: 20, priority: 750)
        container.addTrailingAlignmentConstraintTo(subView: cardView, relatedBy: .equal, constant: -20, priority: 750)
        cardView.addWidthConstraint(constant: 500, relatedBy: .lessThanOrEqual, priority: 999)
        
        // vertical
        container.addCenterYAlignmentConstraintTo(subView: cardView, constant: 0)
        container.addTopAlignmentConstraintTo(subView: cardView, relatedBy: .equal, constant: 10, priority: 750)
        container.addBottomAlignmentConstraintTo(subView: cardView, relatedBy: .equal, constant: -10, priority: 750)
        cardView.addHeightConstraint(constant: 600, relatedBy: .lessThanOrEqual, priority: 999)
        return container
    }
    
    
    // MARK: - Super Methods
    override func numberOfTabs() -> Int {
        return self.dataSource.count
    }
    
    override func titleForTabAt(index: Int) -> String {
        let item = self.dataSource[index]
        return item.title()
    }
    
    override func viewForTabAt(index: Int) -> UIView {
        let item = self.dataSource[index]
        switch item {
        case .MultipleSurveys:
            return self.cardContainerFor(viewController: self.multipleSurveysVc)
        case .Quiz:
            return self.cardContainerFor(viewController: self.quizVc)
        case .Surveys:
            return self.cardContainerFor(viewController: self.surveysVc)
        }
    }
    
    override var selectedTabIndex: Int {
        didSet {
            self.trackSelectedTab()
        }
    }
    
    private func trackSelectedTab() {
        let item = self.dataSource[self.selectedTabIndex]
        switch item {
        case .MultipleSurveys:
            ServerManager.shared.setTrack(trackEvent: EventTrack.HomeQuestions.selectMultipleSurveysTab, trackValue: nil)
            break
        case .Quiz:
            ServerManager.shared.setTrack(trackEvent: EventTrack.HomeQuestions.selectQuizTab, trackValue: nil)
            break
        case .Surveys:
            ServerManager.shared.setTrack(trackEvent: EventTrack.HomeQuestions.selectSurveysTab, trackValue: nil)
            break
        }
        
    }
    
    
}

