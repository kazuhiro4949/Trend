//
//  Feed.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/6/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation
import SWXMLHash
import Alamofire
import SwiftyJSON

class Feed {
    
    var language: Language
    var items: [Item]

    init(language: Language, items: [Item]) {
        self.language = language
        self.items = items
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