//
//  Language.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/6/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

enum TrendPeriod: String {
    case Daily = "daily"
    case Weekly = "weekly"
    case Monthly = "monthly"
}

class Language: Object {
    dynamic var displayName: String = ""
    dynamic var identifier: String = ""
    dynamic var active: Bool = false
    
    func feedURL(type: TrendPeriod) -> String {
        return "http://github-trends.ryotarai.info/rss/github_trends_\(identifier)_\(type.rawValue).rss"
    }
    
    init(displayName: String, identifier: String) {
        self.displayName = displayName
        self.identifier = identifier
        super.init()
    }

    required init() {
        super.init()
    }

    override static func primaryKey() -> String? {
        return "identifier"
    }
}