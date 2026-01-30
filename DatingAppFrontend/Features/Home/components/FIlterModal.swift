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
    var body: some View {
        ZStack{
//            AppTheme.backgroundPink.ignoresSafeArea()
            Color.clear
            
            VStack{
                Text("Apply Filters")
                
                Text("Gender")
                HStack{
                    RadioButton(isSelected: $selectedGender, label: "Men")
                    RadioButton(isSelected: $selectedGender, label: "Women")
                    RadioButton(isSelected: $selectedGender, label: "Trans")
                    RadioButton(isSelected: $selectedGender, label: "Non Binary")
                    RadioButton(isSelected: $selectedGender, label: "All")
                }
                
                Text("Apply")
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 70)
                    .background(AppTheme.foregroundPink)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
                Toggle("Block this user", isOn: $isBlockingUser)
                                .tint(AppTheme.foregroundPink)
                
                Picker("Options", selection: $selection) {
                            Text("Option A").tag(0)
                            Text("Option B").tag(1)
                        }
                        .pickerStyle(.segmented) // 1. Makes it look like a rounded selector
                        .padding()
                
                
               
            }
        }
    }
}


struct RadioButton: View {
    @Binding var isSelected: String
    
    let label: String
    var body: some View {
        HStack{
            Circle()
                .stroke(Color.black, lineWidth: 2)
                .frame(maxWidth: 15, maxHeight: 15)
                .overlay(
                    Circle().fill(isSelected == label ? .pink: .clear)
                )
                .onTapGesture {
                    withAnimation {
                        isSelected = label
                    }
                    
                }
            Text(label)
        }
    }
}

#Preview {
    FilterModal()
}
