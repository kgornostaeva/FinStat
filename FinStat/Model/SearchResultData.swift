//
//  SearhResult.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 4/5/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//
// Used API: yahoo finance from rapidapi.com
// My free account allows only 500 requests per month
// If the amount of requests exceeds this value you can replace x-rapidapi-key in headers below by your new own key :)

import Foundation
import Combine
import SwiftUI

final class SearchResultData: ObservableObject {
    @Published var stocks = [Stock]()
    var tickers = [SearchResult]()
    
    let headers = [
        "x-rapidapi-key": "a1a8ea74d9msh7ea0a4b58d258d4p1732e2jsnb6fd74c866c4",
        "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
    ]
    
    func getLatestInfo(_ searchWord: String) {
    var path: String = "https://apidojo-yahoo-finance-v1.p.rapidapi.com/auto-complete?q="
    path.append(searchWord)
    path.append("&region=US")

    guard let url = URL(string: path) else {
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = self.headers
    URLSession.shared.dataTask(with: request, completionHandler:{ (data, response, error) -> Void in
        
        if let error = error {
            print(error)
            return
        }

        if let data = data {
            DispatchQueue.main.async {
                self.tickers = self.parseTickersJsonData(data: data)
                path = self.makePathForTickers()
                
                guard let url2 = URL(string: path) else {
                       return
                }
                
                request = URLRequest(url: url2)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = self.headers
                
                URLSession
                        .shared.dataTask(with: request, completionHandler:{ (data, response, error) -> Void in
                    if let error = error {
                        print(error)
                        return
                    }
                            
                    if let data = data {
                        DispatchQueue.main.async {
                            self.stocks = self.parseJsonData(data: data)
                        }
                        return
                    }
                }).resume()
            }
            return
        }
        }).resume()
    }
    
    func parseJsonData(data: Data) -> [Stock] {
        var stocks = [Stock]()
        let decoder = JSONDecoder()
        do {
            let financeDataStore = try decoder.decode(FinanceDataStore.self, from: data)
            stocks = financeDataStore.quotes.stocks
        } catch {
            print(error)
        }
        return stocks
    }

    func parseTickersJsonData(data: Data) -> [SearchResult] {
        var tickers = [SearchResult]()
        let decoder = JSONDecoder()
        do {
            let tickersDataStore = try decoder.decode(SearchQuotes.self, from: data)
            tickers = tickersDataStore.quotes
        } catch {
            print(error)
        }
        return tickers
    }
    
    func makePathForTickers() -> String {
        var path: String = "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-quotes?region=US&symbols="
        self.tickers.forEach { ticker in
            if (ticker.type == "EQUITY")
            {
                path.append(ticker.id)
                path.append("%2C")
            }
        }
        return path
    }
}
