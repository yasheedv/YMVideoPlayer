//
//  PopAnimator.swift
//  CustomVideoPlayer
//
//  Created by Yasheed Muhammed on 04/02/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation
import UIKit

public class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.8
    public var presenting = true
    public var originFrame = CGRect.zero
    
    public var dismissCompletion: (() -> Void)?
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let recipeView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originFrame : recipeView.frame
        let finalFrame = presenting ? recipeView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            recipeView.transform = scaleTransform
            recipeView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            recipeView.clipsToBounds = true
        }
        
        recipeView.layer.cornerRadius = presenting ? 20.0 : 0.0
        recipeView.layer.masksToBounds = true
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(recipeView)
        
        UIView.animate(
            withDuration: duration,
            delay:0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            animations: {
                recipeView.transform = self.presenting ? .identity : scaleTransform
                recipeView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                recipeView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
        }, completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })
    }
    
    private func handleRadius(recipeView: UIView, hasRadius: Bool) {
        recipeView.layer.cornerRadius = hasRadius ? 20.0 : 0.0
    }
}
