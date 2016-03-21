//
//  FeedManager.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/6/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

import RealmSwift

class FeedManager {
    static let didFetchFeeds = "kazuhiro.hayash.Trend.didFetchFeed"
    static let didActivateLanaguages = "kazuhiro.hayash.Trend.didUpdateLanaguages"
    
    static let sharedInstance = FeedManager()
    
    var feeds = [Feed]()
    var totalInternalFeeds = [Feed]()
    
    func fetch(completion: ([Feed]) -> Void) {
        request { [weak self] (feeds) in
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
    
    func activate(index: Int) {
        totalInternalFeeds[index].language.active = !totalInternalFeeds[index].language.active
        if totalInternalFeeds[index].language.active == false {
           totalInternalFeeds[index].items = []
        }
        
        feeds = totalInternalFeeds.filter { $0.language.active == true }
        NSNotificationCenter.defaultCenter().postNotificationName(FeedManager.didActivateLanaguages, object: self, userInfo: nil)
    }
    
    private func request(completion: ([Feed]) -> Void) {
        
        NetworkActivityIndicatorManager.sharedInstance.increment()
        Alamofire.request(.GET, "http://github-trends.ryotarai.info/js/languages.js").responseString { (response) in
            NetworkActivityIndicatorManager.sharedInstance.decrement()
            switch response.result {
            case .Success(let str):
                if  let json = Regex("\\{.+\\}").matches(str)?.first?.stringByReplacingOccurrencesOfString("\'", withString: "\""),
                    let dict = JSON.parse(json).dictionary,
                    let orderJson = Regex("\\[.+\\]").matches(str)?.first?.stringByReplacingOccurrencesOfString("\'", withString: "\""),
                    let order = JSON.parse(orderJson).array?.flatMap({ $0.string }) {
                        let feeds = order.reduce([Feed]()) { (sum, lang) in
                            if let feed = dict[lang]?.string.map({ Feed(language: Language(displayName: $0, identifier: lang), items: []) }) {
                                return sum + [feed]
                            } else {
                                return sum
                            }
                        }
                        
                        completion(feeds)
                }
            case .Failure(_):
                completion([])
            }
        }
    }
    
}