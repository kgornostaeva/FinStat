//
//  PagerView.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 4/4/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//
//  News feature does not fully implemented due to this bug:
// UIScrollView does not support multiple observers implementing _observeScrollView:willEndDraggingWithVelocity:targetContentOffset:unclampedOriginalTarget...


import SwiftUI

struct PageViewData: Identifiable {
    let id = UUID().uuidString
    let pageName: String
}

struct PageView: View {
    let viewData: PageViewData
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var favorites: Favorites
    @EnvironmentObject var searches: SearchResultData

    var favoriteStocks: [Stock] {
        favorites.favorites.filter { stock in
            (favorites.contains(stock))
        }
    }
    
    var body: some View {

            List {
                if (viewData.pageName == "Stocks"){
                    ForEach(modelData.stocks) { stock in
//                        NavigationLink(destination: News(stock: stock)) {
                            StockRow(stock: stock)
//                        }
                    }
                }
                else if (viewData.pageName == "Favourite"){
                    ForEach(favoriteStocks) { stock in
//                       NavigationLink(destination: News(stock: stock)) {
                            StockRow(stock: stock)
//                        }
                    }
                }
                else if (viewData.pageName == "Search"){
                    ForEach(searches.stocks) { stock in
//                        NavigationLink(destination: News(stock: stock)) {
                            StockRow(stock: stock)
//                        }
                    }
                }
            }
            .onAppear {
                self.favorites.load()
                self.favorites.getFavInfo()
                self.modelData.getLatestInfo()
                UITableView.appearance().separatorStyle = .none
            }
    }
}
