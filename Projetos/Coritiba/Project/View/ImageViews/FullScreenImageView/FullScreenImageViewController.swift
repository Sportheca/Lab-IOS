//
//  FullScreenImageViewController.swift
//
//
//  Created by Roberto Oliveira on 25/05/2018.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    weak var image:UIImage?
    weak var referenceImageView:UIImageView?
    var referenceFrame:CGRect = CGRect.zero
    private var lastOrientation:UIDeviceOrientation = UIDeviceOrientation.portrait
    
    
    
    // MARK: - Objects
    private lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        let down = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissMethod))
        down.direction = .down
        sv.addGestureRecognizer(down)
        let left = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissMethod))
        left.direction = .left
        sv.addGestureRecognizer(left)
        let up = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissMethod))
        up.direction = .up
        sv.addGestureRecognizer(up)
        let right = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissMethod))
        right.direction = .right
        sv.addGestureRecognizer(right)
        return sv
    }()
    lazy var imageView:UIImageView = {
        let iv = UIImageView()
        iv.image = self.image
        iv.isUserInteractionEnabled = true
        // Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapZoomMethod))
        tapGesture.numberOfTapsRequired = 2
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    private lazy var btnClose:CloseButton = {
        let btn = CloseButton()
        btn.addTarget(self, action: #selector(self.dismissMethod), for: .touchUpInside)
        btn.iconLineWidth = 3
        btn.iconPathInset = 20
        return btn
    }()
    
    
    
    
    
    
    
    
    
    // MARK: - Methods
    @objc func dismissMethod() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func doubleTapZoomMethod(_ sender: UITapGestureRecognizer) {
        if self.scrollView.zoomScale == 1.0 {
            DispatchQueue.main.async {
                self.scrollView.contentSize = self.imageView.frame.size
                self.scrollView.setZoomScale(3.0, animated: true)
                // Center Image after zoom in
                var pointX:CGFloat = 0.0
                var pointY:CGFloat = 0.0
                if self.lastOrientation == .landscapeRight || self.lastOrientation == .landscapeLeft {
                    pointX = min(0, ((UIScreen.main.bounds.size.height-self.imageView.frame.size.width)/2))
                    pointY = min(0, ((UIScreen.main.bounds.size.width-self.imageView.frame.size.height)/2))
                } else {
                    pointX = min(0, ((UIScreen.main.bounds.size.width-self.imageView.frame.size.width)/2))
                    pointY = min(0, ((UIScreen.main.bounds.size.height-self.imageView.frame.size.height)/2))
                }
                self.scrollView.setContentOffset(CGPoint(x: -(pointX), y: -(pointY)), animated: true)
            }
        } else {
            DispatchQueue.main.async {
                self.scrollView.contentSize = self.imageView.frame.size
                self.scrollView.setZoomScale(1.0, animated: true)
                self.scrollView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Orientation Methods
    @objc func deviceRotated() {
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portrait {
            if orientation != self.lastOrientation {
                self.lastOrientation = orientation
                DispatchQueue.main.async {
                    self.scrollView.zoomScale = 1.0
                    UIView.animate(withDuration: 0.3, animations: {
                        self.updateRotation()
                        self.updateScrollViewFrame()
                        self.updateThumbFrame()
                        self.updateBtnCloseFrame()
                    })
                }
            }
        }
    }
    
    fileprivate func updateRotation() {
        var degrees:CGFloat = 0.0
        if self.lastOrientation == .landscapeLeft {
            degrees = 90
        } else if self.lastOrientation == .landscapeRight {
            degrees = -90
        } else if self.lastOrientation == .portrait {
            degrees = 0
        }
        self.scrollView.transform = CGAffineTransform(rotationAngle: CGFloat(degrees).degreesToRadians())
    }
    
    fileprivate func updateBtnCloseFrame() {
//        if self.lastOrientation == .landscapeLeft {
//            self.btnClose.frame = CGRect(x: UIScreen.main.bounds.size.width-60, y: 0, width: 60, height: 60)
//        } else if self.lastOrientation == .landscapeRight {
//            self.btnClose.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height-60, width: 60, height: 60)
//        } else {
//            self.btnClose.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
//        }
    }
    
    fileprivate func updateThumbFrame() {
        guard let image = self.image else {return}
        if self.lastOrientation == .landscapeRight || self.lastOrientation == .landscapeLeft {
            //            let proportion = self.frame.size.height/self.frame.size.width
            //            let proportion = ((self.image?.size.height)??1)/((self.image?.size.width)??1)
            let proportion = (image.size.width > 0) ? image.size.height / image.size.width : 1
            //            let imageProportionalHeight = (image.size.width > 0) ? (image.size.height*UIScreen.main.bounds.size.width)/image.size.width : 0
            let m:CGFloat = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height*proportion)
            if m < UIScreen.main.bounds.size.width {
                self.imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.height, height: UIScreen.main.bounds.size.height*proportion)
                self.imageView.frame.origin.x = 0
                self.imageView.center.y = UIScreen.main.bounds.width/2
            } else {
                self.imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width/proportion, height: UIScreen.main.bounds.size.width)
                self.imageView.frame.origin.y = 0
                self.imageView.center.x = UIScreen.main.bounds.height/2
            }
        } else {
            let proportion = (image.size.width > 0) ? image.size.height / image.size.width : 1
            let imageProportionalHeight = (image.size.width > 0) ? (image.size.height*UIScreen.main.bounds.size.width)/image.size.width : 0
            if imageProportionalHeight > UIScreen.main.bounds.size.height {
                // Very portrait image (max value is height)
                self.imageView.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.size.height/proportion), height: UIScreen.main.bounds.size.height)
            } else {
                // normal image (max value is width)
                self.imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width*proportion)
            }
            self.imageView.center.y = UIScreen.main.bounds.size.height/2
            self.imageView.center.x = UIScreen.main.bounds.size.width/2
        }
    }
    
    fileprivate func updateScrollViewFrame() {
        if self.lastOrientation == .landscapeRight || self.lastOrientation == .landscapeLeft {
            self.scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        } else {
            self.scrollView.frame = UIScreen.main.bounds
        }
        self.scrollView.center.y = UIScreen.main.bounds.size.height/2
        self.scrollView.center.x = UIScreen.main.bounds.size.width/2
    }
    
    // ScrollView delegate method
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if self.lastOrientation == .landscapeRight || self.lastOrientation == .landscapeLeft {
            self.imageView.frame.origin.x = max(0, ((UIScreen.main.bounds.size.height/2)-(self.imageView.frame.size.width/2)))
            self.imageView.frame.origin.y = max(0, ((UIScreen.main.bounds.size.width/2)-(self.imageView.frame.size.height/2)))
        } else {
            self.imageView.frame.origin.x = max(0, ((UIScreen.main.bounds.size.width/2)-(self.imageView.frame.size.width/2)))
            self.imageView.frame.origin.y = max(0, ((UIScreen.main.bounds.size.height/2)-(self.imageView.frame.size.height/2)))
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Init Methods
    func prepareElements() {
        self.loadViewIfNeeded()
        self.view.backgroundColor = UIColor.black
        // Rotation Observer
//        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceRotated), name: UIDevice.NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        // Scroll View Delegate and zoom
        self.view.addSubview(self.scrollView)
        self.scrollView.transform = CGAffineTransform(rotationAngle: CGFloat(0).degreesToRadians())
        self.scrollView.frame = UIScreen.main.bounds
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        // Image View
        self.scrollView.addSubview(self.imageView)
        // Add close button
        self.view.addSubview(self.btnClose)
        self.btnClose.addWidthConstraint(60)
        self.btnClose.addHeightConstraint(60)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 0)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 10)
        self.updateBtnCloseFrame()
        // Update last orientation if it is landscape
        if UIDevice.current.orientation == .landscapeRight, UIDevice.current.orientation == .landscapeLeft {
            self.lastOrientation = UIDevice.current.orientation
        }
        self.updateRotation()
        self.updateScrollViewFrame()
        self.updateThumbFrame()
    }
    
    init(image:UIImage, referenceImageView:UIImageView) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
        self.referenceImageView = referenceImageView
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}









