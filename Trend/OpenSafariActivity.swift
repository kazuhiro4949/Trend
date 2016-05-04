//
//  OpenSafariActivity.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/7/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class OpenSafariActivity: UIActivity {
    override func activityType() -> String? {
        return "kazuhiro.hayash.Trend"
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "Safari")
    }
    
    override func activityTitle() -> String? {
        return "Open in Safari"
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        guard let data = activityItems.first as? [AnyObject], let url = data[1] as? NSURL else {
            return
        }
        
        UIApplication.sharedApplication().openURL(url)
    }
    
    
}
