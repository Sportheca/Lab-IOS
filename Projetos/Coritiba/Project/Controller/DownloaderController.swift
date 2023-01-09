//
//  DownloaderController.swift
//
//
//  Created by Roberto Oliveira on 22/01/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit
import QuickLook

enum DownloaderAction {
    case Share
    case Preview
}

var global_downloaderFilePresented = false
// Extension to UIViewControllers
extension UIViewController {
    func downloadFileWith(url:String, completionAction:DownloaderAction, name:String? = nil, fixedFileName:String, fixedFileSize:Int = 0) {
        if global_downloaderFilePresented == false {
            global_downloaderFilePresented = true
            let vc = DownloaderController(fileUrl: url, completionAction: completionAction, name: name)
            vc.fixedFileName = fixedFileName
            vc.fixedFileSize = fixedFileSize
            vc.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                self.present(vc, animated: false, completion: nil)
            })
        }
    }
}

protocol DownloaderControllerDelegate {
    func didFinishDownloadWith(fileLocation:URL)
}

class DownloaderController: UIViewController, URLSessionDownloadDelegate, QLPreviewControllerDataSource {
    
    // MARK: - Properties
    private var name:String?
    private var fileUrl:String = String()
    private var downloadedFileUrl = URL(string: "")
    private var completionAction:DownloaderAction = .Share
    private let configuration:URLSessionConfiguration = URLSessionConfiguration.default
    private let operationQueue = OperationQueue()
    private var urlSession:URLSession = URLSession()
    private var downloadTask:URLSessionDownloadTask = URLSessionDownloadTask()
    var fixedFileName:String = ""
    var fixedFileSize:Int = 0
    
    
    // MARK: - Objects
    private var containerView:RoundShadowView = {
        let vw = RoundShadowView()
        vw.radius = 10
        vw.shadow = true
        vw.backgroundColor = Theme.color(.PrimaryBackground)
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Baixando arquivo"
        return lbl
    }()
    private let progressView:CircularProgressView = {
        let vw = CircularProgressView()
        vw.updateColors(track: Theme.color(.MutedText), progress: Theme.color(.PrimaryAnchor), text: Theme.color(.PrimaryAnchor))
        vw.setProgress(0.0)
        return vw
    }()
    private lazy var btnCancel:UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitleColor(Theme.systemDestructiveColor, for: .normal)
        btn.setTitle("Cancelar", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        btn.addTarget(self, action: #selector(self.cancelMethod), for: .touchUpInside)
        return btn
    }()
    @objc func cancelMethod() {
        self.downloadTask.cancel()
        self.dismissWith(block: nil)
    }
    
    
    
    
    
    
    // MARK: - Methods
    private func downloadFile() {
        self.urlSession = URLSession(configuration: self.configuration, delegate: self, delegateQueue: self.operationQueue)
        guard let url = URL(string: self.fileUrl) else {return}
        self.downloadTask = self.urlSession.downloadTask(with: url)
        self.downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        var fileName = self.fileUrl.substringFrom(char: "/", at: .last, charIncluded: false)
        
        if let nameString = self.name {
            let fileExtension = fileName.substringFrom(char: ".", at: .last, charIncluded: true)
            fileName = nameString + fileExtension
        }
        
        if self.fixedFileName != "" {
            fileName = self.fixedFileName
        }
        
        fileName = fileName.removingPercentEncoding?.removingPercentEncoding ?? fileName
        fileName = fileName.replacingOccurrences(of: "-", with: " ")
        fileName = fileName.replacingOccurrences(of: "_", with: " ")
        
        
        do {
            let documentFolderURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            // Save downloaded files to specifc folder, so the App can remove the local files to save space
            let downloadsURL = documentFolderURL.appendingPathComponent(ProjectManager.downloadsPath)
            if !downloadsURL.hasDirectoryPath {
                try FileManager.default.createDirectory(at: downloadsURL, withIntermediateDirectories: false, attributes: nil)
            }
            
            // File URL is used to share and preview downloaded file
            let fileURL = downloadsURL.appendingPathComponent(fileName)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let _ = try FileManager.default.replaceItemAt(fileURL, withItemAt: location)
            } else {
                try FileManager.default.copyItem(at: location, to: fileURL)
            }
            
            DispatchQueue.main.async {
                self.btnCancel.isUserInteractionEnabled = false
                self.btnCancel.setTitleColor(UIColor(R: 220, G: 220, B: 220), for: .normal)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    self.progressView.bounceAnimation()
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                        // Dismiss and check what is the action to be performed
                        self.dismissWith(block: {
                            switch self.completionAction {
                            case .Share:
                                DispatchQueue.main.async {
                                    UIApplication.shared.shareItem(url: fileURL)
                                }
                            case .Preview:
                                DispatchQueue.main.async {
                                    self.previewItem(url: fileURL)
                                }
                            }
                        })
                    })
                })
            }
        } catch {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                self.dismissWith(block: {
                    DispatchQueue.main.async {
                        UIApplication.topViewController()?.basicAlert(message: "Falha ao conectar com o Servidor", handler: nil)
                    }
                })
            })
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        var totalExpected:Float = Float(totalBytesExpectedToWrite)
        if self.fixedFileSize > 0 {
            totalExpected = Float(self.fixedFileSize)
        }
        
        let value = Float(totalExpected)
        let percentage = (value == 0) ? 0 : Float(totalBytesWritten) / value
        let maxValue = min(percentage, 1)
        let minValue = max(0, maxValue)
        
        DispatchQueue.main.async {
            self.progressView.setProgress(minValue)
        }
    }
    
    
    
    
    
    
    
    // MARK: - Completion Methods
    private func previewItem(url:URL) {
        guard let topVc = UIApplication.topViewController() else {return}
        if QLPreviewController.canPreview(url as QLPreviewItem) {
            self.downloadedFileUrl = url
            let quickLookController = QLPreviewController()
            quickLookController.dataSource = self
            quickLookController.currentPreviewItemIndex = 0
            DispatchQueue.main.async {
                if let nav = topVc.navigationController {
                    nav.pushViewController(quickLookController, animated: true)
                } else {
                    topVc.present(quickLookController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.downloadedFileUrl! as QLPreviewItem
    }
    
    
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
        }
    }
    
    
    
    
    
    
    // MARK: - Init methods
    private func dismissWith(block: (()->Void)?) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, animations: {
                self.containerView.scaleTo(0.7)
                self.view.alpha = 0
            }, completion: { (_) in
                global_downloaderFilePresented = false
                if let navigationController = self.navigationController {
                    navigationController.popViewController(animated: true)
                    block?()
                } else {
                    self.dismiss(animated: false, completion: {
                        block?()
                    })
                }
            })
        }
    }
    
    private func prepareElements() {
        self.view.backgroundColor = UIColor.clear
        let backView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        self.view.addSubview(backView)
        self.view.addFullBoundsConstraintsTo(subView: backView, constant: 0)
        // Container View
        self.view.addSubview(self.containerView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.containerView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.containerView, constant: -20)
        let containerWidth = min(400, UIScreen.main.bounds.size.width-40)
        self.containerView.addWidthConstraint(containerWidth)
        // Title
        self.containerView.addSubview(self.lblTitle)
        self.containerView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 10, trailing: -10, top: 15, bottom: nil)
        self.lblTitle.addHeightConstraint(30)
        // Progress
        self.containerView.addSubview(self.progressView)
        self.progressView.addWidthConstraint(150)
        self.progressView.addHeightConstraint(150)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.progressView, constant: 0)
        self.containerView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.progressView, constant: 15)
        // Cancel Button
        self.containerView.addSubview(self.btnCancel)
        self.containerView.addVerticalSpacingTo(subView1: self.progressView, subView2: self.btnCancel, constant: 15)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.btnCancel, constant: 0)
        self.containerView.addBottomAlignmentConstraintTo(subView: self.btnCancel, constant: -15)
    }
    
    init(fileUrl:String, completionAction:DownloaderAction, name:String?) {
        super.init(nibName: nil, bundle: nil)
        self.prepareElements()
        self.name = name
        if !fileUrl.contains(otherString: "http") {
            self.fileUrl = ProjectManager.mainUrl + ProjectManager.filesPath + "PDFs/\(fileUrl)"
        } else {
            self.fileUrl = fileUrl
        }
        self.completionAction = completionAction
        self.downloadFile()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}















