//
//  FIlterModal.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 30/01/26.
//

import SwiftUI

struct FilterModal: View {
    @State var isBlockingUser: Bool = false
    @State private var selection = 0
    @State var selectedGender: String = ""
    @State private var minAge: Double = 18
    @State private var maxAge: Double = 65
    @State private var minDistance: Double = 1
    @State private var maxDistance: Double = 65
//    @State private var ageRange: ClosedRange<Double> = 18...60
//    @State private var distanceRange: ClosedRange<Double> = 1...65
    var body: some View {
        ZStack{
            Color.clear
            
            VStack(spacing: 10){
                Text("Apply Filters")
                    .font(.headline)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Gender")
                        .fontWeight(.semibold)
                    
                    HStack{
                        RadioButton(isSelected: $selectedGender, label: "Men")
                        RadioButton(isSelected: $selectedGender, label: "Women")
                        RadioButton(isSelected: $selectedGender, label: "Trans")
                        RadioButton(isSelected: $selectedGender, label: "Non Binary")
                        RadioButton(isSelected: $selectedGender, label: "All")
                    }
                    
                    RangeSlider(minValue: $minAge, maxValue: $maxAge, range: 18...65, title: "Preferred age Range")
                    
                    RangeSlider(minValue: $minDistance, maxValue: $maxDistance, range: 1...65, title: "Distance Range")
                }
                
                Text("Apply")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 70)
                    .background(AppTheme.foregroundPink)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
            }
            .padding(.horizontal)
        }
    }
}


struct RadioButton: View {
    @Binding var isSelected: String
    
    let label: String
    var body: some View {
        HStack{
            Circle()
                .stroke(Color.primary, lineWidth: 2)
                .frame(maxWidth: 10, maxHeight: 10)
                .overlay(
                    Circle().fill(isSelected == label ? .pink: .gray.opacity(0.5))
                )
            Text(label)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                isSelected = label
            }
        }
    }
}

#Preview {
    FilterModal()
}

