//
//  News.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 4/5/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//
//  News feature does not fully implemented due to this bug:
// UIScrollView does not support multiple observers implementing _observeScrollView:willEndDraggingWithVelocity:targetContentOffset:unclampedOriginalTarget...

import SwiftUI

struct News: View {
    var stock: Stock
    @State private var news = NewsData()
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    Text(stock.id)
                        .bold()
                    Text(stock.name)
                }
                .font(.headline)
                
                ForEach(news.news) { new in
                    NewsRow(article: new)
                }

                Spacer()
            }
            .onAppear {
                self.news.getLatestInfo(self.stock.id)
            }
            .navigationBarTitle("News")
            .navigationBarHidden(true)
        }
    }
}
