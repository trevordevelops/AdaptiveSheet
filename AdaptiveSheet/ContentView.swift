//
//  ContentView.swift
//  AdaptiveSheet
//
//  Created by Trevor Welsh on 9/16/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showSheet: Bool = true
    var body: some View {
        ZStack {
            Button {
                showSheet.toggle()
            } label: {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Hello, world!")
                }
                .padding()
            }
        }
        .adaptiveSheet(isPresented: $showSheet,
                       detents: [.medium(), .large()],
                       largestUndimmedDetentIdentifier: .large,
                       prefersScrollingExpandsWhenScrolledToEdge: true,
                       prefersEdgeAttachedInCompactHeight: true,
                       cornerRadius: 25,
                       backgroundColor: .black,
                       prefersGrabberVisible: true,
                       canDismissSheet: true) {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(0..<50) { i in
                        Text("No need for iOS 16! \(i)")
                            .foregroundColor(.white)
                    }
                }
                .padding(.top)
            }
        }
    }
    
    /*
     custom fraction detent (requires iOS 16)
     
     .adaptiveSheet(isPresented: $showSheet,
                    detents: [fraction(0.25), .large()],
                    canDismissSheet: true) { }
     
    */
    @available(iOS 16.0, *)
    private func fraction(_ value: Double) -> UISheetPresentationController.Detent {
        return .custom { context in
            context.maximumDetentValue * value
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
