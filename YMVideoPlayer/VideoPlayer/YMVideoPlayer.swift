//
//  YMVideoPlayer.swift
//  CustomVideoPlayer
//
//  Created by Yasheed Muhammed on 02/02/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import UIKit
import AVKit

public class YMVideoPlayer: UIView {

    @IBOutlet fileprivate var contentView: UIView!
    @IBOutlet public var controlsView: YMVideoControllers!
    @IBOutlet fileprivate var videoPlayerView: UIView!
    public weak var buttonActionDelegate: YMVideoControllersDelegate?

    public var ymPlayerManager: YMPlayerManager! {
        didSet {
            self.ymPlayerManager.valueUpdateDelegate = self.controlsView
            self.controlsView.delegate = self.ymPlayerManager
        }
    }
    public weak var dataSource: YMPlayerDataSource? {
        didSet {
            ymPlayerManager.dataSource = self.dataSource
        }
    }
    
    // Override UIView property
    override public static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    override init(frame: CGRect) { //for using custom view in code
        super.init(frame: frame)
        commonInit()
    }
    required public init?(coder aDecoder: NSCoder) { // for using cutom view in IB
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: YMVideoPlayer.self)
        bundle.loadNibNamed("YMVideoPlayer", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        videoPlayerView.layer.sublayers?.filter({ $0 is AVPlayerLayer}).forEach({$0.removeFromSuperlayer()})
        ymPlayerManager = YMPlayerManager(videoPlayerView, contentView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(videoViewTouchAction))
        videoPlayerView.addGestureRecognizer(tapGesture)
    }
    @objc private func videoViewTouchAction() {
        var transform: CGAffineTransform
        var alpha: CGFloat
        if controlsView.isHidden {
            controlsView.isHidden = false
            transform = CGAffineTransform.identity
            alpha = 1.0
            controlsView.closeButton.isHidden = false
        } else {
            transform = CGAffineTransform(translationX: 0, y: controlsView.bounds.height)
            alpha = 0.0
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.controlsView.transform = transform
            self.controlsView.alpha = alpha
            self.controlsView.closeButton.alpha = alpha
        }) { [weak self] (_) in
            if alpha == 0.0 {
                self?.controlsView.isHidden = true
                self?.controlsView.closeButton.isHidden = true
            }
        }
    }
}
