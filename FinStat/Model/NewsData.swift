//
//  NewsData.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 4/5/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//
//  News feature does not fully implemented due to this bug:
// UIScrollView does not support multiple observers implementing _observeScrollView:willEndDraggingWithVelocity:targetContentOffset:unclampedOriginalTarget...

import Foundation
import Combine
import SwiftUI

final class NewsData: ObservableObject {
   @Published var news = [NewsPiece]()
    
    let headers = [
        "x-rapidapi-key": "a1a8ea74d9msh7ea0a4b58d258d4p1732e2jsnb6fd74c866c4",
        "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
    ]
    
    func getLatestInfo(_ ticker: String) {
    var path: String = "https://apidojo-yahoo-finance-v1.p.rapidapi.com/auto-complete?q="
    path.append(ticker)
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
                self.news = self.parseJsonData(data: data)
                
            }
            return
        }
        }).resume()
    }
    
    func parseJsonData(data: Data) -> [NewsPiece] {
        var news = [NewsPiece]()
        let decoder = JSONDecoder()
        do {
            let newsResult = try decoder.decode(NewsResult.self, from: data)
            news = newsResult.news
        } catch {
            print(error)
        }
        return news
    }
}
