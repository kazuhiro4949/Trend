//
//  ModalDrawBackAnimator.swift
//  DeviceManager
//
//  Created by Kazuhiro Hayashi on 10/12/15.
//  Copyright © 2015 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class ModalDrawBackAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let containerView = transitionContext.containerView() else { return }
        
        toViewController.view.frame = containerView.bounds
        toViewController.view.frame.origin.y = containerView.bounds.height
        let maskView = UIView(frame: containerView.frame)
        maskView.backgroundColor = UIColor.blackColor()
        maskView.alpha = 0
        containerView.addSubview(maskView)
        containerView.addSubview(toViewController.view)
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { () -> Void in
            fromViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9)
            toViewController.view.frame.origin.y = 0
            maskView.alpha = 0.8
        }) { (finished) -> Void in
            maskView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }

    }
}
