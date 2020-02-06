//
//  YMPlayer.swift
//  CustomVideoPlayer
//
//  Created by Yasheed Muhammed on 02/02/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation
import UIKit
import AVKit

public class YMPlayerManager: NSObject {
    // MARK: - Properties
    private var avPlayer: AVPlayer!
    public var playerLayer: AVPlayerLayer!
    private var avPlayerItems: [AVPlayerItem]!
    private var palyerView: UIView!
    private var periodicTimeObserver: Any!
    private var contentView: UIView!
    private var isFullScreen = false
    private var originalFrame =  CGRect.zero
    private var contentViewInRootVC: UIView!
    weak var dataSource: YMPlayerDataSource? {
        didSet {
            reloadData()
        }
    }
    weak var valueUpdateDelegate: YMVideoControllersValueUpdateDelegate?
    
    /// Custom Properties
    public var videoGravity: AVLayerVideoGravity = .resizeAspect
    
    init(_ playerView: UIView, _ contentView: UIView) {
        self.palyerView = playerView
        self.contentView = contentView
        contentViewInRootVC = contentView
        originalFrame = contentView.frame
        avPlayer = AVPlayer()
        playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.videoGravity = videoGravity
        playerLayer.frame = playerView.bounds
        self.palyerView.layer.addSublayer(playerLayer)
    }
    
    /// Removes all AVPlayerItem and reload the AVPlayer
    public func reloadData() {
        guard let dataSource = dataSource else { return }
        if let _ = avPlayerItems {
            avPlayerItems.removeAll()
        }
        let videoPaths = dataSource.videoPathsForYMPlayer()
        if !videoPaths.isEmpty {
            let urls = videoPaths.compactMap({ URL(string: $0.percentEncoded())})
            avPlayerItems = urls.map({ AVPlayerItem(url: $0) })
            avPlayer.replaceCurrentItem(with: avPlayerItems.first)
            valueUpdateDelegate?.updatePreviousButtonStatus(isEnabled: false)
            addObservers()
            updateCurrentTime()
            updateOverAllTime()
            valueUpdateDelegate?.updateActivityIndicator(isHidden: true)
        }
    }
    
    private func addObservers() {
        let interVal = CMTime(value: 1, timescale: CMTimeScale(NSEC_PER_SEC))
        if let observer = periodicTimeObserver {
            avPlayer.removeTimeObserver(observer)
            avPlayer.removeObserver(self,
                                    forKeyPath: ObserverName.timeControlStatus.rawValue)
        }
        periodicTimeObserver = avPlayer.addPeriodicTimeObserver(forInterval: interVal,
                                                                     queue: DispatchQueue.main) { [weak self] (time) in
                                                                        self?.periodicTimeRecieved(time: time)
        }
        avPlayer.addObserver(self, forKeyPath: ObserverName.timeControlStatus.rawValue,
                             options: [.old, .new], context: nil)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let observerName = ObserverName.timeControlStatus.rawValue
        if keyPath == observerName,
            let change = change,
            let newValue = change[NSKeyValueChangeKey.newKey] as? Int,
            let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async { [weak self] in
                    if newStatus == .playing || newStatus == .paused {
                        // hide buffer view
                        self?.valueUpdateDelegate?.updateActivityIndicator(isHidden: true)
                    } else {
                        self?.valueUpdateDelegate?.updateActivityIndicator(isHidden: false)
                        //show buffer view
                    }
                }
            }
        }
    }
}

// MARK: - YMVideoControllersDelegate
/// Handling controller actions
extension YMPlayerManager: YMVideoControllersDelegate {
    
    public func nextButtonPressed() {
        guard let currentItem = avPlayer.currentItem else { return }
        guard let indexOfCurrentItem = avPlayerItems.firstIndex(where: { $0 == currentItem }) else { return }
        if indexOfCurrentItem < avPlayerItems.count - 1 {
            changeVideo(to: indexOfCurrentItem + 1)
            valueUpdateDelegate?.updatePreviousButtonStatus(isEnabled: true)
            if indexOfCurrentItem + 1 == avPlayerItems.count - 1 {
                valueUpdateDelegate?.updateNextButtonStatus(isEnabled: false)
            }
        }
    }
    
    public func previousButtonPressed() {
        guard let currentItem = avPlayer.currentItem else { return }
        guard let indexOfCurrentItem = avPlayerItems.firstIndex(where: { $0 == currentItem }) else { return }
        if indexOfCurrentItem > 0 {
            changeVideo(to: indexOfCurrentItem - 1)
            valueUpdateDelegate?.updateNextButtonStatus(isEnabled: true)
            if indexOfCurrentItem - 1 == 0 {
                valueUpdateDelegate?.updatePreviousButtonStatus(isEnabled: false)
            }
        }
    }
    
