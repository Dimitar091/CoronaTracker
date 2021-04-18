//
//  DateFormatter+Extension.swift
//  CoronaVirusApp
//
//  Created by Dimitar on 14.4.21.
//

import Foundation
import UIKit

extension DateFormatter {
    
    static let isoFullFormater: DateFormatter = {
      let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier:  "en_US_POSTIX")
        return formatter
    }()
}
