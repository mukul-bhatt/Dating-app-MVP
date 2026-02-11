//
//  DeleteAccountView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct DeleteAccountView: View {
    var body: some View {
        VStack {
            Text("Delete Account")
                .font(.largeTitle)
                .foregroundColor(.red)
                .padding()
            Text("Are you sure you want to delete your account?")
                .padding()
            Spacer()
        }
        .navigationTitle("Delete Account")
    }
}

#Preview {
    DeleteAccountView()
}
