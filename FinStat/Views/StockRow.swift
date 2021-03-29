//
//  StockRow.swift
//  FinStat
//
//  Created by Ekaterina Gornostaeva on 3/25/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

import SwiftUI

struct StockRow: View {
    @EnvironmentObject var favorites: Favorites
    var stock: Stock

    var body: some View {
        HStack {
            Button(self.favorites.contains( self.stock) ? " " : " ") {
                if self.favorites.contains(self.stock) {
                    self.favorites.remove(self.stock)
                } else {
                    self.favorites.add( self.stock)
                }
            }

            Image(systemName: self.favorites.contains(stock) ? "star.fill" : "star")
                    .foregroundColor(self.favorites.contains(stock) ? Color(red: 0.29, green: 0.43, blue: 0.11) : Color.gray)
            
            VStack (alignment: .leading) {
                Text(stock.id)
                    .bold()
                    .foregroundColor(Color(red: 0.2, green: 0.17, blue: 0.04))
                Text(stock.name.capitalized)
                    .font(.footnote)
                    .foregroundColor(Color(red: 0.69, green: 0.54, blue: 0.01))
            }
            
            Spacer()
            VStack (alignment: .trailing) {
                HStack {
                    Text("\(stock.price, specifier: "%.2f")")
                    Text("USD")
                }
                .font(.headline)
                .foregroundColor(Color(red: 0.2, green: 0.17, blue: 0.04))
                
                HStack {
                    Text(stock.change >= 0 ? "+" : "") + Text("\(stock.change, specifier: "%.2f")")
                    Text("USD")
                }
                .font(.footnote)
                .foregroundColor(stock.change >= 0 ? Color(red: 0.29, green: 0.43, blue: 0.11) : Color.red)
            }
        }
        .padding()
        .frame(width: 350, height: 70)
        .background(Color(red: 0.99, green: 0.89, blue: 0.51), alignment: .leading)
        .cornerRadius(15)
    }
}


struct StockRow_Previews: PreviewProvider {
    static var stocks = ModelData().stocks

    static var previews: some View {
        StockRow(stock: stocks[0])
        .environmentObject(Favorites())
    }
}
