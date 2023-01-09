//
//  AudioLibraryLargePlayerControllersView.swift
//  
//
//  Created by Roberto Oliveira on 3/25/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit
import AVKit

class AudioLibraryLargePlayerControllersView: UIView {
    
    // MARK: - Objects
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.adjustsImageWhenHighlighted = false
        btn.imageEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        btn.imageView?.tintColor = Theme.color(Theme.Color.AudioLibraryMainButtonText)
        btn.backgroundColor = Theme.color(Theme.Color.AudioLibraryMainButtonBackground)
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    private let downloadProgressView:RoundTimerView = {
        let vw = RoundTimerView()
        vw.lineWidth = 2.0
        vw.isUserInteractionEnabled = false
        vw.updateColors(track: UIColor.clear, progress: Theme.color(.AudioLibraryMainButtonBackground), text: Theme.color(Theme.Color.AudioLibraryMainButtonText))
        vw.setProgress(0, duration: nil)
        return vw
    }()
    private lazy var btnPrevious:CustomButton = {
        let btn = CustomButton()
        btn.adjustsImageWhenHighlighted = false
        btn.imageEdgeInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        btn.imageView?.tintColor = Theme.color(Theme.Color.AudioLibrarySecondaryButtonText)
        btn.backgroundColor = Theme.color(Theme.Color.AudioLibrarySecondaryButtonBackground)
        btn.setImage(UIImage(named: "btn_audio_library_previous")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.previousTrackAction), for: .touchUpInside)
        return btn
    }()
    private lazy var btnNext:CustomButton = {
        let btn = CustomButton()
        btn.adjustsImageWhenHighlighted = false
        btn.imageEdgeInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        btn.imageView?.tintColor = Theme.color(Theme.Color.AudioLibrarySecondaryButtonText)
        btn.backgroundColor = Theme.color(Theme.Color.AudioLibrarySecondaryButtonBackground)
        btn.setImage(UIImage(named: "btn_audio_library_next")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.nextTrackAction), for: .touchUpInside)
        return btn
    }()
    private lazy var btnForward15:CustomButton = {
        let btn = CustomButton()
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(UIImage(named: "btn_audio_library_forward_15")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = Theme.color(Theme.Color.PrimaryText)
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(self.forwardAction), for: .touchUpInside)
        return btn
    }()
    private lazy var btnRewind15:CustomButton = {
        let btn = CustomButton()
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(UIImage(named: "btn_audio_library_back_15")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = Theme.color(Theme.Color.PrimaryText)
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(self.rewindAction), for: .touchUpInside)
        return btn
    }()
    private lazy var defaultSlider:UISlider = {
        let vw = UISlider()
        vw.tintColor = Theme.color(.PrimaryText)
        vw.thumbTintColor = Theme.color(.PrimaryText)
        vw.layer.shadowRadius = 5.0
        vw.layer.shadowOpacity = 1.0
        vw.layer.shadowOffset = CGSize(width: 0, height: 0)
        vw.layer.shadowColor = Theme.color(.PrimaryText).cgColor
        vw.minimumValue = 0.0
        vw.maximumValue = 1.0
        vw.value = 0
        vw.addTarget(self, action: #selector(self.sliderAction), for: .valueChanged)
        return vw
    }()
    private let lblCurrentTime:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 12)
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    private let lblTotalTime:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 12)
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    private let actionsStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        vw.distribution = .equalSpacing
        return vw
    }()
    private let btnTag:IconButton = {
        let btn = IconButton(iconLeading: 17, iconTop: 5, iconBottom: 5, horizontalSpacing: 4, titleTrailing: 17, titleTop: 0, titleBottom: 0)
        btn.lblTitle.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 11)
        btn.layer.cornerRadius = 11
        btn.clipsToBounds = true
        btn.isUserInteractionEnabled = false
        return btn
    }()
    private lazy var btnLyrics:CustomButton = {
        let btn = self.actionButton(iconName: "btn_audio_library_lyrics")
        btn.addTarget(self, action: #selector(self.lyricsAction), for: .touchUpInside)
        return btn
    }()
    private lazy var btnRepeat:CustomButton = {
        let btn = self.actionButton(iconName: "btn_audio_library_repeat")
        btn.addTarget(self, action: #selector(self.repeatAction), for: .touchUpInside)
        return btn
    }()
    private lazy var btnShuffle:CustomButton = {
        let btn = self.actionButton(iconName: "btn_audio_library_shuffle")
        btn.addTarget(self, action: #selector(self.shuffleAction), for: .touchUpInside)
        return btn
    }()
    private lazy var btnMute:CustomButton = {
        let btn = self.actionButton(iconName: "btn_audio_library_mute_off")
        btn.addTarget(self, action: #selector(self.muteAction), for: .touchUpInside)
        return btn
    }()
    private func actionButton(iconName:String) -> CustomButton {
        let btn = CustomButton()
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.layer.shadowOpacity = 1.0
        btn.layer.shadowRadius = 15.0
        btn.layer.shadowOffset = CGSize(width: 0, height: 0)
        return btn
    }
    
    
    
    
    
    
    // MARK: - Methods
    @objc func lyricsAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibraryPlayer.lyricsAction, trackValue: AudioLibraryManager.shared.currentItem?.id)
        guard let item = AudioLibraryManager.shared.currentItem else {return}
        if AudioLibraryManager.shared.lyricsDataSource[item.id] == nil {
            DispatchQueue.main.async {
                UIApplication.topViewController()?.statusAlert(message: "Letra Indisponível", style: .Negative)
            }
            return
        }
        AudioLibraryManager.shared.isLyricsEnabled = !AudioLibraryManager.shared.isLyricsEnabled
    }
    
    @objc func repeatAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibraryPlayer.repeatAction, trackValue: AudioLibraryManager.shared.currentItem?.id)
        AudioLibraryManager.shared.isRepeatEnabled = !AudioLibraryManager.shared.isRepeatEnabled
    }
    
    @objc func shuffleAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibraryPlayer.shuffleAction, trackValue: AudioLibraryManager.shared.currentItem?.id)
        AudioLibraryManager.shared.isShuffleEnabled = !AudioLibraryManager.shared.isShuffleEnabled
    }
    
    @objc func muteAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibraryPlayer.muteAction, trackValue: AudioLibraryManager.shared.currentItem?.id)
        AudioLibraryManager.shared.isMuteEnabled = !AudioLibraryManager.shared.isMuteEnabled
    }
    
    @objc func confirm() {
        guard let item = AudioLibraryManager.shared.currentItem else {return}
        let urlString = item.fileUrlString ?? ""
        guard AudioLibraryManager.isDownloaded(urlString: urlString) else {
            // Start download
            ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibraryPlayer.download, trackValue: AudioLibraryManager.shared.currentItem?.id)
            AudioLibraryManager.shared.download(id: item.id, sufix: urlString)
            return
        }
        if AudioLibraryPlayer.shared.isPlaying {
            ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibraryPlayer.pause, trackValue: AudioLibraryManager.shared.currentItem?.id)
            AudioLibraryPlayer.shared.player?.pause()
            AudioLibraryPlayer.shared.isPlaying = false
        } else {
            ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibraryPlayer.play, trackValue: AudioLibraryManager.shared.currentItem?.id)
            AudioLibraryPlayer.shared.player?.play()
            AudioLibraryPlayer.shared.isPlaying = true
        }
        DispatchQueue.main.async {
            self.updateInterface()
        }
    }
    
    @objc func updateInterface() {
        DispatchQueue.main.async {
            let isPlaying = AudioLibraryPlayer.shared.isPlaying
            self.updateTag(isPlaying: isPlaying)
            let iconName = isPlaying ? "btn_audio_library_pause" : "btn_audio_library_play"
            self.btnConfirm.setImage(UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate), for: .normal)
            
            // Actions
            let actionInactiveColor = Theme.color(.MutedText)
            let actionActiveColor = Theme.color(.PrimaryText)
            self.btnLyrics.tintColor = AudioLibraryManager.shared.isLyricsEnabled ? actionActiveColor : actionInactiveColor
            self.btnLyrics.layer.shadowColor = AudioLibraryManager.shared.isLyricsEnabled ? actionActiveColor.cgColor : UIColor.clear.cgColor
            if let item = AudioLibraryManager.shared.currentItem {
                if AudioLibraryManager.shared.lyricsDataSource[item.id] == nil {
                    self.btnLyrics.tintColor = Theme.color(.PrimaryText).withAlphaComponent(0.5)
                }
            }
            self.btnRepeat.tintColor = AudioLibraryManager.shared.isRepeatEnabled ? actionActiveColor : actionInactiveColor
            self.btnRepeat.layer.shadowColor = AudioLibraryManager.shared.isRepeatEnabled ? actionActiveColor.cgColor : UIColor.clear.cgColor
            self.btnShuffle.tintColor = AudioLibraryManager.shared.isShuffleEnabled ? actionActiveColor : actionInactiveColor
            self.btnShuffle.layer.shadowColor = AudioLibraryManager.shared.isShuffleEnabled ? actionActiveColor.cgColor : UIColor.clear.cgColor
            self.btnMute.tintColor = AudioLibraryManager.shared.isMuteEnabled ? actionActiveColor : actionInactiveColor
            self.btnMute.layer.shadowColor = AudioLibraryManager.shared.isMuteEnabled ? actionActiveColor.cgColor : UIColor.clear.cgColor
            let muteIconName = AudioLibraryManager.shared.isMuteEnabled ? "btn_audio_library_mute_on" : "btn_audio_library_mute_off"
            self.btnMute.setImage(UIImage(named: muteIconName)?.withRenderingMode(.alwaysTemplate), for: .normal)
            
            // Next & Previous
            let secondaryButtonIconColor = Theme.color(Theme.Color.AudioLibrarySecondaryButtonText)
            let currentIndex = AudioLibraryManager.shared.currentIndex
            let isPreviousEnabled = currentIndex > 0
            let isNextEnabled = currentIndex < AudioLibraryManager.shared.dataSource.count-1
            let nextIconColor = isNextEnabled ? secondaryButtonIconColor : secondaryButtonIconColor.withAlphaComponent(0.5)
            self.btnNext.imageView?.tintColor = nextIconColor
            self.btnNext.isUserInteractionEnabled = isNextEnabled
            let previousIconColor = isPreviousEnabled ? secondaryButtonIconColor : secondaryButtonIconColor.withAlphaComponent(0.5)
            self.btnPrevious.imageView?.tintColor = previousIconColor
            self.btnPrevious.isUserInteractionEnabled = isPreviousEnabled
            
            // Download
            if AudioLibraryManager.isDownloaded(urlString: AudioLibraryManager.shared.currentItem?.fileUrlString ?? "") {
                self.btnTag.alpha = 1.0
                self.btnRewind15.alpha = 1.0
                self.btnForward15.alpha = 1.0
                self.downloadProgressView.isHidden = true
                self.downloadProgressView.setProgress(0, duration: nil)
                self.defaultSlider.isUserInteractionEnabled = true
            } else {
                self.btnTag.alpha = 0.0
                self.btnRewind15.alpha = 0.0
                self.btnForward15.alpha = 0.0
                self.btnConfirm.setImage(nil, for: .normal)
                if let item = AudioLibraryManager.shared.currentItem {
                    if !AudioLibraryManager.shared.downloadingIds.contains(item.id) {
                        self.downloadProgressView.setProgress(0, duration: nil)
                        self.downloadProgressView.lblTitle.text = "Baixar"
                        self.downloadProgressView.lblTitle.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
                        self.downloadProgressView.isHidden = false
                    }
                }
                self.defaultSlider.setValue(0, animated: false)
                self.defaultSlider.isUserInteractionEnabled = false
            }
            
            // Time Track
            self.lblCurrentTime.text = AudioLibraryPlayer.shared.currentTimeDescription()
            self.lblTotalTime.text = AudioLibraryPlayer.shared.totalTimeDescription()
            guard !self.defaultSlider.isTouchInside else {return}
            guard let a = AudioLibraryPlayer.shared.player?.currentTime().seconds, let b = AudioLibraryPlayer.shared.player?.currentItem?.duration.seconds else {return}
            let progress:Float = (b == 0) ? 0 : Float(a)/Float(b)
            self.defaultSlider.setValue(progress, animated: true)
        }
    }
    
    private func updateTag(isPlaying:Bool) {
        var tagColor = Theme.color(.PrimaryCardElements)
        var tagBackColor = Theme.color(.PrimaryCardBackground)
        var tagIcon = "icon_pause"
        var tagTitle = "PAUSADO"
        if isPlaying {
            tagColor = Theme.color(.PrimaryAnchor)
            tagBackColor = Theme.color(.PrimaryAnchor).withAlphaComponent(0.3)
            tagIcon = "icon_play"
            tagTitle = "TOCANDO"
        }
        self.btnTag.lblTitle.textColor = tagColor
        self.btnTag.backgroundColor = tagBackColor.withAlphaComponent(0.3)
        self.btnTag.updateContent(icon: UIImage(named: tagIcon)?.withRenderingMode(.alwaysTemplate), title: tagTitle)
        self.btnTag.tintColor = tagColor
    }
    
    @objc func sliderAction() {
        guard let total = AudioLibraryPlayer.shared.player?.currentItem?.duration.seconds else {return}
        let time = total * Double(self.defaultSlider.value)
        AudioLibraryPlayer.shared.player?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
    
    @objc func forwardAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibraryPlayer.forward15, trackValue: AudioLibraryManager.shared.currentItem?.id)
        guard let current = AudioLibraryPlayer.shared.player?.currentTime().seconds, let total = AudioLibraryPlayer.shared.player?.currentItem?.duration.seconds else {return}
        let time = min(total, current+15)
        AudioLibraryPlayer.shared.player?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
    
    @objc func rewindAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibraryPlayer.rewind15, trackValue: AudioLibraryManager.shared.currentItem?.id)
        guard let current = AudioLibraryPlayer.shared.player?.currentTime().seconds else {return}
        let time = max(0, current-15)
        AudioLibraryPlayer.shared.player?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
    
    @objc func nextTrackAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibraryPlayer.nextTrack, trackValue: AudioLibraryManager.shared.currentItem?.id)
        AudioLibraryManager.shared.nextTrack()
    }
    
    @objc func previousTrackAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibraryPlayer.previousTrack, trackValue: AudioLibraryManager.shared.currentItem?.id)
        AudioLibraryManager.shared.previousTrack()
    }
    
    @objc func downloadProgressUpdated(_ notification:Notification) {
        guard let info = notification.object as? AudioLibraryDownloadInfo, let item = AudioLibraryManager.shared.currentItem else {return}
        guard info.id == item.id else {return}
        DispatchQueue.main.async {
            let progress = Int(info.progress*100)
            self.downloadProgressView.isHidden = false
            self.downloadProgressView.setProgress(info.progress, duration: nil)
            self.downloadProgressView.lblTitle.text = "\(progress.description)%"
            self.downloadProgressView.lblTitle.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 16)
            guard info.progress >= 1.0 else {return}
            AudioLibraryPlayer.shared.play(id: item.id, localFileUrl: item.fileUrlString ?? "")
        }
    }
    
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadProgressUpdated(_:)), name: NSNotification.Name(AudioLibraryDownloadManager.notification_downloadProgressUpdated), object: nil)
        
        var size0:CGFloat = 80
        var size1:CGFloat = 54
        var size2:CGFloat = 35
        if UIScreen.main.bounds.height < 667 {
            size0 = 65
            size1 = 45
            size2 = 35
        }
        
        // Confirm
        self.addSubview(self.btnConfirm)
        self.btnConfirm.addHeightConstraint(size0)
        self.btnConfirm.addWidthConstraint(size0)
        self.btnConfirm.layer.cornerRadius = size0/2
        self.addCenterXAlignmentConstraintTo(subView: self.btnConfirm, constant: 0)
        self.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.btnConfirm, constant: -5)
        // Download
        self.addSubview(self.downloadProgressView)
        self.addCenterXAlignmentRelatedConstraintTo(subView: self.downloadProgressView, reference: self.btnConfirm, constant: 0)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.downloadProgressView, reference: self.btnConfirm, constant: 0)
        self.addWidthRelatedConstraintTo(subView: self.downloadProgressView, reference: self.btnConfirm, relatedBy: .equal, multiplier: 1.0, constant: 10.0, priority: 999)
        self.addHeightRelatedConstraintTo(subView: self.downloadProgressView, reference: self.btnConfirm, relatedBy: .equal, multiplier: 1.0, constant: 10.0, priority: 999)
        // Previous
        self.addSubview(self.btnPrevious)
        self.btnPrevious.addHeightConstraint(size1)
        self.btnPrevious.addWidthConstraint(size1)
        self.addHorizontalSpacingTo(subView1: self.btnPrevious, subView2: self.btnConfirm, constant: 10)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.btnPrevious, reference: self.btnConfirm, constant: 0)
        self.btnPrevious.layer.cornerRadius = size1/2
        // Next
        self.addSubview(self.btnNext)
        self.btnNext.addHeightConstraint(size1)
        self.btnNext.addWidthConstraint(size1)
        self.addHorizontalSpacingTo(subView1: self.btnConfirm, subView2: self.btnNext, constant: 10)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.btnNext, reference: self.btnConfirm, constant: 0)
        self.btnNext.layer.cornerRadius = size1/2
        // Rewind
        self.addSubview(self.btnRewind15)
        self.btnRewind15.addWidthConstraint(size2)
        self.btnRewind15.addHeightConstraint(size2)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.btnRewind15, reference: self.btnConfirm, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.btnRewind15, subView2: self.btnPrevious, constant: 20)
        // Forward
        self.addSubview(self.btnForward15)
        self.btnForward15.addWidthConstraint(size2)
        self.btnForward15.addHeightConstraint(size2)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.btnForward15, reference: self.btnConfirm, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.btnNext, subView2: self.btnForward15, constant: 20)
        // Slider
        self.addSubview(self.defaultSlider)
        self.addVerticalSpacingTo(subView1: self.defaultSlider, subView2: self.btnConfirm, constant: 15)
        self.addLeadingAlignmentRelatedConstraintTo(subView: self.defaultSlider, reference: self.btnRewind15, constant: 0)
        self.addTrailingAlignmentRelatedConstraintTo(subView: self.defaultSlider, reference: self.btnForward15, constant: 0)
        // Current Time
        self.addSubview(self.lblCurrentTime)
        self.addVerticalSpacingTo(subView1: self.defaultSlider, subView2: self.lblCurrentTime, constant: 0)
        self.addLeadingAlignmentRelatedConstraintTo(subView: self.lblCurrentTime, reference: self.defaultSlider, constant: 0)
        // Total Time
        self.addSubview(self.lblTotalTime)
        self.addTopAlignmentRelatedConstraintTo(subView: self.lblTotalTime, reference: self.lblCurrentTime, constant: 0)
        self.addTrailingAlignmentRelatedConstraintTo(subView: self.lblTotalTime, reference: self.defaultSlider, constant: 0)
        // Tag
        self.addSubview(self.btnTag)
        self.addCenterXAlignmentConstraintTo(subView: self.btnTag, constant: 0)
        self.addTopAlignmentConstraintTo(subView: self.btnTag, constant: 0)
        self.btnTag.addHeightConstraint(22)
        // Actions
        self.addSubview(self.actionsStackView)
        self.addLeadingAlignmentRelatedConstraintTo(subView: self.actionsStackView, reference: self.defaultSlider, constant: 0)
        self.addTrailingAlignmentRelatedConstraintTo(subView: self.actionsStackView, reference: self.defaultSlider, constant: 0)
        self.addVerticalSpacingTo(subView1: self.actionsStackView, subView2: self.defaultSlider, constant: 15)
        let actionsSize:CGFloat = 35.0
        self.actionsStackView.addArrangedSubview(self.btnLyrics)
        self.btnLyrics.addWidthConstraint(actionsSize)
        self.btnLyrics.addHeightConstraint(actionsSize)
        self.actionsStackView.addArrangedSubview(self.btnRepeat)
        self.btnRepeat.addWidthConstraint(actionsSize)
        self.btnRepeat.addHeightConstraint(actionsSize)
        self.actionsStackView.addArrangedSubview(self.btnShuffle)
        self.btnShuffle.addWidthConstraint(actionsSize)
        self.btnShuffle.addHeightConstraint(actionsSize)
        self.actionsStackView.addArrangedSubview(self.btnMute)
        self.btnMute.addWidthConstraint(actionsSize)
        self.btnMute.addHeightConstraint(actionsSize)
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] (_)  in
            self?.updateInterface()
        }
    }

    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
        self.updateInterface()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
