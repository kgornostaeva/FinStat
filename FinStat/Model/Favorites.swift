//
//  Favorites.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 3/29/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

import Foundation

class Favorites: ObservableObject {
    private var stocks: Set<String>
    private let saveKey = "Favorites"

    init() {
        self.stocks = []
    }

    func contains(_ stock: Stock) -> Bool {
        stocks.contains(stock.id)
    }
    func add(_ stock: Stock) {
        objectWillChange.send()
        stocks.insert(stock.id)
//        save()
    }

    func remove(_ stock: Stock) {
        objectWillChange.send()
        stocks.remove(stock.id)
    }
}
