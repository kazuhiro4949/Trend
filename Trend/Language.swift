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

func ==(lhs: Language, rhs: Language) -> Bool {
	return lhs.identifier == rhs.identifier
}

class Language: Object, Equatable {
    dynamic var displayName: String = ""
    dynamic var identifier: String = ""
    dynamic var active: Bool = false
    
    func feedURL(type: TrendPeriod) -> String {
        return "http://github-trends.ryotarai.info/rss/github_trends_\(identifier)_\(type.rawValue).rss"
    }
    
    convenience init(displayName: String, identifier: String) {
        self.init()
        self.displayName = displayName
        self.identifier = identifier
    }

    override static func primaryKey() -> String? {
        return "identifier"
    }
    
}