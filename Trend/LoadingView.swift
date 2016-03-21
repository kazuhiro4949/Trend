//
//  LoadingView.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/7/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var contentView: LoadingView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    let replicatorLayer = CAReplicatorLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
    
    func addLayer() {
        replicatorLayer.frame = bounds
        layer.addSublayer(replicatorLayer)
        
        let circle = CALayer()
        circle.bounds = CGRect(x: 0, y: 10, width: 10, height: 10)
        circle.position = center
        circle.position.x -= 30
        circle.backgroundColor = UIColor.lightGrayColor().CGColor
        circle.cornerRadius = 5
        replicatorLayer.addSublayer(circle)
        
        replicatorLayer.instanceCount = 4
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(20, 0, 0)
        
        _ = CABasicAnimation(keyPath: "position.y")
    }

}
