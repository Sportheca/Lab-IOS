//
//  TweetMediaView.swift
//
//
//  Created by Roberto Oliveira on 27/09/18.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit
import WebKit
import AVKit

class TweetMediaView: UIView {
    
    // MARK: - Properties
    private var currentItem:TweetItem?
    private var session:URLSession = URLSession(configuration: URLSessionConfiguration.default)
    private var task:URLSessionDataTask?
    private var timer:Timer?
    private let webView:WKWebView = WKWebView()
    
    
    
    // MARK: - Objects
    private let loadingActivity:UIActivityIndicatorView = {
        let vw = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        vw.color = UIColor.white.withAlphaComponent(0.5)
        vw.hidesWhenStopped = true
        return vw
    }()
    // Image
    private let ivCover:FullScreenImageView = {
        let iv = FullScreenImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    // GIF
    private lazy var gifView:TwitterMediaGIFPlayerView = {
        let vw = TwitterMediaGIFPlayerView()
        vw.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.gifTapMethod)))
        return vw
    }()
    @objc func gifTapMethod() {
        guard let item = self.currentItem else {return}
        guard let videoUrlString = item.mediaUrl else {return}
        guard let videoURL = URL(string: videoUrlString) else {return}
        let player = AVPlayer(url: videoURL)
        let playerVc = TwitterPlayerViewController()
        playerVc.loop = true
        playerVc.player = player
        DispatchQueue.main.async {
            guard let topVc = UIApplication.topViewController() else {return}
            playerVc.modalPresentationStyle = .fullScreen
            topVc.present(playerVc, animated: true, completion: {
                playerVc.player?.play()
            })
        }
    }
    // Video
    private lazy var videoView:TwitterMediaVideoPlayerView = {
        let vw = TwitterMediaVideoPlayerView()
        vw.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.videoTapMethod)))
        return vw
    }()
    private lazy var ivPlay:CustomButton = {
        let iv = CustomButton()
        iv.imageView?.contentMode = .scaleAspectFit
        iv.tintColor = UIColor.white
        iv.setImage(UIImage(named: "icon_play")?.withRenderingMode(.alwaysTemplate), for: .normal)
        iv.layer.shadowRadius = 2.0
        iv.layer.shadowOpacity = 0.2
        iv.layer.shadowOffset = CGSize.zero
        iv.addTarget(self, action: #selector(self.videoTapMethod), for: .touchUpInside)
        return iv
    }()
    private lazy var tapGesture:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.videoTapMethod))
    @objc func videoTapMethod() {
        print("videoTapMethod")
        guard let item = self.currentItem else {return}
        
        guard let videoUrlString = item.mediaUrl else {return}
        guard let videoURL = URL(string: videoUrlString) else {return}
        let player = AVPlayer(url: videoURL)
        let playerVc = TwitterPlayerViewController()
        playerVc.loop = false//(item.mediaType == .GIF)
        playerVc.player = player
        DispatchQueue.main.async {
            guard let topVc = UIApplication.topViewController() else {return}
            playerVc.modalPresentationStyle = .fullScreen
            topVc.present(playerVc, animated: true, completion: {
                playerVc.player?.play()
            })
        }
    }
    
    
    
    
    // MARK: - Methods
    func updateContent(item:TweetItem) {
        self.currentItem = item
        self.loadingActivity.startAnimating()
        
        if item.mediaUrl != nil && item.mediaType != nil {
            self.showContent()
        } else {
            self.ivCover.isHidden = true
            self.gifView.isHidden = true
            self.videoView.isHidden = true
            self.loadMediaContent()
        }
    }
    
    private func showContent() {
        guard let type = self.currentItem?.mediaType, let urlString = self.currentItem?.mediaUrl else {return}
        switch type {
        case .Image:
            // Hide gif and video
            self.gifView.isHidden = true
            self.videoView.isHidden = true
            self.ivPlay.isHidden = true
            // Show image
            self.ivCover.setServerImage(urlString: urlString)
            self.ivCover.isHidden = false
            self.tapGesture.isEnabled = false
            
        case .Video:
//            // Hide image and gif
//            self.ivCover.image = nil
//            self.ivCover.isHidden = true
//            self.gifView.isHidden = true
//            // Video
//            self.videoView.isHidden = false
//            self.videoView.playVideo(urlString: urlString)
            // Hide gif and video
            self.gifView.isHidden = true
            self.videoView.isHidden = true
            self.ivPlay.isHidden = false
            // Show image
            self.ivCover.setServerImage(urlString: self.currentItem?.thumbUrl)
            self.ivCover.isHidden = false
            self.tapGesture.isEnabled = true
            
        case .GIF:
            // Hide image and video
            self.ivCover.image = nil
            self.ivCover.isHidden = true
            self.videoView.isHidden = true
            self.ivPlay.isHidden = true
            // Show GIF
            self.gifView.playGIF(urlString: urlString)
            self.gifView.isHidden = false
            self.tapGesture.isEnabled = false
        }
    }
    
    
    
    
    
    
    // MARK: - Load Media Methods
    private func loadMediaContent() {
        guard let item = self.currentItem else {return}
        guard let url = URL(string: item.mediaLink) else {return}
        
        self.timer?.invalidate()
        self.timer = nil
        self.task?.cancel()
        self.task = self.session.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            guard let dataObject = data, let htmlString = String(data: dataObject, encoding: String.Encoding.utf8) else {return}
            guard let link = self.currentItem?.mediaLink, link == url.absoluteString else {return}
            // Check if it is a Video or GIF
            if htmlString.contains("og:video:url\" content=\"") {
                let components = htmlString.components(separatedBy: "og:video:url\" content=\"")
                guard components.count > 1, let videoUrl = URL(string: components[1].components(separatedBy: "\"").first ?? "") else {return}
                DispatchQueue.main.async {
                    self.webView.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
                    self.webView.load(URLRequest(url: videoUrl))
                    self.webViewUrlString = url.absoluteString
                    self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.checkWebViewContent), userInfo: nil, repeats: true)
                    RunLoop.main.add(self.timer!, forMode: .common)
                }
                return
            }
            
            // If it is not a video, check if it is an Image
            if htmlString.contains("og:image\" content=\"") {
                let components = htmlString.components(separatedBy: "og:image\" content=\"")
                guard components.count > 1, let imageUrl = URL(string: components[1].components(separatedBy: "\"").first ?? "") else {return}
                DispatchQueue.main.async {
                    if url.absoluteString == self.currentItem?.mediaLink {
                        self.currentItem?.mediaUrl = imageUrl.absoluteString
                        self.currentItem?.mediaType = .Image
                        self.showContent()
                    }
                }
                return
            }
            
        }
        self.task?.resume()
    }
    
    var webViewUrlString:String?
    // MARK: - Timer Method
    @objc func checkWebViewContent() {
        self.webView.evaluateJavaScript("document.documentElement.outerHTML") { (object:Any?, error:Error?) in
            let contentString = object as? String ?? ""
            // Check if it is video or GIF (GIF is an mp4 file)
            var mediaType:TweetItemMediaType?
            if contentString.contains(".m3u8") {
                mediaType = .Video
            } else if contentString.contains(".mp4") {
                mediaType = .GIF
            }
            // Call Completion if media is founded
            if mediaType != nil {
                self.timer?.invalidate()
                self.timer = nil
                let components = contentString.components(separatedBy: "src=\"")
                
                // Completion for Videos
                if mediaType == .Video {
                    for component in components {
                        if component.contains("m3u8") {
                            let link = component.components(separatedBy: "\"").first ?? ""
                            if self.webViewUrlString == self.currentItem?.mediaLink {
                                self.currentItem?.mediaUrl = link
                                self.currentItem?.mediaType = .Video
                                self.showContent()
                            }
                            return
                        }
                    }
                }
                
                // Completion for GIFs
                if mediaType == .GIF {
                    for component in components {
                        if component.contains("mp4") {
                            let link = component.components(separatedBy: "\"").first ?? ""
                            if self.webViewUrlString == self.currentItem?.mediaLink {
                                self.currentItem?.mediaUrl = link
                                self.currentItem?.mediaType = .GIF
                                self.showContent()
                            }
                            return
                        }
                    }
                }
                
            }
        }
        return
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor(R: 230, G: 230, B: 230)
        // Loading
        self.addSubview(self.loadingActivity)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingActivity, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.loadingActivity, constant: 0)
        // Image View
        self.addSubview(self.ivCover)
        self.addFullBoundsConstraintsTo(subView: self.ivCover, constant: 0)
        self.ivCover.addGestureRecognizer(self.tapGesture)
        // GIF Player
        self.addSubview(self.gifView)
        self.addFullBoundsConstraintsTo(subView: self.gifView, constant: 0)
        // Video Player
        self.addSubview(self.videoView)
        self.addFullBoundsConstraintsTo(subView: self.videoView, constant: 0)
        self.addSubview(self.ivPlay)
        self.addCenterXAlignmentConstraintTo(subView: self.ivPlay, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.ivPlay, constant: 0)
        self.ivPlay.addHeightConstraint(40)
        self.ivPlay.addWidthConstraint(40)
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




