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
    @EnvironmentObject var searches: SearchResultData

    @State private var searchText = ""
    @State private var index: Int = 0
    
    let pages: [PageViewData] = [
        PageViewData(pageName: "Stocks"),
        PageViewData(pageName: "Favourite"),
    ]
    
    var body: some View {
        NavigationView {
             VStack {
                SearchBar(text: $searchText)
                
                if searchText.isEmpty {
                    HStack(alignment: .firstTextBaseline) {
                        ForEach(0..<self.pages.count) { index in
                            Switcher(isSelected: Binding<Bool>(get: { self.index == index }, set: { _ in }), title: self.pages[index].pageName) {
                                    self.index = index
                            }
                        }
                        Spacer()
                    }.padding(.leading)
                    
                    SwiperView(pages: self.pages, index: self.$index)
                        .environmentObject(modelData)
                        .environmentObject(favorites)
                        .environmentObject(searches)
                } else {
                    HStack {
                        Text("Stocks")
                            .bold()
                            .font(.title)
                        Spacer()
                    }.padding(.leading)
                    
                    PageView(viewData: PageViewData(pageName: "Search"))
//                        .onAppear {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                self.searches.getLatestInfo(self.searchText)
//                            }
//                    }
                }
        }
        .navigationBarHidden(true)
        .navigationBarTitle("Stocks")
        }
}

struct StockList_Previews: PreviewProvider {
    static var previews: some View {
        StockList()
            .environmentObject(ModelData())
            .environmentObject(Favorites())
            .environmentObject(SearchResultData())
    }
}
}
