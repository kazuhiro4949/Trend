//
//  LicenseViewController.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 5/8/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let path = NSBundle.mainBundle().pathForResource("acknowledgements", ofType: "markdown") {
            webview.loadHTMLString("", baseURL: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
