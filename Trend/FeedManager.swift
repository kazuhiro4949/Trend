//
//  FeedManager.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/6/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

class FeedManager {
    static let didFetchFeeds = "kazuhiro.hayash.Trend.didFetchFeed"
    
    static let sharedInstance = FeedManager()
    
    var feeds = [Feed]()
    var totalInternalFeeds = [Feed]()
    
    func fetch(completion: ([Feed]) -> Void) {
        Feed.fetch { [weak self] (feeds) in
            dispatch_async(dispatch_get_main_queue(), {
                
                self?.totalInternalFeeds = feeds
                
                let size = min(feeds.count, 10)
                (0..<size).forEach { self?.totalInternalFeeds[$0].language.active = true }
                self?.feeds = self?.totalInternalFeeds.filter({ $0.language.active == true }) ?? []
                
                completion(feeds)
                NSNotificationCenter.defaultCenter().postNotificationName(FeedManager.didFetchFeeds, object: self, userInfo: nil)
            })
        }
    }
}