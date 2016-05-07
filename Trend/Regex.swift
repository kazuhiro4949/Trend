//
//  Regex.swift
//  Trend
//
//  Created by Kazuhiro Hayashi on 2/6/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import Foundation

func ~= (pattern: Regex, value: String)  -> Bool {
    return pattern.test(value)
}

class Regex: StringLiteralConvertible {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        let result = try? NSRegularExpression(pattern: pattern, options: [.CaseInsensitive, .DotMatchesLineSeparators, .AnchorsMatchLines])
        self.internalExpression = result ?? NSRegularExpression()
    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression.matchesInString(input, options: [], range:NSMakeRange(0, input.characters.count))
        return matches.count > 0
    }
    
    func matches(input: String) -> [String]? {
        if self.test(input) {
            let nsString = input as NSString
            let matches = self.internalExpression.matchesInString(input, options: [], range:NSMakeRange(0, nsString.length) )
            var results: [String] = []
            for i in 0 ..< matches.count {
                results.append( (input as NSString).substringWithRange(matches[i].range) )
            }
            return results
        }
        return nil
    }
    
    required init(stringLiteral value: StringLiteralType) {
        self.pattern = value
        let result = try? NSRegularExpression(pattern: value, options: [.CaseInsensitive, .DotMatchesLineSeparators, .AnchorsMatchLines])
        self.internalExpression = result ?? NSRegularExpression()
    }
    
    required init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.pattern = value
        let result = try? NSRegularExpression(pattern: value, options: [.CaseInsensitive, .DotMatchesLineSeparators, .AnchorsMatchLines])
        self.internalExpression = result ?? NSRegularExpression()
    }
    
    required init(unicodeScalarLiteral value: StringLiteralType) {
        self.pattern = value
        let result = try? NSRegularExpression(pattern: value, options: [.CaseInsensitive, .DotMatchesLineSeparators, .AnchorsMatchLines])
        self.internalExpression = result ?? NSRegularExpression()
    }
    
}