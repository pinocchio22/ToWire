//
//  Date+.swift
//  ToWire
//
//  Created by JINHUN CHOI on 2024/01/18.
//

import Foundation

extension Double {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
