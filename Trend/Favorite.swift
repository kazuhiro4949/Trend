//
//  Favorite.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/21/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteService {
    enum State {
        case Fav
        case NotFav
    }
    
    var item: Item
    
    class func all() -> [Favorite] {
        let realm = try! Realm()
        return realm.objects(Favorite).flatMap { $0 }
    }
    
    init(item: Item) {
       self.item = item
    }
    
    func changeState() -> State {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "link = %@", item.link)
        if let fav = realm.objects(Favorite).filter(predicate).first {
            try! realm.write {
                realm.delete(fav)
            }
            return .NotFav
        } else {
            add()
            return .Fav
        }
    }
    
    func checkState() -> State {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "link = %@", item.link)
        if let _ = realm.objects(Favorite).filter(predicate).first {
            return .Fav
        } else {
            return .NotFav
        }
    }
    
    func add() {
        let fav = Favorite()
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

class Favorite: Object {
    dynamic var title = ""
    dynamic var desc = ""
    dynamic var link = ""
    dynamic var createdIn = NSDate()
    
    override static func primaryKey() -> String? {
        return "link"
    }

// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
