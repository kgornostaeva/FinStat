//
//  Switcher.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 4/5/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

import SwiftUI

struct Switcher: View {
    @Binding var isSelected: Bool
    var title: String
    let action: () -> Void

    var body: some View {
        Button(action: {
            self.action()
        }) {
            Text(title)
                .bold()
                .font(self.isSelected ? .largeTitle : .title)
                .foregroundColor(self.isSelected ? Color.black : Color(.systemGray2))
        }
    }
}
