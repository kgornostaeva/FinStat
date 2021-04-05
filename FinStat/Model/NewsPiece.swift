//
//  NewsPiece.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 4/5/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//
//  News feature does not fully implemented due to this bug:
// UIScrollView does not support multiple observers implementing _observeScrollView:willEndDraggingWithVelocity:targetContentOffset:unclampedOriginalTarget...

import Foundation
import SwiftUI

struct NewsPiece: Codable, Identifiable {
    var publisher: String
    var title: String
    var url: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case publisher = "publisher"
        case title = "title"
        case url = "link"
        case id = "uuid"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        publisher = try values.decode(String.self, forKey: .publisher)
        title = try values.decode(String.self, forKey: .title)
        url = try values.decode(String.self, forKey: .url)
        id = try values.decode(String.self, forKey: .id)
    }
}

struct NewsResult: Codable {
    var news: [NewsPiece]
    
    enum CodingKeys: String, CodingKey {
        case news = "news"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        news = try container.decode([NewsPiece].self, forKey: .news)
    }
}
