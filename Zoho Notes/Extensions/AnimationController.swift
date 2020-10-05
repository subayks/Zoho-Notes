//
//  AnimationController.swift
//  Zoho Notes
//
//  Created by Subendran on 03/10/20.
//  Copyright © 2020 Subendran. All rights reserved.
//

import UIKit
class AnimationController: NSObject  {
    
    private let animationDuration : Double
    private let animationtype : AnimationType
     enum AnimationType {
        case present
        case dismiss
    }
    init(animationDuration:Double,animationtype:AnimationType) {
        self.animationDuration = animationDuration
        self.animationtype = animationtype
    }
    
}
extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewcontroller = transitionContext.viewController(forKey: .to),let fromViewController = transitionContext.viewController(forKey: .from)  else {
            transitionContext.completeTransition(false)
            return
        }
        switch animationtype {
        case .present:
            transitionContext.containerView.addSubview(toViewcontroller.view)
            presentAnimation(with: transitionContext, viewToAnimate: toViewcontroller.view)
            
        case .dismiss:             transitionContext.containerView.addSubview(toViewcontroller.view)
            transitionContext.containerView.addSubview(fromViewController.view)
        dissmissAnimation(with: transitionContext, viewToAnimate: fromViewController.view)


        }
        
    }
    func dissmissAnimation(with transitionContext: UIViewControllerContextTransitioning,viewToAnimate: UIView) {
        let duration = transitionDuration(using: transitionContext)
        let scaledown = CGAffineTransform(scaleX: 0.3, y: 0.3)
        let moveOut = CGAffineTransform(translationX: -viewToAnimate.frame.width, y: 0)
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7, animations: {
                
                viewToAnimate.transform = scaledown
            })
            
            UIView.addKeyframe(withRelativeStartTime: 3.0/duration, relativeDuration: 1.0, animations: {
                
                viewToAnimate.transform = scaledown.concatenating(moveOut)
                viewToAnimate.alpha = 0
            })
        }) { _ in
            transitionContext.completeTransition(true)
            
        }
        
        
    }
    func  presentAnimation(with transitionContext: UIViewControllerContextTransitioning,viewToAnimate: UIView) {
        
        viewToAnimate.clipsToBounds = true
        let duration = transitionDuration(using: transitionContext)
        viewToAnimate.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { _ in
            transitionContext.completeTransition(true)

        }
    }
}
