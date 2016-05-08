//
//  Feed.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/6/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

struct Item {
    let title: String
    let link: String
    let description: String
    let date: String
    
    init(favorite: Favorite) {
        title = favorite.title
        link = favorite.link
        description = favorite.desc
        date = ""
    }
    
    init(history: History) {
        title = history.title
        link = history.link
        description = history.desc
        date = ""
    }
    
    
    init(title: String, link: String, description: String, date: String) {
        self.title = title
        self.link = link
        self.description = description
        self.date = date
    }
}