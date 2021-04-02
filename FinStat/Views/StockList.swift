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
    @State private var color = false
    @State private var searchText = ""
    
    var favoriteStocks: [Stock] {
          modelData.stocks.filter { stock in
              (!showFavoritesOnly || favorites.contains(stock))
          }
      }
    
    init() {
        //this changes the "thumb" that selects between items
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        //and this changes the color for the whole "bar" background
        UISegmentedControl.appearance().backgroundColor = .white

        //this will change the font size
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .largeTitle)], for: .normal)

        //these lines change the text color for various states
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.blue], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.blue], for: .normal)
    }
    
    var body: some View {
        NavigationView {
            List {
                SearchBar(text: $searchText)
                Picker("", selection: $showFavoritesOnly, content: {
                               Text("Stocks").tag(false)
                               Text("Favorites").tag(true)
                           })
                    .pickerStyle(SegmentedPickerStyle())
                ForEach(favoriteStocks.filter({ searchText.isEmpty ? true : $0.name.lowercased().contains(searchText) ||  $0.id.lowercased().contains(searchText)})) { stock in
                    StockRow(stock: stock, color: self.$color)
                }
            }
            .onAppear {
                self.modelData.getLatestInfo()
                self.favorites.load()
                UITableView.appearance().separatorStyle = .none
            }
        .navigationBarHidden(true)
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
