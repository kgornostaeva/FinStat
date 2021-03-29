//
//  StockList.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 3/25/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

import SwiftUI
import Combine

struct StockList: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var favorites: Favorites
    
    @State private var showFavoritesOnly = false
    @State private var searchText = ""
    
    var favoriteStocks: [Stock] {
          modelData.stocks.filter { stock in
              (!showFavoritesOnly || favorites.contains(stock))
          }
      }

    var body: some View {
        NavigationView {
            List {
                SearchBar(text: $searchText)
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
                ForEach(favoriteStocks.filter({ searchText.isEmpty ? true : $0.name.lowercased().contains(searchText) ||  $0.id.lowercased().contains(searchText)})) {stock in
                     StockRow(stock: stock)
                }
            }
            .onAppear(perform: modelData.getLatestInfo)
            .onAppear{
                UITableView.appearance().separatorStyle = .none
            }
        .navigationBarTitle("Stocks")
        }
    }
}

struct StockList_Previews: PreviewProvider {
    static var previews: some View {
        StockList()
            .environmentObject(ModelData())
            .environmentObject(Favorites())
    }
}
