//
//  PrivacySettingsView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct PrivacySettingsView: View {
    var body: some View {
        VStack {
            Text("Privacy Settings")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle("Privacy")
    }
}

#Preview {
    PrivacySettingsView()
}
