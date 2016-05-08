//
//  History.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 5/7/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation
import RealmSwift

class HistoryService {
    enum State {
        case Fav
        case NotFav
    }
    
    var item: Item
    
    class func all() -> [History] {
        let realm = try! Realm()
        return realm.objects(History).flatMap { $0 }
    }
    
    init(item: Item) {
        self.item = item
    }
    
    func add() {
        let fav = History()
        fav.title = item.title
        fav.link = item.link
        fav.desc = item.description
        fav.createdIn = NSDate()
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(fav, update: true)
        }
    }
}


class History: Object {
    dynamic var title = ""
    dynamic var desc = ""
    dynamic var link = ""
    dynamic var createdIn = NSDate()
    
    override static func primaryKey() -> String? {
        return "link"
    }
}