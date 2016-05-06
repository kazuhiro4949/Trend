//
//  LoadingView.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/7/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    
    @IBOutlet weak var contentView: UIView!
    var replicatorLayer = CAReplicatorLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.bounds = CGRectMake(0, 0, 100, 100)
        addLayer(contentView)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func addLayer(contentView: UIView) {
        replicatorLayer.removeFromSuperlayer()
        
        replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = contentView.bounds
        contentView.layer.addSublayer(replicatorLayer)
        
        let circle = CALayer()
        circle.bounds = CGRect(x: 0, y: 10, width: 10, height: 10)
        circle.position = contentView.center
        circle.position.x -= 30
        circle.backgroundColor = UIColor.lightGrayColor().CGColor
        circle.cornerRadius = 5
        replicatorLayer.addSublayer(circle)
        replicatorLayer.instanceCount = 4
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(20, 0, 0)
        replicatorLayer.instanceDelay = 0.1
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.toValue = contentView.center.y - 10
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        circle.addAnimation(animation, forKey: "animation")
        
        
    }

}
