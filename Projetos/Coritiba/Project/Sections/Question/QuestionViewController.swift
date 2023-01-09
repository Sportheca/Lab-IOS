//
//  NewQuizViewController.swift
//
//
//  Created by Roberto Oliveira on 12/07/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class QuestionViewController: BaseStackViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.statusBarStyle()
    }
    
    // MARK: - Options
    var timerColor:UIColor = Theme.color(.PrimaryAnchor)
    var timerTrackColor:UIColor = Theme.color(.MutedText)
    var titleColor:UIColor = Theme.color(.PrimaryText)
    var resultPositiveColor:UIColor = Theme.color(.PrimaryAnchor)
    var resultNegativeColor:UIColor = Theme.color(.PrimaryAnchor)
    var actionColor:UIColor = Theme.color(.PrimaryButtonBackground)
    var actionTitleColor:UIColor = Theme.color(.PrimaryButtonText)
    var loadingActivityColor:UIColor = Theme.color(.MutedText)
    var progressBarColor:UIColor = Theme.color(.PrimaryAnchor)
    
    
    
    
    // MARK: - Properties
    var group:QuizGroup? // group id
    var trackEvent:Int?
    var trackValue:Int?
    private var selectedIndexPath:IndexPath?
    private var object:Question?
    private var type:Question.QuestionType = .Quiz
    // timer
    private var timer:Timer?
    private let timeInterval:TimeInterval = 0.01
    private var totalTime:TimeInterval = 0.0
    private var currentTime:TimeInterval = 0.0
    private var answeredQuestionIds:[Int] = []
    private var isTimeOutTriggered:Bool = false
    
    
    
    
    
    // MARK: - Objects
    private let loadingActivity:UIActivityIndicatorView = {
        let vw = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        vw.hidesWhenStopped = true
        return vw
    }()
    private let headerView:QuestionHeaderView = QuestionHeaderView()
    private let timerView:RoundTimerView = {
        let vw = RoundTimerView()
        vw.lblTitle.font = FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 30)
        vw.updateColors(track: Theme.color(.MutedText), progress: Theme.color(.PrimaryAnchor), text: Theme.color(.PrimaryText))
        return vw
    }()
    private let lblQuestionsCounter:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 14)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 14)
        return lbl
    }()
    private let resultsView:QuestionResultView = QuestionResultView()
    private let optionsView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private var tableViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private lazy var tableView:UITableView = {
        let tbv = UITableView()
        tbv.register(QuestionAnswerOptionTableViewCell.self, forCellReuseIdentifier: "QuestionAnswerOptionTableViewCell")
        tbv.dataSource = self
        tbv.delegate = self
        tbv.separatorStyle = .none
        tbv.showsVerticalScrollIndicator = false
        tbv.backgroundColor = UIColor.clear
        tbv.isScrollEnabled = false
        return tbv
    }()
    private lazy var btnAction:TimerButton = {
        let btn = TimerButton()
        btn.delegate = self
        btn.totalTime = 4.0
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.layer.cornerRadius = 10.0
        btn.clipsToBounds = true
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.9
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.actionMethod), for: .touchUpInside)
        return btn
    }()
    @objc func actionMethod() {
        self.stopTimer()
        guard let type = self.object?.type else {return}
        switch type {
        case .Quiz:
            self.trackEvent = EventTrack.Quiz.nextQuestion
            self.trackValue = self.object?.id
        case .Research:
            if self.selectedIndexPath == nil {
                // Skip Research
                self.skipQuestion()
                return
            } else {
                // Research Answered
                self.trackEvent = nil//EventTrack.Researches.next
                self.trackValue = self.object?.id
            }
        }
        self.loadNewObject()
    }
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = UIColor.clear
        btn.setTitleColor(Theme.color(.PrimaryText), for: .normal)
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.9
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.setTitle("SAIR", for: .normal)
        btn.addTarget(self, action: #selector(self.dismissAction), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    
    
    
    // MARK: - Methods
    private func skipQuestion() {
        self.sendAnswer()
        self.trackEvent = nil
        self.trackValue = nil
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollView.alpha = 0
            })
            self.loadingActivity.startAnimating()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).asyncAfter(deadline: .now()+0.5) {
                self.loadNewObject()
            }
        }
    }
    
    private func loadNewObject() {
        DispatchQueue.main.async {
            self.scrollView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollView.alpha = 0
            })
            self.loadingActivity.startAnimating()
        }
        self.stopTimer()
        ServerManager.shared.getQuestion(type: self.type, referenceID: self.group?.id, trackEvent: self.trackEvent, trackValue: self.trackValue) { (item:Question?, message:String?) in
            self.trackEvent = nil
            self.trackValue = nil
            item?.isLastQuestion = false
            if let answered = self.group?.answeredQuestions, let total = self.group?.totalQuestions {
                if (answered + 1) >= total {
                    item?.isLastQuestion = true
                }
            }
            guard let obj = item else {
                let message = message ?? "Falha ao carregar"
                DispatchQueue.main.async {
                    self.basicAlert(message: message, handler: { (action:UIAlertAction) in
                        self.stopTimer()
                        self.dismissAction()
                    })
                }
                return
            }
            self.object = obj
            self.selectedIndexPath = nil
            self.isTimeOutTriggered = false
            self.stopTimer()
            DispatchQueue.main.async {
                self.updateQuestion()
                self.loadingActivity.stopAnimating()
                self.scrollView.setContentOffset(CGPoint.zero, animated: false)
                UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
                    self.scrollView.alpha = 1.0
                }, completion: { (_) in
                    self.scrollView.isUserInteractionEnabled = true
                    if let time = self.object?.time {
                        self.timer?.invalidate()
                        self.timer = nil
                        self.timerView.setProgress(0.0, duration: TimeInterval(time))
                        self.timer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.increaseTime), userInfo: nil, repeats: true)
                        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
                    }
                })
            }
        }
    }
    
    private func updateQuestionCounter(justAnswered:Bool) {
        if let answered = self.group?.answeredQuestions, let total = self.group?.totalQuestions {
            let corrects = self.group?.correctAnswers ?? 0
            let correctsDescription = corrects == 1 ? "1 Acerto" : "\(corrects.descriptionWithThousandsSeparator()) Acertos"
            let value = justAnswered ? answered : answered+1
            self.lblQuestionsCounter.text = "\((value).descriptionWithThousandsSeparator())/\(total.descriptionWithThousandsSeparator())\n\(correctsDescription)"
        }
    }
    
    private func updateQuestion() {
        self.updateQuestionCounter(justAnswered: false)
        guard let obj = self.object else {return}
        // Time
        if let time = obj.time {
            self.btnAction.currentTime = 0.0
            self.currentTime = 0.0
            self.totalTime = TimeInterval(time)
            self.timerView.setProgress(1.0, duration: nil)
            self.timerView.lblTitle.text = Int(time).description
            self.timerView.isHidden = false
        } else {
            self.timerView.isHidden = true
        }
        // Title
        self.lblTitle.text = obj.title
        self.lblTitle.isHidden = (obj.title == nil)
        // Result
        self.resultsView.isHidden = true
        self.resultsView.alpha = 0.0
        self.resultsView.scaleTo(0.5)
        // Options
        self.tableView.reloadData()
        self.tableView.isUserInteractionEnabled = true
        switch obj.type {
        case .Quiz:
            // Action
            self.btnAction.alpha = 0.0
            self.btnAction.isHidden = true
            self.btnClose.alpha = 0.0
            self.btnClose.isHidden = true
            self.updateActionButtonTitle()
        case .Research:
            // Action
            self.btnAction.alpha = 1.0
            self.btnAction.isHidden = false
            self.btnClose.alpha = 1.0
            self.btnClose.isHidden = false
            self.btnAction.setTitle("PRÓXIMA PESQUISA", for: .normal)
        }
    }
    
    private func answer(at indexPath:IndexPath?) {
        self.tableView.isUserInteractionEnabled = false
        self.selectedIndexPath = indexPath
        self.stopTimer()
        self.showResults()
        self.sendAnswer()
    }
    
    private func sendAnswer() {
        guard let obj = self.object else {return}
        guard !self.answeredQuestionIds.contains(obj.id) else {return}
        self.answeredQuestionIds.append(obj.id)
        
        self.stopTimer()
        var choice:Int?
        if let index = self.selectedIndexPath {
            choice = obj.options[index.row].id
        }
        // Track Answer
        var trackEvent:Int = EventTrack.Quiz.selectAnswer
        if obj.type == .Research {
            trackEvent = (choice == nil) ? 1:2//EventTrack.Researches.skip : EventTrack.Researches.answer
        }
        let timeOut = self.selectedIndexPath == nil
        if timeOut {
            trackEvent = EventTrack.Quiz.answerTimeout
        }
        
        //        if let answered = self.group?.answeredQuestions {
        //            self.group?.answeredQuestions = answered+1
        //        }
        let answered = self.group?.answeredQuestions ?? 0
        let totalQuestions = self.group?.totalQuestions ?? 0
        self.group?.answeredQuestions = min(totalQuestions, answered+1)
        
        ServerManager.shared.setQuestion(type: self.type, id: obj.id, choice: choice, trackEvent: trackEvent, secondsToAnswer: self.currentTime, timeOut: timeOut)
    }
    
    private func showResults() {
        guard let obj = self.object else {return}
        if obj.type == .Quiz {
            guard let correctId = obj.correctOptionId else {return}
            // Check if it is selected and correct
            if let indexPath = self.selectedIndexPath {
                guard let selectedCell = tableView.cellForRow(at: indexPath) as? QuestionAnswerOptionTableViewCell else {return}
                // Update Selected Row
                DispatchQueue.main.async {
                    let correctSelected = obj.options[indexPath.row].id == correctId
                    self.tableView.bringSubviewToFront(selectedCell)
                    selectedCell.showResult(correct: correctSelected, scale: true)
                }
            }
            // Update other rows
            for visible in self.tableView.visibleCells {
                guard let cell = visible as? QuestionAnswerOptionTableViewCell else {continue}
                cell.alpha = 0.5
                if let selected = self.selectedIndexPath {
                    guard cell.indexPath != selected else {
                        cell.alpha = 1.0
                        continue
                    }
                }
                if obj.options[cell.indexPath.row].id == correctId {
                    DispatchQueue.main.async {
                        cell.showResult(correct: true, scale: false)
                    }
                }
            }
            // Show Action and Result
            DispatchQueue.main.async {
                //                if self.scrollView.contentSize.height+100 > (self.view.frame.height-self.customNavBar.frame.height) {
                //                    let yPoint = self.scrollView.convert(self.optionsView.frame, to: self.scrollView).origin.y
                //                    self.scrollView.setContentOffset(CGPoint(x: 0, y: yPoint-100), animated: true)
                //                }
                if self.scrollView.contentSize.height+150 > (self.scrollView.bounds.height) {
                    let yPoint = (self.scrollView.contentSize.height+150) - self.scrollView.bounds.height
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: yPoint), animated: true)
                }
                self.updateResultLabel()
                self.resultsView.scaleTo(1.0, duration: 0.5)
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self.resultsView.isHidden = false
                    self.resultsView.alpha = 1.0
                }, completion: nil)
                if !obj.isLastQuestion {
                    self.updateActionButtonTitle()
                    self.btnAction.isHidden = false
                    UIView.animate(withDuration: 0.5, delay: 0.5, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                        self.btnAction.alpha = 1.0
                    }, completion: { (_) in
                        self.btnAction.delegate = self
                        self.btnAction.startTimer()
                    })
                } else {
//                    DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
//                        self.basicAlert(message: "Parabéns! Você respondeu todas as perguntas deste Quiz!\n\nContinue participando", handler: nil)
//                    }
                }
                self.btnClose.isHidden = false
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self.btnClose.alpha = 1.0
                }, completion: nil)
            }
            return
        }
        
        if obj.type == .Research {
            // Check if it is selected and correct
            if let indexPath = self.selectedIndexPath {
                guard let selectedCell = tableView.cellForRow(at: indexPath) as? QuestionAnswerOptionTableViewCell else {return}
                // Update Selected Row
                DispatchQueue.main.async {
                    let percentageValue = min(100, (obj.answerPercentageAt(index: indexPath.row, selectedId: obj.options[indexPath.row].id)))
                    self.tableView.bringSubviewToFront(selectedCell)
                    selectedCell.showPercentage(value: percentageValue, scale: true, color: self.progressBarColor)
                }
            }
            // Update other rows
            for visible in self.tableView.visibleCells {
                guard let cell = visible as? QuestionAnswerOptionTableViewCell else {continue}
                if let selected = self.selectedIndexPath {
                    guard cell.indexPath != selected else {continue}
                }
                let percentageValue = min(100, (obj.answerPercentageAt(index: cell.indexPath.row, selectedId: obj.options[cell.indexPath.row].id)))
                cell.showPercentage(value: percentageValue, scale: false, color: self.progressBarColor)
            }
            // Show Action and Result
            DispatchQueue.main.async {
                //                if self.scrollView.contentSize.height+100 > (self.view.frame.height-self.customNavBar.frame.height) {
                //                    let yPoint = self.scrollView.convert(self.optionsView.frame, to: self.scrollView).origin.y
                //                    self.scrollView.setContentOffset(CGPoint(x: 0, y: yPoint-100), animated: true)
                //                }
                if self.scrollView.contentSize.height+100 > (self.view.frame.height) {
                    let yPoint = self.scrollView.convert(self.optionsView.frame, to: self.scrollView).origin.y
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: yPoint-100), animated: true)
                }
                self.updateResultLabel()
                self.btnAction.setTitle("PRÓXIMA PESQUISA", for: .normal)
                self.resultsView.scaleTo(1.0, duration: 0.5)
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self.resultsView.isHidden = false
                    self.resultsView.alpha = 1.0
                }, completion: nil)
                if !obj.isLastQuestion {
                    self.btnAction.isHidden = false
                    UIView.animate(withDuration: 0.5, delay: 0.5, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                        self.btnAction.alpha = 1.0
                    }, completion: nil)
                }
                self.btnClose.isHidden = false
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self.btnClose.alpha = 1.0
                }, completion: nil)
            }
            return
        }
        
    }
    
    private func updateResultLabel() {
        guard let obj = self.object else {return}
        
        //        var title:String = ""
        //        var subtitle:String = ""
        //        var correct:Bool = false
        
        switch self.type {
        case .Quiz:
            guard let correctId = obj.correctOptionId else {return}
            if let selected = self.selectedIndexPath {
                let correct = (obj.options[selected.row].id == correctId)
                if correct {
                    if let group = self.group {
                        group.correctAnswers += 1
                        self.updateQuestionCounter(justAnswered: true)
                    }
                    self.showCoinsAlert(addCoins: obj.positiveScore ?? 0)
                    self.resultsView.updateContent(mode: .Correct, coins: obj.positiveScore)
                } else {
                    self.showCoinsAlert(addCoins: obj.negativeScore ?? 0)
                    self.resultsView.updateContent(mode: .Wrong, coins: obj.negativeScore)
                }
            } else {
                self.showCoinsAlert(addCoins: obj.timeOutScore ?? 0)
                self.resultsView.updateContent(mode: .TimeOut, coins: obj.timeOutScore)
            }
        case .Research:
            break
        }
        
        //        let att = NSMutableAttributedString()
        //        att.append(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 20)]))
        //        att.append(NSAttributedString(string: "\n"+subtitle, attributes: [NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 15)]))
        //        self.lblResult.attributedText = att
        //        self.lblResult.textColor = correct ? self.resultPositiveColor : self.resultNegativeColor
        //
        //
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Timer Methods
    private func stopTimer() {
        self.btnAction.delegate = nil
        self.btnAction.timer?.invalidate()
        self.btnAction.timer = nil
        let progress = self.totalTime == 0 ? 0 : self.currentTime / self.totalTime
        self.timerView.stopAnimation(to: Float(1-progress))
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func increaseTime() {
        // Check for time out
        if self.currentTime >= self.totalTime {
            self.timeOut()
            return
        }
        DispatchQueue.main.async {
            self.currentTime += self.timeInterval
            self.timerView.lblTitle.text = Int(self.totalTime-self.currentTime).description
        }
    }
    
    
    private func timeOut() {
        self.isTimeOutTriggered = true
        self.stopTimer()
        self.answer(at: nil)
        self.timerView.bounceAnimation()
    }
    
    //
    override func appBecomeActive() {
        guard self.isTimeOutTriggered == false else {return}
        self.currentTime = self.totalTime
        DispatchQueue.main.async {
            self.currentTime += self.timeInterval
            self.timerView.lblTitle.text = Int(self.totalTime-self.currentTime).description
        }
        self.timeOut()
    }
    
    
    
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenter.default.addObserver(self, selector: #selector(self.appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func dismissAction() {
        self.stopTimer()
        switch self.type {
        case .Quiz:
            ServerManager.shared.setTrack(trackEvent: EventTrack.Quiz.close, trackValue: self.object?.id)
        case .Research:
            //            ServerManager.shared.track(eventId: EventTrack.Researches.close, value: self.object?.id)
            ServerManager.shared.setTrack(trackEvent: nil, trackValue: self.object?.id)
        }
        super.dismissAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollView.alpha = 0
        self.updateColors()
        if let item = self.group {
            self.headerView.updateContent(item: item)
        }
        self.loadingActivity.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadNewObject()
    }
    
    private func updateColors() {
        self.timerView.updateColors(track: self.timerTrackColor, progress: self.timerColor, text: self.timerColor)
        self.lblTitle.textColor = self.titleColor
        self.btnAction.backgroundColor = self.actionColor
        self.btnAction.setTitleColor(self.actionTitleColor, for: .normal)
        self.loadingActivity.color = self.loadingActivityColor
    }
    
    override func prepareElements() {
        super.prepareElements()
        self.stackView.spacing = 20
        self.scrollView.alpha = 0.0
        self.contentView.addWidthConstraint(constant: min(500, UIScreen.main.bounds.width-10), relatedBy: .lessThanOrEqual, priority: 999)
        // Header
        self.scrollView.addSubview(self.headerView)
        self.scrollView.addBoundsConstraintsTo(subView: self.headerView, leading: nil, trailing: nil, top: 0, bottom: nil)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.addStackSpaceView(height: 120)
        // Loading
        self.view.addSubview(self.loadingActivity)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingActivity, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingActivity, constant: 0)
        // Timer
        self.stackView.addArrangedSubview(self.timerView)
        self.timerView.addWidthConstraint(80)
        self.timerView.addHeightConstraint(80)
        // Counter
        self.scrollView.addSubview(self.lblQuestionsCounter)
        self.scrollView.addHorizontalSpacingTo(subView1: self.timerView, subView2: self.lblQuestionsCounter, constant: 20)
        self.scrollView.addCenterYAlignmentRelatedConstraintTo(subView: self.lblQuestionsCounter, reference: self.timerView, constant: 0)
        // Title
        self.addFullWidthStackSubview(self.lblTitle, constant: -40)
        // Options
        self.addFullWidthStackSubview(self.optionsView, constant: -40)
        self.optionsView.addSubview(self.tableView)
        self.optionsView.addBoundsConstraintsTo(subView: self.tableView, leading: 0, trailing: 0, top: 10, bottom: -10)
        self.tableViewHeightConstraint = NSLayoutConstraint(item: self.tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        self.optionsView.addConstraint(self.tableViewHeightConstraint)
        // Result
        self.stackView.addArrangedSubview(self.resultsView)
        // Action
        self.stackView.addArrangedSubview(self.btnAction)
        self.btnAction.addWidthConstraint(310)
        self.btnAction.addHeightConstraint(50)
        // Close
        self.stackView.addArrangedSubview(self.btnClose)
        self.btnClose.addHeightConstraint(40)
        self.btnClose.addWidthConstraint(100)
        // Footer
        self.addStackSpaceView(height: 50)
        
        
        self.tableView.clipsToBounds = false
        
    }
    
    init(type:Question.QuestionType) {
        super.init()
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}



extension QuestionViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.isUserInteractionEnabled = false
        self.answer(at: indexPath)
    }
    
    
    // Layout
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    
    // DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.object?.options.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerOptionTableViewCell", for: indexPath) as! QuestionAnswerOptionTableViewCell
        guard let obj = self.object else {return cell}
        let item = obj.options[indexPath.row]
        cell.updateContent(title: item.title)
        cell.separator.isHidden = (indexPath.row == 0)
        cell.indexPath = indexPath
        return cell
    }
    
}




extension QuestionViewController: TimerButtonDelegate {
    
    func timerButton(sender: TimerButton, didUpdateTimeAt time: TimeInterval) {
        self.updateActionButtonTitle()
    }
    
    fileprivate func updateActionButtonTitle() {
        let total = Int(self.btnAction.totalTime)
        let current = Int(self.btnAction.currentTime)
        let seconds = total - current
        DispatchQueue.main.async {
            var title = "PRÓXIMA PERGUNTA"
            if !self.isTimeOutTriggered {
                title += " (\(seconds.descriptionWithThousandsSeparator()))"
            }
            self.btnAction.setTitle(title, for: .normal)
        }
    }
    
    func timerButton(didTimeoutWith sender: TimerButton) {
        self.stopTimer()
        guard self.isTimeOutTriggered == false else {return}
        self.trackEvent = EventTrack.Quiz.nextQuestionTimer
        self.trackValue = self.object?.id
        self.loadNewObject()
    }
    
}
