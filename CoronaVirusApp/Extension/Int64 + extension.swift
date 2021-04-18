//
//  Int64 + extension.swift
//  CoronaVirusApp
//
//  Created by Dimitar on 13.4.21.
//

import Foundation

extension Int64 {
    
    func getFormatedNumber() -> String {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        let string = formatter.string(from: NSNumber(value: self))
        return string ?? ""
    }
}
