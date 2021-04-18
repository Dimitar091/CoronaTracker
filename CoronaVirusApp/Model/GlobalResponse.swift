//
//  GlobalResponse.swift
//  CoronaVirusApp
//
//  Created by Dimitar on 6.4.21.
//

import Foundation

struct GlobalResponse: Codable {
    var global: Global
    
    private enum CodingKeys: String, CodingKey {
        case global = "Global"
    }
}

struct Global: Codable {
    var confirmed: Int64
    var deaths: Int64
    var recovered: Int64
    
    private enum CodingKeys: String, CodingKey {
        case confirmed = "TotalConfirmed"
        case deaths = "TotalDeaths"
        case recovered = "TotalRecovered"
    }
    
}

//
//    "Global": {
//        "NewConfirmed": 100282,
//        "TotalConfirmed": 1162857,
//        "NewDeaths": 5658,
//        "TotalDeaths": 63263,
//        "NewRecovered": 15405,
//        "TotalRecovered": 230845
//      },
