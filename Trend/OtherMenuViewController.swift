//
//  OtherMenuViewController.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 5/8/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit
import MessageUI

class OtherMenuViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 1) where MFMailComposeViewController.canSendMail():
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            let to = ["kazuhiro.hayashi.49@gmail.com"]
            vc.setSubject("Github Trend Readerに関するお問い合わせ")
            vc.setToRecipients(to)
            vc.mailComposeDelegate = self

            presentViewController(vc, animated: true, completion: {})
            
        default: break
        }
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result {
        case MFMailComposeResultCancelled:
            controller.setMessageBody("", isHTML: false)
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: { [weak self] (finish) in
            self?.tableView.deselectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1), animated: true)
        })
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
