//
//  RepositoryTableViewCell.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/5/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.masksToBounds = false
        containerView.layer.shadowOffset = CGSizeMake(0, 1)
        containerView.layer.shadowRadius = 1
        containerView.layer.shadowOpacity = 0.1

        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.mainScreen().scale

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).CGPath
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

    }

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if highlighted {
            containerView.backgroundColor = UIColor.color(0xcccccc)
        } else {
            containerView.backgroundColor = UIColor.whiteColor()
        }
    }
}
