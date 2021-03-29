 //
//  ContentView.swift
//  FinStat
//
//  Created by Ekaterina Gornostaeva on 3/25/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        StockList()
        .environmentObject(ModelData())
        .environmentObject(Favorites())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(ModelData())
        .environmentObject(Favorites())
    }
}
