//
//  TypingIndicatorView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 25/02/26.
//

import SwiftUI

struct TypingIndicatorView: View {
    @State private var dotOffset1: CGFloat = 0
    @State private var dotOffset2: CGFloat = 0
    @State private var dotOffset3: CGFloat = 0
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.primary.opacity(0.7))
                    .frame(width: 6, height: 6)
                    .offset(y: dotOffset1)
                
                Circle()
                    .fill(Color.primary.opacity(0.7))
                    .frame(width: 6, height: 6)
                    .offset(y: dotOffset2)
                
                Circle()
                    .fill(Color.primary.opacity(0.7))
                    .frame(width: 6, height: 6)
                    .offset(y: dotOffset3)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(AppTheme.backgroundPink)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            
            Spacer(minLength: 60)
        }
        .onAppear {
            animateDots()
        }
    }
    
    private func animateDots() {
        let animation = Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)
        
        withAnimation(animation.delay(0)) {
            dotOffset1 = -5
        }
        withAnimation(animation.delay(0.2)) {
            dotOffset2 = -5
        }
        withAnimation(animation.delay(0.4)) {
            dotOffset3 = -5
        }
    }
}

#Preview {
    VStack {
        TypingIndicatorView()
            .padding()
        Spacer()
    }
    .background(Color.white)
}
