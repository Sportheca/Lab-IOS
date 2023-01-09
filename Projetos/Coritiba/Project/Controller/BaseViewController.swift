//
//  BaseViewController.swift
//
//
//  Created by Roberto Oliveira on 29/08/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.statusBarStyle()
    }
    
    
    // MARK: - Properties
    var firstAppear:Bool = true
    var isAudioPlayerFloatingButtonAllowed:Bool = true
    
    
    
    
    
    // MARK: - Methods
    // Add full screen subview under Navigation Bar with all constraints
    func addBaseFullSubview(subView: UIView) {
        self.view.addSubview(subView)
        self.view.addFullBoundsConstraintsTo(subView: subView, constant: 0)
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Super Methods
    func firstTimeViewWillAppear() {
        // Do some stuff like update UIViews that will update only once
    }
    
    @objc func appBecomeActive() {
        // --
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isAudioPlayerFloatingButtonAllowed && AudioLibraryPlayer.shared.isPlaying {
            AudioLibraryManager.shared.showFloatingButton()
        }
        if DebugManager.isDebugModeEnabled && DebugManager.shared.isColorFloatingInspectorEnabled {
            DebugManager.shared.showFloatingColors()
        }
        if self.firstAppear == true {
            self.firstTimeViewWillAppear()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.firstAppear == true {
            self.firstAppear = false
        }
    }
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if DebugManager.isDebugModeEnabled && DebugManager.shared.isColorFloatingInspectorEnabled {
                DebugManager.shared.hideFloatingColors()
            }
        }
    }
    
    
    // MARK: - Init methods
    func prepareElements() {
        self.addKeyboardObservers()
        DebugManager.shared.colorsDataSource.removeAll()
        self.view.backgroundColor = Theme.color(.PrimaryBackground)
        //self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    @objc func dismissAction() {
        DispatchQueue.main.async {
            if let nav = self.navigationController {
                if nav.viewControllers.count == 1 {
                    nav.dismiss(animated: true, completion: nil)
                } else {
                    nav.popViewController(animated: true)
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
    
    
    
    
    
    
    // MARK: - KEYBOARD OBSERVER STACK
    // MARK: - keyboard Methods (override this methods on YourViewController)
    func keyboardWillDisappear(duration: TimeInterval) {
        //
    }
    func keyboardWillAppear(height: CGFloat, duration: TimeInterval) {
        //
    }
    
    // MARK: - Deinit Methods (don't change it)
    deinit {
        print("DEINIT: ", self)
        DebugManager.shared.colorsDataSource.removeAll()
        self.removeKeyboardObserver()
    }
    
    // MARK: - Observer Methods (don't change it)
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let height = keyboardSize.size.height
            let keyboardDuration = (notification as NSNotification).userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
            let duration:TimeInterval = (keyboardDuration != nil) ? TimeInterval(truncating: keyboardDuration!) : 0.25
            self.keyboardWillAppear(height: height, duration: duration)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification as NSNotification).userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        let duration:TimeInterval = (keyboardDuration != nil) ? TimeInterval(truncating: keyboardDuration!) : 0.25
        self.keyboardWillDisappear(duration: duration)
    }
    
}
