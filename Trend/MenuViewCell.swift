//
//  MenuViewCell.swift
//  YoutubeNews
//
//  Created by Kazuhiro Hayashi on 1/2/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class MenuViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var focusView: UIView!
    
    @IBOutlet weak var focusViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        focusView.backgroundColor = nameLabel.tintColor
    }
    
    func configure(title: String, active: Bool) {
        nameLabel.text = title
        
        if active {
            nameLabel.textColor = nameLabel.tintColor
            focusViewHeightConstraint.constant = 3.0
        } else {
            nameLabel.textColor = UIColor.darkGrayColor()
            focusViewHeightConstraint.constant = 0.0
        }
    }
    
    
    func focusCell(active: Bool, animated: Bool) {
        focusViewHeightConstraint.constant = active ? 3.0 : 0.0
        let color = active ? nameLabel.tintColor : UIColor.darkGrayColor()
        guard animated else { return }
        
        layer.removeAllAnimations()
        UIView.animateWithDuration(
            0.5,
            animations: { [weak self] in
                self?.nameLabel.textColor = color
                self?.layoutIfNeeded()
            },
            completion: { (finish) in
                
            }
        )
    }
}
