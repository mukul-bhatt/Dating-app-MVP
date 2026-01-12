//
//  DistanceSlider.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 09/01/26.
//

import SwiftUI

struct DistanceSlider: View {
    @State private var distance: Double = 33  // Middle value
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 1. Label
            Text("Preferred distance (KM): \(Int(distance))")
                .font(.system(size: 16))
                .foregroundColor(.primary)
            // 2. Slider
            Slider(value: $distance, in: 1...65, step: 1)
                .tint(Color("ButtonColor"))
            
            // 3. Min/Max labels
            HStack {
                Text("1KM")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("65KM+")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

//struct DistanceSlider2: View {
//    @State private var distance: Double = 33.0
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("Preferred distance (KM) \(Int(distance))")
//                .font(.system(size: 16))
//                .foregroundColor(.black)
//            
//            Slider(value: $distance, in: 1...65, step: 1)
//                .tint(Color("ButtonColor"))  // Pink track
//                .accentColor(Color.pink)  // Pink thumb (iOS 15+)
//            
//            HStack {
//                Text("\(Int(distance))KM")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                Spacer()
//                Text("65KM")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }
//        }
//        .padding()
//    }
//}

#Preview{
    DistanceSlider()
//    DistanceSlider2()
    
}
