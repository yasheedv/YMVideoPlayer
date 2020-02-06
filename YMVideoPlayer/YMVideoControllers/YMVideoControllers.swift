//
//  YMVideoControllers.swift
//  CustomVideoPlayer
//
//  Created by Yasheed Muhammed on 02/02/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import UIKit

public class YMVideoControllers: UIView {
    // MARK: - Properties
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var overAllTime: UILabel!
    @IBOutlet private weak var slider: UISlider! {
        didSet {
            initUI()
        }
    }
    @IBOutlet private weak var currentTime: UILabel!
    @IBOutlet private weak var acitivityIndicator: UIActivityIndicatorView!
    
    weak var delegate: YMVideoControllersDelegate?
    weak var buttonActionDelegate: YMVideoControllersDelegate?
    public var sliderThumbColor: UIColor = .white
    public var sliderThumbSize = CGSize(width: 20, height: 20)
    public var sliderTintColor: UIColor = .white
    
    private func initUI() {
        let sliderImage = makeThumbImage()
        slider.setThumbImage(sliderImage, for: .normal)
        slider.setThumbImage(sliderImage, for: .highlighted)
        slider.tintColor = sliderTintColor
    }
    private func makeThumbImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(sliderThumbSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(sliderThumbColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: sliderThumbSize)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    // MARK: - Actions
    @IBAction func closeButtonAction(_ sender: UIButton) {
        delegate?.closeButtonPressed()
        buttonActionDelegate?.closeButtonPressed()

    }
    @IBAction func playButtonAction(_ sender: UIButton) {
        delegate?.playButtonPressed(sender: sender)
        buttonActionDelegate?.playButtonPressed(sender: sender)
    }
    @IBAction func nextButtonAction(_ sender: UIButton) {
        delegate?.nextButtonPressed()
        buttonActionDelegate?.nextButtonPressed()
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        delegate?.previousButtonPressed()
        buttonActionDelegate?.previousButtonPressed()
    }
    @IBAction func fullScreenButtonAction(_ sender: UIButton) {
        delegate?.fullScreenButtonPressed()
        buttonActionDelegate?.fullScreenButtonPressed()
    }
    @IBAction func sliderTouchBegin(_ sender: UISlider) {
        delegate?.sliderTouchBegin(sender)
        buttonActionDelegate?.sliderTouchBegin(sender)
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        delegate?.sliderValueChanged(sender)
        buttonActionDelegate?.sliderValueChanged(sender)
    }
    @IBAction func sliderTouchEnd(_ sender: UISlider) {
        delegate?.sliderTouchEnd(sender)
        buttonActionDelegate?.sliderTouchEnd(sender)
    }
}

// MARK: - YMVideoControllersValueUpdateDelegate
//. To update the slider value
extension YMVideoControllers: YMVideoControllersValueUpdateDelegate {
    func updateActivityIndicator(isHidden: Bool) {
        DispatchQueue.main.async {
            self.acitivityIndicator.isHidden = isHidden
            isHidden ? self.acitivityIndicator.stopAnimating() : self.acitivityIndicator.startAnimating()
            
        }
    }
    
    func updateOverAllTime(to value: String) {
        overAllTime.text = value
    }
    
    func updateNextButtonStatus(isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
    }
    
    func updatePreviousButtonStatus(isEnabled: Bool) {
        backButton.isEnabled = isEnabled
    }
    
    func updateCurrentTime(to value: String) {
        currentTime.text = value
    }
    
    func updatePlayButton(to type: ButtonType) {
        let image = UIImage(named: type.rawValue)
        playButton.setImage(image, for: .normal)
        playButton.isSelected = type == .play ? false : true
    }
    
    
    func updateSlider(to value: Float) {
        slider.value = value
    }
}
