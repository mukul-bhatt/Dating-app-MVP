//
//  LogoutView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct LogoutView: View {
    var body: some View {
        VStack {
            Text("Logout")
                .font(.largeTitle)
                .padding()
            Text("Are you sure you want to log out?")
                .padding()
            Spacer()
        }
        .navigationTitle("Logout")
    }
}

#Preview {
    LogoutView()
}
