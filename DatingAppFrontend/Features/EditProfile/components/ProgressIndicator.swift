//
//  ProgressIndicator.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/02/26.
//

import SwiftUI

// MARK: - Progress Indicator
struct ProgressIndicator: View {
    let currentStep: Int
    
    var body: some View {
        
        HStack {
            Spacer()
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Capsule()
                        .fill(index == currentStep ? AppTheme.foregroundPink : Color.black.opacity(0.7))
                        .frame(height: 4)
                }
            }
            .frame(maxWidth: 200, maxHeight: 40)
            .padding(.vertical, 10)
            Spacer()
        }
    }
}
