//
//  MyMatchesView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct MyMatchesView: View {
    var body: some View {
        VStack {
            Text("My Matches")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle("My Matches")
    }
}

#Preview {
    MyMatchesView()
}