    public func playButtonPressed(sender: UIButton) {
        if isVideoPlaybackFinished() {
            avPlayer.seek(to: CMTime.zero)
        }
        sender.isSelected ? avPlayer.pause() : avPlayer.play()
        sender.isSelected ? valueUpdateDelegate?.updatePlayButton(to: .play)  : valueUpdateDelegate?.updatePlayButton(to: .pause)
    }
    
    public func fullScreenButtonPressed() {
//        var frame: CGRect
//        if !isFullScreen {
//            var rootViewController: UIViewController
//            if #available(iOS 13.0, *) {
//                let keyWindow = UIApplication.shared.connectedScenes
//                    .filter({$0.activationState == .foregroundActive})
//                    .map({$0 as? UIWindowScene})
//                    .compactMap({$0})
//                    .first?.windows
//                    .filter({$0.isKeyWindow}).first
//                guard let window = keyWindow else { return }
//                guard let roortVC = window.rootViewController else { return }
//                rootViewController = roortVC
//            } else {
//                guard let window = UIApplication.shared.keyWindow else { return }
//                guard let rootVC = window.rootViewController else { return }
//                rootViewController = rootVC
//                // Fallback on earlier versions
//            }
//            var height: CGFloat
//            if #available(iOS 11.0, *) {
//                let safeAreaGuide = rootViewController.view.safeAreaLayoutGuide
//                height = safeAreaGuide.layoutFrame.height
//            } else {
//                height = rootViewController.view.bounds.height
//                // Fallback on earlier versions
//            }
//            frame = CGRect(x: rootViewController.view.bounds.origin.x,
//                           y: rootViewController.view.bounds.origin.y,
//                           width: rootViewController.view.bounds.width,
//                           height: height)
//        } else {
//            frame = originalSize
//        }
//        guard let superView = contentView.superview else { return }
//        UIView.animate(withDuration: 0.3, animations: {
//            superView.frame = frame
//        }) { (_) in
//            self.updateGravity()
//            self.isFullScreen = !self.isFullScreen
//        }
        
        
    }
    public func closeButtonPressed() {
        
    }
    public func sliderTouchBegin(_ sender: UISlider) {
        avPlayer.pause()
    }
    
    public func sliderValueChanged(_ sender: UISlider) {
        guard let duration = getVideoDuration() else { return }
        let seconds = CMTimeGetSeconds(duration) * Double(sender.value)
        let currentTime = stringFromTimeInterval(interval: seconds)
        valueUpdateDelegate?.updateCurrentTime(to: currentTime)
    }
    
    public func sliderTouchEnd(_ sender: UISlider) {
        guard let duration = getVideoDuration() else { return }
        let newCurrentTime = Double(sender.value) * CMTimeGetSeconds(duration)
        let seekToTime = CMTimeMakeWithSeconds(newCurrentTime, preferredTimescale: 600)
        avPlayer.seek(to: seekToTime)
    }
    
}

// MARK: - Utilities
extension YMPlayerManager {
    
    private func periodicTimeRecieved(time: CMTime) {
        guard let duration = getVideoDuration() else { return }
        let seconds = CMTimeGetSeconds(duration)
        let currentTime = Float(CMTimeGetSeconds(time)) / Float(seconds)
        valueUpdateDelegate?.updateSlider(to: currentTime)
        updateCurrentTime()
        checkForVideoEnd()
    }
    
    private func updateCurrentTime() {
        let currentDurationSeconds = getCurrentTime()
        let currentTime = stringFromTimeInterval(interval: currentDurationSeconds)
        valueUpdateDelegate?.updateCurrentTime(to: currentTime)
    }
    private func checkForVideoEnd() {
        if isVideoPlaybackFinished() {
            valueUpdateDelegate?.updatePlayButton(to: .play)
        }
    }
    private func isVideoPlaybackFinished() -> Bool {
        let currentDuration = getCurrentTime()
        guard let duration = getVideoDuration() else { return false }
        let totalSeconds  = CMTimeGetSeconds(duration)
        if currentDuration == totalSeconds {
            return true
        }
        return false
    }
    
    private func getCurrentTime() -> Float64 {
        let currentDuration = avPlayer.currentTime()
        let currentDurationSeconds = CMTimeGetSeconds(currentDuration)
        return currentDurationSeconds
    }
    
    private func updateOverAllTime() {
        guard let duration = getVideoDuration() else { return }
        let seconds = CMTimeGetSeconds(duration)
        let overAllTime = stringFromTimeInterval(interval: seconds)
        valueUpdateDelegate?.updateOverAllTime(to: overAllTime)
    }
    
    private func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func changeVideo(to index: Int) {
        let nextItem = avPlayerItems[index]
        avPlayer.replaceCurrentItem(with: nextItem)
        avPlayer.seek(to: CMTime.zero)
        updateCurrentTime()
        updateOverAllTime()
    }
    
    private func getVideoDuration() -> CMTime? {
        guard let currentItem = avPlayer.currentItem else { return nil}
        return currentItem.asset.duration
    }
    public func updateGravity() {
        playerLayer.videoGravity = videoGravity
    }
}
