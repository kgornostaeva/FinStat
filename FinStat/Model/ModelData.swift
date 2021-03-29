//
//  ModelData.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 3/25/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

import Foundation
import Combine
import SwiftUI


final class ModelData: ObservableObject {
    @Published var stocks = [Stock]()

func getLatestInfo() {
    let path: String = "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/get-trending-tickers"
    
    guard let url = URL(string: path) else {
        return
    }
    let headers = [
        "x-rapidapi-key": "af571d9e9bmsh5be5d419c3783c4p1946c2jsn3a6197bb19b1",
        "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    let task = URLSession
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
    })
    task.resume()
    }

func parseJsonData(data: Data) -> [Stock] {
    var stocks = [Stock]()
    let decoder = JSONDecoder()
    do {
        let financeDataStore = try decoder.decode(FinanceDataStore.self, from: data)
        stocks = financeDataStore.finance.result[0].quotes
    } catch {
        print(error)
    }
    return stocks
}
}
