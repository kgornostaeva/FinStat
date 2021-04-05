//
//  TrendingTickers.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 4/4/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

import Foundation
import SwiftUI

struct Trend: Codable, Identifiable {
    var id: String
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case id = "symbol"
        case type = "quoteType"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        type = try values.decode(String.self, forKey: .type)
    }
}

struct TrendsDataStore: Codable {
    var finance: Results
    
    enum CodingKeys: String, CodingKey {
        case finance = "finance"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        finance = try container.decode(Results.self, forKey: .finance)
    }
}

struct Results: Codable {
    var result: [Quotes]
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decode([Quotes].self, forKey: .result)
    }
}

struct Quotes: Codable {
    var quotes: [Trend]
    
    enum CodingKeys: String, CodingKey {
        case quotes = "quotes"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        quotes = try container.decode([Trend].self, forKey: .quotes)
    }
}
