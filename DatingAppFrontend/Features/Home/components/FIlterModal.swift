//
//  FIlterModal.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 30/01/26.
//

import SwiftUI

struct FilterModal: View {
    
    @ObservedObject var viewModel: DiscoverViewModel
    @Binding var path: NavigationPath
    @Binding var showFilterModal: Bool
    
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
                    
                    VStack(alignment: .leading){
                        RadioButton(isSelected: $viewModel.selectedGender, label: "Male")
                        RadioButton(isSelected:  $viewModel.selectedGender, label: "Female")
                        RadioButton(isSelected:  $viewModel.selectedGender, label: "Transgender")
                        RadioButton(isSelected:  $viewModel.selectedGender, label: "Prefer not to say")
                        RadioButton(isSelected:  $viewModel.selectedGender, label: "All")
                    }
                    
                    RangeSlider(minValue: $viewModel.minAge, maxValue: $viewModel.maxAge, range: 18...65, title: "Preferred age Range")
                    
                    RangeSlider(minValue: $viewModel.minDistance, maxValue: $viewModel.maxDistance, range: 1...65, title: "Distance Range")
                }
                
                
                
                Button {
                    showFilterModal = false
                    // update the preferences
                    Task{
                        await viewModel.updatePreferences()
                        
                        // THe above api return the new data for profiles - use it to update data for Discover Profiles
                        
                        
                        
                        
                        // Navigate to Discover Screen
//                        path.removeAll()
                        path = NavigationPath()
                    }
                    
                } label: {
                    Text("Apply")
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 70)
                        .background(AppTheme.foregroundPink)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }

                
                
                
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
                .frame(width: 10, height: 10)
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
    FilterModal(
        viewModel: DiscoverViewModel(),
        path: .constant(NavigationPath()),
        showFilterModal: .constant(true)
    )
}
