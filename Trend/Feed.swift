//
//  Feed.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/6/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SWXMLHash

class Feed {
    var language: Language
    var items: [Item]

    init(language: Language, items: [Item]) {
        self.language = language
        self.items = items
    }
    
    class func fetch(completion: ([Feed]) -> Void) {
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
    
    func fetch(type: TrendPeriod, completion: ([Item]) -> Void) {
        NetworkActivityIndicatorManager.sharedInstance.increment()
        Alamofire.request(.GET, language.feedURL(type)).responseString { [weak self] (response) in
            NetworkActivityIndicatorManager.sharedInstance.decrement()
            switch response.result {
            case .Success(let str):
                let xml = SWXMLHash.parse(str)
                let items = xml["rdf:RDF"]["item"].reduce([Item]()) { (items, indexer) in
                    if let title = indexer["title"].element?.text,
                       let desc = indexer["description"].element?.text,
                       let link = indexer["link"].element?.text,
                       let date = indexer["dc:date"].element?.text {
                            let replacedTitle = title.stringByReplacingOccurrencesOfString("\\s\\(.+\\)", withString: "", options: .RegularExpressionSearch, range: nil)
                            return items + [Item(title: replacedTitle, link: link, description: desc, date: date)]
                    } else {
                        return items
                    }
                }
                self?.items = items
                completion(items)
            case .Failure(_):
                completion([])
            }
        }
    }
}