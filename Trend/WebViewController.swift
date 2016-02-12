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
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
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
        let url = item.flatMap { NSURL(string: $0.link) }
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

        domainLabel.text = (url?.scheme ?? "") + "://" + (url?.host ?? "") + (url?.path ?? "")
        webView.loadRequest(NSURLRequest(URL: url!))
        
        navigationController?.navigationBar.topItem?.title = "Trend"

        addressBarView.layer.cornerRadius = 5
        
        addressBarView.layer.masksToBounds = true
        addressBarView.layer.shadowOffset = CGSizeMake(0, 0.5)
        addressBarView.layer.shadowRadius = 0.5
        addressBarView.layer.shadowOpacity = 0.3

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
    
    func handleTapRightBarButtonItem(sender: UIBarButtonItem) {
        let title = item?.title ?? ""
        let link = item.flatMap { NSURL(string: $0.link) } ?? NSURL()
        let activityItem: [AnyObject] = [title, link]
        let activityVc = UIActivityViewController(activityItems: [activityItem], applicationActivities: [OpenSafariActivity()])
        presentViewController(activityVc, animated: true, completion: nil)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let transition = scrollView.panGestureRecognizer.translationInView(scrollView)        
        
        if transition.y > 0 {
            
        } else if transition.y < 0 {
            
        }
//        scrollView.panGestureRecognizer.setTranslation(CGPointZero, inView: scrollView)
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
            webView.layer.removeAllAnimations()
            if webView.estimatedProgress == 1.0 {
                UIView.animateWithDuration(
                    0.5,
                    animations: { () -> Void in
                        self.progressView.alpha = 0
                    },
                    completion: { (finish) -> Void in
                         self.progressView.progress = 0
                })
            } else {
                self.progressView.alpha = 1.0
            }
            let progress = Float(webView.estimatedProgress)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.progressView.progress = progress
            })
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
    
    @IBAction func handleTapFavoriteButton(sender: UIBarButtonItem) {
        favoriteButton.setBackButtonBackgroundImage(UIImage(named: "StarDeactive"), forState: .Normal, barMetrics: .Default)
        
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
