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
        if let index = date.firstIndex(of: "-") {
            let result = String(date[..<index])
            return result
        } else {
            return ""
        }
    }

    static func dateOfBirthTrimm(birthday: String, deathDay: String) -> String {
        if deathDay == "" {
            return "\(getAge(birthday: birthday)) Years Old"
        } else {
            let birthDate = dateTrimm(date: birthday)
            let deathDate = dateTrimm(date: deathDay)
            return "\(birthDate) - \(deathDate)"
        }
    }


    static func getAge(birthday: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = NSLocale.current
        if let date = dateFormatter.date(from: birthday) {

            let now = Date()
            let calendar = Calendar.current
            let age = calendar.dateComponents([.year], from: date, to: now)
            return String(age.year!)
        } else {
            return ""
        }
    }
}
