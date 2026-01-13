//
//  SexualitySection.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//

import SwiftUI

  struct SexualitySection: View {
        
        // MARK: - Data Models
        let sexualityOptions = [
            "Straight", "Bisexual", "Gay", "Lesbian",
            "Pansexual", "Asexual", "Demisexual",
            "Queer", "Open to all"
        ]
      
      @ObservedObject var viewModel: ProfileViewModel
     
      var isMultiSelect: Bool = false
      
      // Dynamic helper to check selection state
          private var isSelected: (String) -> Bool {
              { name in
                  if isMultiSelect {
                      return viewModel.selectedPartnerSexuality.contains(name)
                  } else {
                      return viewModel.sexuality == name
                  }
              }
          }
      
      
      private func handleSelection(for name: String) {
              if isMultiSelect {
                  // Logic for Multi-Select (Partner Preferences)
                  if viewModel.selectedPartnerSexuality.contains(name) {
                      viewModel.selectedPartnerSexuality.remove(name)
                  } else {
                      viewModel.selectedPartnerSexuality.insert(name)
                  }
              } else {
                  // Logic for Single-Select (User's Own Sexuality)
                  viewModel.sexuality = name
              }
          }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Sexuality")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Custom Flow Layout Container
                FlowLayout(items: sexualityOptions) { item in
                    
                    Button(action: {
//                        viewModel.sexuality = item
                        handleSelection(for: item)
                    }) {
                        Text(item)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(isSelected(item) ? Color.white : Color.primary)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(isSelected(item) ? Color("ButtonColor") : Color.clear)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(isSelected(item) ? Color("ButtonColor") : .secondary, lineWidth: isSelected(item) ? 2 : 1)
                            )
                    }
                }
            }
        }
    }
    
    

// MARK: - Helper: Flow Layout
// Simple helper to wrap items to the next line
struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let items: Data
    let content: (Data.Element) -> Content
    
    @State private var totalHeight: CGFloat = .zero
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                self.content(item)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == self.items.last! {
                            width = 0 // last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if item == self.items.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

