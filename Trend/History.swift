//
//  History.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 5/7/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation
import RealmSwift

class History: Object {
    dynamic var title = ""
    dynamic var desc = ""
    dynamic var link = ""
    dynamic var createdIn = NSDate()
    
    override static func primaryKey() -> String? {
        return "link"
    }
}