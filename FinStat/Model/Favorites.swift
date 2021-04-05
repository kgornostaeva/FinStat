//
//  Favorites.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 3/29/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

import Foundation

class Favorites: ObservableObject {
    @Published var favorites = [Stock]()
    
    let headers = [
        "x-rapidapi-key": "ff35927267msh3f7dabb094a67e9p1ba5a6jsnd279c449aece",
        "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
    ]
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("finstat_favorites.data")
    }
    
    @Published var stocks: Set<String>

    init() {
        self.stocks = []
    }

    func contains(_ stock: Stock) -> Bool {
        stocks.contains(stock.id)
    }
    func add(_ stock: Stock) {
        objectWillChange.send()
        stocks.insert(stock.id)
         self.save()
    }

    func remove(_ stock: Stock) {
        objectWillChange.send()
        stocks.remove(stock.id)
        self.save()
    }
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                return
            }
            guard let savedStocks = try? JSONDecoder().decode(Set<String>.self, from: data) else {
                fatalError("Can't decode saved data.")
            }
            DispatchQueue.main.async {
                self?.stocks = savedStocks
            }
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let stocks = self?.stocks else { fatalError("Self out of scope") }
            guard let data = try? JSONEncoder().encode(stocks) else { fatalError("Error encoding data") }
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
    
    func getFavInfo() {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                return
            }
            guard let savedStocks = try? JSONDecoder().decode(Set<String>.self, from: data) else {
                fatalError("Can't decode saved data.")
            }
            DispatchQueue.main.async {
                self?.stocks = savedStocks
                let path: String = self!.makePathForFav()

                guard let url = URL(string: path) else {
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = self?.headers
                   
                URLSession.shared.dataTask(with: request, completionHandler:{ (data, response, error) -> Void in
                    if let error = error {
                        print(error)
                        return
                    }
                                          
                    if let data = data {
                        DispatchQueue.main.async {
                            self!.favorites = self!.parseJsonData(data: data)
                    }
                    return
                }
                }).resume()
            }
        }
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
    
    func makePathForFav() -> String {
           var path: String = "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-quotes?region=US&symbols="
           self.stocks.forEach { fav in
                   path.append(fav)
                   path.append("%2C")
               }
           return path
       }
}
