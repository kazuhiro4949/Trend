//
//  UIColor+Hex.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/5/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

extension UIColor {
    class func color(color: UInt32, alpha : CGFloat = 1.0) -> UIColor {
        let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(color & 0x0000FF) / 255.0
        return UIColor(red:r,green:g,blue:b,alpha:alpha)
    }
}