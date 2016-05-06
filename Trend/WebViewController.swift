//
//  WebViewController.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/7/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {

    var item: Item?
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var addressBarView: UIView!
    @IBOutlet weak var domainLabel: UILabel!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
//    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    
    
    let webView = { () -> WKWebView in
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    class func instantiate(item: Item) -> WebViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        vc.item = item
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = item else { return }
        
        let url = NSURL(string: item.link)
        view.insertSubview(webView, atIndex: 0)
        view.addConstraints([
            NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: webView, attribute: .Width, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: webView, attribute: .Height, multiplier: 1, constant: 0)
            ])

        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "canGoBack", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "canGoForward", options: .New, context: nil)

        let scheme = (url?.scheme ?? "")
        let host = (url?.host ?? "")
        let path = (url?.path ?? "")
        domainLabel.text = scheme + "://" + host + path
        webView.loadRequest(NSURLRequest(URL: url!))
        
        navigationController?.navigationBar.topItem?.title = "Trend"

        addressBarView.translatesAutoresizingMaskIntoConstraints = true
        addressBarView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addressBarView.layer.cornerRadius = 5
        
        addressBarView.layer.masksToBounds = true
        addressBarView.layer.shadowOffset = CGSizeMake(0, 0.5)
        addressBarView.layer.shadowRadius = 0.5
        addressBarView.layer.shadowOpacity = 0.3

        progressView.progress = 0.0
        
//        switch FavoriteService(item: item).checkState() {
//        case .Fav:
//            favoriteButton.image = UIImage(named: "StarActive")
//
//        case .NotFav:
//            favoriteButton.image = UIImage(named: "StarDeactive")
//
//        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func handleTapRightBarButtonItem(sender: UIBarButtonItem) {
        let title = item?.title ?? ""
        let link = item.flatMap { NSURL(string: $0.link) } ?? NSURL()
        let activityItem: [AnyObject] = [title, link]
        let activityVc = UIActivityViewController(activityItems: [activityItem], applicationActivities: [OpenSafariActivity()])
        activityVc.popoverPresentationController?.barButtonItem = sender
        
        presentViewController(activityVc, animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
    }
    
    enum Mode {
        case FullScreen
        case Navigation
        case Transition
    }
    var mode = Mode.Navigation
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let transition = scrollView.panGestureRecognizer.translationInView(scrollView)
        
        switch mode {
        case .Navigation:
            let nextBottomConstraint: CGFloat
            if 0 < transition.y {
                nextBottomConstraint = 0
            } else if  toolbarBottomConstraint.constant < -toolbar.frame.height {
                nextBottomConstraint = -toolbar.frame.height
            } else {
                nextBottomConstraint = transition.y
            }
            
            toolbarBottomConstraint.constant = nextBottomConstraint
        case .FullScreen:
            break
        case .Transition:
            break
        }

    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
        switch mode {
        case .Navigation:
            let nextMode: Mode
            if toolbarBottomConstraint.constant < 0 {
                toolbarBottomConstraint.constant = -toolbar.bounds.height
                nextMode = .FullScreen
            } else {
                toolbarBottomConstraint.constant = 0
                nextMode = .Navigation
            }
            
            mode = .Transition
            toolbar.layer.removeAllAnimations()
            UIView.animateWithDuration(0.3, animations: { [weak self] in
                self?.toolbar.layoutIfNeeded()
            }) { (_) in
                self.mode = nextMode
            }
        case .FullScreen:
            let velocity = scrollView.panGestureRecognizer.velocityInView(scrollView)
            if 1000 < velocity.y {
                mode = .Transition
                toolbarBottomConstraint.constant = 0
                toolbar.layer.removeAllAnimations()
                UIView.animateWithDuration(0.3, animations: { [weak self] in
                    self?.toolbar.layoutIfNeeded()
                    }, completion: { [weak self] (finish) in
                        self?.mode = .Navigation
                    })
            }
        case .Transition:
            break
        }
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        reloadButton.enabled = false
        NetworkActivityIndicatorManager.sharedInstance.increment()
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        reloadButton.enabled = true
        NetworkActivityIndicatorManager.sharedInstance.decrement()
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        reloadButton.enabled = true

        NetworkActivityIndicatorManager.sharedInstance.decrement()
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        reloadButton.enabled = true

        NetworkActivityIndicatorManager.sharedInstance.decrement()
    }
    
    deinit {
        webView.scrollView.delegate = nil
        webView.stopLoading()
        
        
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "canGoBack")
        webView.removeObserver(self, forKeyPath: "canGoForward")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress"  {
            if webView.estimatedProgress == 1.0 {
                UIView.animateWithDuration(
                    0.5,
                    animations: { () -> Void in
                        self.progressView.alpha = 0
                    },
                    completion: { (finish) -> Void in
                         self.progressView.setProgress(0, animated: false)
                })
            } else {
                self.progressView.alpha = 1.0
            }
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        } else if keyPath == "canGoBack" {
            backButton.enabled = webView.canGoBack
        } else if keyPath == "canGoForward" {
            forwardButton.enabled = webView.canGoForward
        }
    }
    
    @IBAction func handleTapBackButton(sender: UIBarButtonItem) {
        webView.goBack()
    }
 
    @IBAction func handleTapForwardButton(sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func handleTapReloadButton(sender: UIBarButtonItem) {
        webView.reload()
    }
    
//    @IBAction func handleTapFavoriteButton(sender: UIBarButtonItem) {
//        guard let item = item else { return }
//
//        switch FavoriteService(item: item).changeState() {
//        case .Fav:
//            favoriteButton.image = UIImage(named: "StarActive")
//        case .NotFav:
//            favoriteButton.image = UIImage(named: "StarDeactive")
//        }
//    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
//            self.toolBar.layoutIfNeeded()
            }) { (context) -> Void in
                
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        
        
        coordinator.animateAlongsideTransition({ (context) -> Void in
            self.toolbar.frame.size.height = self.navigationController?.navigationBar.frame.height ?? 0
            }) { (context) -> Void in
                
        }
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
