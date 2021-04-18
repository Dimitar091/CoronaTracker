//
//  APIManager.swift
//  CoronaVirusApp
//
//  Created by Dimitar on 6.4.21.
//

import Foundation
import Alamofire

typealias CountriesResultCompletion = ((Result<[Country], Error>) -> Void)
typealias GlobalInfoCompletion = ((Result<Global, Error>) -> Void)
typealias ConfirmedCasesByDayComletion = ((Result<[ConfirmedCasesByDay], Error>) -> Void)

class APIManager {
    
    static let shared = APIManager()
    var globalResponse: GlobalResponse?
    init() {}
//https://api.covid19api.com/countries
//https://api.covid19api.com/summary

    
    func getAllCountries(completion: @escaping CountriesResultCompletion) {
        AF.request("https://api.covid19api.com/countries").responseDecodable(of: [Country].self) { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let countries):
                completion(.success(countries))
            }
        }
    }
    
    func getGlobalInfo(completion: @escaping GlobalInfoCompletion) {
        AF.request("https://api.covid19api.com/summary", method: .get).responseDecodable(of: GlobalResponse.self) { response in
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let globalResponse):
                completion(.success(globalResponse.global))
            }
        }
    }
    //https://api.covid19api.com/country/south-africa/status/confirmed/live?from=2020-03-01T00:00:00Z&to=2020-04-01T00:00:00Z
    func getConfirmedCases(for country: String, from: Date? = nil, to: Date? = nil, completion: @escaping(ConfirmedCasesByDayComletion)) {
        let fetchTodayDate = (from == nil && to == nil) ? Date().minus(days: 1) : nil
        var urlString = "https://api.covid19api.com/country/" + country + "/status/confirmed/live?"
        
        if let today = fetchTodayDate {
            urlString = urlString + "from=" + DateFormatter.isoFullFormater.string(from: today)
        } else {
            urlString = urlString + "from=" + DateFormatter.isoFullFormater.string(from: from!) + "&to=" + DateFormatter.isoFullFormater.string(from: to!)
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.isoFullFormater)
        AF.request(urlString, method: .get).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let days = try jsonDecoder.decode([ConfirmedCasesByDay].self , from: data)
                    completion(.success(days))
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
