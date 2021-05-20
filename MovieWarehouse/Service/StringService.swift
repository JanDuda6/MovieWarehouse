//
//  StringService.swift
//  MovieWarehouse
//
//  Created by Kurs on 28/04/2021.
//

import Foundation

struct StringService {
    static func responseTitleToString(string: String) -> String {
        var categoryTitle = string.replacingOccurrences(of: "_", with: " ")
        if categoryTitle.lowercased() == "day" {
            categoryTitle = "Trending today"
        }
        return categoryTitle.prefix(1).uppercased() + categoryTitle.lowercased().dropFirst()
    }

    static func dateTrimm(date: String) -> String {
        if let range = date.range(of: "-") {
            let result = date.substring(to: range.lowerBound)
            return result
        } else {
            return ""
        }
    }
}
