//
//  StockModel.swift
//  FinStat
//
//  Created by Ekaterina Gornostaeva on 3/25/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

import Foundation
import SwiftUI

struct Stock: Codable, Identifiable {
    var name: String
    var id: String
    var price: Double
    var currency: String?
    var change: Double
    var changePercent: Double
    
    enum CodingKeys: String, CodingKey {
        case name = "shortName"
        case id = "symbol"
        case price = "regularMarketPrice"
        case change = "regularMarketChange"
        case changePercent = "regularMarketChangePercent"
        case currency = "currency"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        id = try values.decode(String.self, forKey: .id)
        price = try values.decode(Double.self, forKey: .price)
        currency = try values.decode(String?.self, forKey: .currency)
        change = try values.decode(Double.self, forKey: .change)
        changePercent = try values.decode(Double.self, forKey: .changePercent)

    }
}

struct FinanceDataStore: Codable {
    var quotes: Result
    
    enum CodingKeys: String, CodingKey {
        case quotes = "quoteResponse"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        quotes = try container.decode(Result.self, forKey: .quotes)
    }
}

struct Result: Codable {
    var stocks: [Stock]
    
    enum CodingKeys: String, CodingKey {
        case stocks = "result"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stocks = try container.decode([Stock].self, forKey: .stocks)
    }
}
