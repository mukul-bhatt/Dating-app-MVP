//
//  NotificationSettingView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct NotificationSettingView: View {
    var body: some View {
        VStack {
            Text("Notification Settings")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle("Notifications")
    }
}

#Preview {
    NotificationSettingView()
}
