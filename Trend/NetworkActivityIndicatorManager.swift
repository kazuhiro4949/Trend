//
//  NetworkActivityIndicatorManager.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/6/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation
import UIKit

class NetworkActivityIndicatorManager {
    static let sharedInstance = NetworkActivityIndicatorManager()
    
    var activityCounter = 0
    
    func increment() {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.activityCounter += 1
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
    }
    
    func decrement() {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            self?.activityCounter -= 1
            if let counter = self?.activityCounter where counter == 0 {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
    }
}