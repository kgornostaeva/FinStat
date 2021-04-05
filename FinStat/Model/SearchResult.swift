//
//  SearchTicker.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 4/5/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

import Foundation
import Foundation
import SwiftUI

struct SearchResult: Codable, Identifiable {
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

struct SearchQuotes: Codable {
    var quotes: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case quotes = "quotes"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        quotes = try container.decode([SearchResult].self, forKey: .quotes)
    }
}
