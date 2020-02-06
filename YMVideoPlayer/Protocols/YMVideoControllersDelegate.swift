//
//  YMVideoControllersDelegate.swift
//  CustomVideoPlayer
//
//  Created by Yasheed Muhammed on 02/02/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation
import UIKit

public protocol YMVideoControllersDelegate: class {
    func nextButtonPressed()
    func previousButtonPressed()
    func playButtonPressed(sender: UIButton)
    func fullScreenButtonPressed()
    func sliderTouchBegin(_ sender: UISlider)
    func sliderValueChanged(_ sender: UISlider)
    func sliderTouchEnd(_ sender: UISlider)
    func closeButtonPressed()
}
extension YMVideoControllersDelegate {
    public func nextButtonPressed() {}
    public func previousButtonPressed() {}
    public func playButtonPressed(sender: UIButton) {}
    public func fullScreenButtonPressed() {}
    public func sliderTouchBegin(_ sender: UISlider) {}
    public func sliderValueChanged(_ sender: UISlider) {}
    public func sliderTouchEnd(_ sender: UISlider) {}
    public func closeButtonPressed() {}

}
protocol YMVideoControllersValueUpdateDelegate: class {
    func updateSlider(to value: Float)
    func updateCurrentTime(to value: String)
    func updatePlayButton(to type: ButtonType)
    func updateOverAllTime(to value: String)
    func updateNextButtonStatus(isEnabled: Bool)
    func updatePreviousButtonStatus(isEnabled: Bool)
    func updateActivityIndicator(isHidden: Bool)
}
