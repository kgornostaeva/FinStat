//
//  NewsRow.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 4/5/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//
//  News feature does not fully implemented due to this bug:
// UIScrollView does not support multiple observers implementing _observeScrollView:willEndDraggingWithVelocity:targetContentOffset:unclampedOriginalTarget...

import SwiftUI
import WebKit

struct NewsRow: View {
    var article: NewsPiece

    var body: some View {
        HStack {
            NavigationLink(destination: webView(url: article.url)
                .navigationBarTitle("", displayMode: .inline)) {
                VStack {
                    Text(article.title)
                    Text(article.publisher)
                }
            }
        }
        .padding(.horizontal, 10)
        .frame(width: 350, height: 70)
        .background(Color(.systemGreen))
        .cornerRadius(15)
    }
}

struct webView: UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: UIViewRepresentableContext<webView>) -> WKWebView {
        let view = WKWebView()
        view.load(URLRequest(url: URL(string: url)!))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<webView>) {
    }
}
