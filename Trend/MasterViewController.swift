//
//  MasterViewController.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/1/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit


class MasterViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, MenuViewControllerDelegate {

    var detailViewController: DetailViewController?
    var menuViewController: MenuViewController?
    var pageViewController: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserverForName(
            FeedManager.didFetchFeeds,
            object: nil,
            queue: NSOperationQueue.mainQueue()) { [weak self] (notification) in
                let tableVc = self?.storyboard?.instantiateViewControllerWithIdentifier("RepositoryTableViewController") as! RepositoryTableViewController
                tableVc.index = 0
                self?.pageViewController?.setViewControllers([tableVc], direction: .Forward, animated: false) { _ in }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedMenuViewController" {
            menuViewController = segue.destinationViewController as? MenuViewController
            menuViewController?.delegate = self
        } else if segue.identifier == "embedPageViewController" {
            pageViewController = segue.destinationViewController as? UIPageViewController
            pageViewController?.view.subviews.forEach {
                if let scrollView = $0 as? UIScrollView {
                    scrollView.scrollsToTop = false
                }
            }
            pageViewController?.delegate = self
            pageViewController?.dataSource = self
        }
    }

    // MARK:- UIPageViewControllerDataSource

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let prevVc = viewController as? RepositoryTableViewController else {
            fatalError("not PageContentViewController")
        }
        
        guard let prevPageIndex = prevVc.index.flatMap({ $0 - 1 }) where 0 <= prevPageIndex else {
            return nil
        }
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("RepositoryTableViewController") as! RepositoryTableViewController
        vc.index = prevPageIndex
        return vc
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let nextVc = viewController as? RepositoryTableViewController else {
            fatalError("not PageContentViewController")
        }
        
        guard let nextPageIndex = nextVc.index.flatMap({ $0 + 1 }) where nextPageIndex < FeedManager.sharedInstance.feeds.count else {
            return nil
        }
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("RepositoryTableViewController") as! RepositoryTableViewController
        vc.index = nextPageIndex
        return vc
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        
    }
    
    // MARK:- UIPageViewControllerDelegate
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let nextVc = pageViewController.viewControllers?.first as? RepositoryTableViewController else {
            fatalError("not PageContentViewController")
        }
        
        menuViewController?.selectMenu(at: nextVc.index!, animated: true)
    }
    
    // MARK:- MenuViewControllerDelegate
    func menuViewController(viewController: MenuViewController, didSelect language: Language, at index: Int) {
        guard let currentVc = pageViewController?.viewControllers?.first as? RepositoryTableViewController,
              let currentIndex = currentVc.index else {
            fatalError("not PageContentViewController")
        }
        
        guard currentIndex != index else { return }
        
        let direction :UIPageViewControllerNavigationDirection = currentIndex < index ? .Forward : .Reverse
        let vc = storyboard?.instantiateViewControllerWithIdentifier("RepositoryTableViewController") as! RepositoryTableViewController
        vc.index = index
        pageViewController?.setViewControllers([vc], direction: direction, animated: true) { _ in }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
    }
}

