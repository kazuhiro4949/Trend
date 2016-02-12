//
//  ContainerViewController.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/3/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class ContainerViewController: UISplitViewController {

    var masterViewControler: MasterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .AllVisible
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

    // MARK:- MasterViewControllerDelegate
    func masterViewController(viewController: MasterViewController, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}
