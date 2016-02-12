//
//  RepositoryTableViewController.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/5/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit

protocol RepositoryTableViewControllerDelegate: class {
    func repositoryTableViewController(viewController: RepositoryTableViewController, didSelectRowAtIndexPath indexPath: NSIndexPath)
}

class RepositoryTableViewController: UITableViewController {

    var index: Int?
    var delegate: RepositoryTableViewControllerDelegate?
    var loadingView: LoadingView?
    
    var dataSource: Feed? {
        return index.flatMap {
            if $0 < FeedManager.sharedInstance.feeds.count {
                return FeedManager.sharedInstance.feeds[$0]
            } else {
                return nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlStateChanged:", forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let items = dataSource?.items where items.isEmpty {
            dataSource?.fetch(.Daily) { [weak self] (items) in
//                self?.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length + 44, 0, 4, 0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topLayoutGuide.length + 44, 0, 0, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.items.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RepositoryTableViewCell", forIndexPath: indexPath) as! RepositoryTableViewCell
        cell.titleLabel.text = dataSource?.items[indexPath.row].title
        cell.subtitleLabel.text = dataSource?.items[indexPath.row].description
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let item = dataSource?.items[indexPath.row] else { return }
        
        showDetailViewController(WebViewController.instantiate(item), sender: self)
        delegate?.repositoryTableViewController(self, didSelectRowAtIndexPath: indexPath)
    }

    func refreshControlStateChanged(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        dataSource?.fetch(.Daily) { [weak self] (items) in
            self?.tableView.reloadData()
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
