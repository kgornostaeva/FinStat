//
//  SearchBar.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 3/29/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

// Used code from https://www.appcoda.com/swiftui-search-bar/

import SwiftUI
 
struct SearchBar: View {
    @Binding var text: String

    @State private var isEditing = false

    var body: some View {
        ZStack {
             TextField("Find company or ticker", text: $text)
                .autocapitalization(.none)
                .padding(7)
                .padding(.horizontal, 30)
                .font(.subheadline)
                .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.black, lineWidth: 1))
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                    }
                )
                .padding(.horizontal, 5)
                .padding(.top, 30)
                .padding(.vertical, 10)
                .onTapGesture {
                    self.isEditing = true
                }

            if isEditing {
                HStack {
                    Spacer()
                    Button(action: {
                        self.isEditing = false
                        self.text = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }
                    .padding(.trailing, 10)
                    .padding(.horizontal, 10)
                    .padding(.top, 30)
                    .animation(.default)
                }
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
