//
//  ViewController.swift
//  CustomVideoPlayer
//
//  Created by Yasheed Muhammed on 02/02/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import UIKit
import AVKit

public class YMPlayerViewController: UIViewController {
    
    var ymPlayer: YMVideoPlayer!
    public let imageView = UIImageView()
    public var videoUrls: [String]!
    
    public init(_ videoUrls: [String]) {
        self.videoUrls = videoUrls
        super.init(nibName: nil, bundle: nil)
    }
    public convenience init() {
        self.init([String]())
        videoUrls = [String]()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public var shouldAutorotate: Bool {
        return true
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addImageView()
        // Do any additional setup after loading the view.
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addVideoPlayer()
    }
    func addImageView() {
        if imageView.image != nil {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            if #available(iOS 11, *) {
                let guide = view.safeAreaLayoutGuide
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                    guide.bottomAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 1.0)
                ])
            } else {
                let standardSpacing: CGFloat = 8.0
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
                    bottomLayoutGuide.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: standardSpacing)
                ])
            }
            view.bringSubviewToFront(imageView)
        }
    }
    func addVideoPlayer() {
        ymPlayer = YMVideoPlayer(frame: .zero)
        ymPlayer.alpha = 0.0
        ymPlayer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ymPlayer)
        NSLayoutConstraint.activate([
            ymPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ymPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                ymPlayer.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: ymPlayer.bottomAnchor, multiplier: 1.0)
            ])
        } else {
            let standardSpacing: CGFloat = 8.0
            NSLayoutConstraint.activate([
                ymPlayer.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
                bottomLayoutGuide.topAnchor.constraint(equalTo: ymPlayer.bottomAnchor, constant: standardSpacing)
            ])
        }
        ymPlayer.dataSource = self
        ymPlayer.controlsView.buttonActionDelegate = self
      
        UIView.animate(withDuration: 0.3, animations: {
            self.ymPlayer.alpha = 1.0
        }) { (_) in
            if self.imageView.image != nil {
                self.imageView.isHidden = true
            }
        }
    }
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
        }) { (context) in
            self.ymPlayer.frame.size = size
            self.ymPlayer.ymPlayerManager.playerLayer.frame.size = size
            self.ymPlayer.ymPlayerManager.updateGravity()
        }
    }
}

extension YMPlayerViewController: YMPlayerDataSource {
    public func videoPathsForYMPlayer() -> [String] {
        return videoUrls
    }
}

extension YMPlayerViewController: YMVideoControllersDelegate {
    public func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
