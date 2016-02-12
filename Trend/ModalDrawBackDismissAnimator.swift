//
//  ModalDrawBackDismissAnimator.swift
//  DeviceManager
//
//  Created by Kazuhiro Hayashi on 10/12/15.
//  Copyright © 2015 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class ModalDrawBackDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let containerView = transitionContext.containerView() else { return }

        let maskView = UIView(frame: containerView.frame)
        maskView.backgroundColor = UIColor.blackColor()
        toViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9)
        maskView.alpha = 0.0
        containerView.addSubview(maskView)
        containerView.bringSubviewToFront(fromViewController.view)
        maskView.alpha = 0.8
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { () -> Void in
            toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            fromViewController.view.frame.origin.y = containerView.frame.height
            maskView.alpha = 0.0
        }) { (finished) -> Void in
            maskView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