import AVKit
// MARK: - Video Players
class TwitterPlayerViewController: AVPlayerViewController {
    var loop:Bool = false
    @objc func playerItemDidReachEnd() {
        if self.loop {
            self.player?.seek(to: CMTime.zero)
            self.player?.play()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(TwitterPlayerViewController.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}



class TwitterMediaGIFPlayerView: UIView {
    
    // MARK: - Properties
    private let imageView:GIFImageView = {
        let iv = GIFImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    
    
    // MARK: - Methods
    func playGIF(urlString: String) {
        self.imageView.loadGIF(urlString: urlString)
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.imageView)
        self.addFullBoundsConstraintsTo(subView: self.imageView, constant: 0)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


import WebKit

class TwitterMediaVideoPlayerView: UIView, UIScrollViewDelegate {
    
    // MARK: - Objects
    private lazy var webView:WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypes.video
        let vw = WKWebView(frame: CGRect.zero, configuration: configuration)
        vw.scrollView.delegate = self
        vw.isOpaque = false
        vw.backgroundColor = UIColor.black
        vw.scrollView.isScrollEnabled = false
        return vw
    }()
    
    
    
    // MARK: - Methods
    func playVideo(urlString: String) {
        let string:String = urlString.contains(otherString: "http") ? urlString : "https://www.youtube.com/embed/\(urlString)"
        guard let url = URL(string: string) else {return}
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url))
        }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.black
        self.addSubview(self.webView)
        self.addFullBoundsConstraintsTo(subView: self.webView, constant: 0)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    deinit {
        self.webView.scrollView.delegate = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
    
}







// This extension allows cancelling the previous request before requesting a new one
var global_gif_data:[String:Data] = [:]
class GIFImageView:UIImageView {
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var imageUrlString:String = ""
    
    func loadGIF(urlString:String) {
        DispatchQueue.main.async {
            self.image = nil
        }
        
        self.dataTask?.cancel()
        let fileUrlString = urlString.contains(otherString: "http") ? urlString : "\(ProjectManager.mainUrl)\(ProjectManager.imagesPath)\(urlString)"
        if let url = URL(string: fileUrlString) {
            
            self.imageUrlString = fileUrlString
            // Check Cash for image first
            if let cachedImage = imageCache.object(forKey: fileUrlString as AnyObject) as? UIImage {
                if self.imageUrlString == fileUrlString {
                    DispatchQueue.main.async {
                        self.image = cachedImage
                    }
                }
                return
            }
            
            // Create HTTP request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            // TimeOut
            request.timeoutInterval = 15.0 // 15 seconds to timeOut
            
            // Create and resume Task
            self.dataTask = self.defaultSession.dataTask(with: request, completionHandler: { (dataObj:Data?, responseObj:URLResponse?, errorObj:Error?) in
                if let data = dataObj {
                    guard let img = UIImage.gifImageWithData(data) else {return}
                    imageCache.setObject(img, forKey: fileUrlString as AnyObject)
                    global_gif_data[urlString] = data
                    if self.imageUrlString == fileUrlString {
                        DispatchQueue.main.async {
                            self.image = img
                        }
                    }
                }
                
            })
            self.dataTask?.resume()
        } else {
            // Not possible to create url
        }
    }
    
}
