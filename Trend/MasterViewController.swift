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
    var contentViewControllers = [UIViewController?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserverForName(
            FeedManager.didFetchFeeds,
            object: nil,
            queue: NSOperationQueue.mainQueue()) { [weak self] (notification) in
                self?.contentViewControllers = [UIViewController?](count: FeedManager.sharedInstance.feeds.count, repeatedValue: nil)
                let tableVc = self?.storyboard?.instantiateViewControllerWithIdentifier("RepositoryTableViewController") as! RepositoryTableViewController
                tableVc.index = 0
                self?.contentViewControllers[0] = tableVc
                self?.pageViewController?.setViewControllers([tableVc], direction: .Forward, animated: false) { _ in }
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            FeedManager.didActivateLanaguages,
            object: nil,
            queue: NSOperationQueue.mainQueue()) { [weak self] (notification) in
                self?.contentViewControllers = [UIViewController?](count: FeedManager.sharedInstance.feeds.count, repeatedValue: nil)
                let tableVc = self?.storyboard?.instantiateViewControllerWithIdentifier("RepositoryTableViewController") as! RepositoryTableViewController
                tableVc.index = 0
                self?.contentViewControllers[0] = tableVc
                self?.pageViewController?.setViewControllers([tableVc], direction: .Forward, animated: false) { _ in }
                
                self?.menuViewController?.collectionView?.reloadData()
                self?.menuViewController?.selectMenu(at: 0, animated: true)
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
        
        guard prevPageIndex < FeedManager.sharedInstance.feeds.count else {
            return nil
        }
        
        if let contentViewController = contentViewControllers[prevPageIndex] {
            return contentViewController
        } else {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("RepositoryTableViewController") as! RepositoryTableViewController
            vc.index = prevPageIndex
            contentViewControllers[prevPageIndex] = vc
            return vc
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let nextVc = viewController as? RepositoryTableViewController else {
            fatalError("not PageContentViewController")
        }
        
        guard let nextPageIndex = nextVc.index.flatMap({ $0 + 1 }) where nextPageIndex < FeedManager.sharedInstance.feeds.count else {
            return nil
        }
        
        
        guard nextPageIndex < FeedManager.sharedInstance.feeds.count else {
            return nil
        }
        
        if let contentViewController = contentViewControllers[nextPageIndex] {
            return contentViewController
        } else {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("RepositoryTableViewController") as! RepositoryTableViewController
            vc.index = nextPageIndex
            contentViewControllers[nextPageIndex] = vc
            return vc
        }
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

        guard index < FeedManager.sharedInstance.feeds.count else { return }
        
        let direction :UIPageViewControllerNavigationDirection = currentIndex < index ? .Forward : .Reverse
        
        if let contentViewController = contentViewControllers[index] {
             pageViewController?.setViewControllers([contentViewController], direction: direction, animated: false) { _ in }
        } else {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("RepositoryTableViewController") as! RepositoryTableViewController
            vc.index = index
            contentViewControllers[index] = vc
            pageViewController?.setViewControllers([vc], direction: direction, animated: false) { _ in }
        }

    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
    }
}

