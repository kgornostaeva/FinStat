//
//  Favorites.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 3/29/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

import Foundation

class Favorites: ObservableObject {
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
    
    private var stocks: Set<String>
//    private let saveKey = "Favorites"

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
                #if DEBUG
                DispatchQueue.main.async {
                    self?.stocks = []
                }
                #endif
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
}
