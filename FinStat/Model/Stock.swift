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
    var change: Double
    
    enum CodingKeys: String, CodingKey {
        case name = "shortName"
        case id = "symbol"
        case price = "regularMarketPrice"
        case change = "regularMarketChange"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        id = try values.decode(String.self, forKey: .id)
        price = try values.decode(Double.self, forKey: .price)
        change = try values.decode(Double.self, forKey: .change)
    }
}

struct FinanceDataStore: Codable {
    var finance: Finance
    
    enum CodingKeys: String, CodingKey {
     case finance = "finance"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        finance = try container.decode(Finance.self, forKey: .finance)
    }
}

struct Finance: Codable {
    var result: [Result]
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decode([Result].self, forKey: .result)
    }
}

struct Result: Codable {
    var count: Int
    var quotes: [Stock]
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case quotes = "quotes"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try container.decode(Int.self, forKey: .count)
        quotes = try container.decode([Stock].self, forKey: .quotes)
    }
}
