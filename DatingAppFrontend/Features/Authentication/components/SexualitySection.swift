//
//  SexualitySection.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//

import SwiftUI

  struct SexualitySection: View {
        
        // MARK: - Data Models
//        let sexualityOptions = [
//            "Straight", "Bisexual", "Gay", "Lesbian",
//            "Pansexual", "Asexual", "Demisexual",
//            "Queer", "Open to all"
//        ]
      
      @ObservedObject var viewModel: ProfileViewModel
     
      var isMultiSelect: Bool = false
      
      // Dynamic helper to check selection state
      private func isSelected(optionId : Int) -> Bool {
                  if isMultiSelect {
                      return viewModel.selectedPartnerSexualityIds.contains(optionId)
                  } else {
                      return viewModel.sexualityId == optionId
                  }
              }
      
      private func handleSelection(for id: Int) {
              if isMultiSelect {
                  // Logic for Multi-Select (Partner Preferences)
                  if viewModel.selectedPartnerSexualityIds.contains(id) {
                      viewModel.selectedPartnerSexualityIds.remove(id)
                  } else {
                      viewModel.selectedPartnerSexualityIds.insert(id)
                  }
              } else {
                  // Logic for Single-Select (User's Own Sexuality)
                  viewModel.sexualityId = id
              }
          }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("Sexuality")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Custom Flow Layout Container
                FlowLayout(items: viewModel.sexualityOptions) { option in
                    Button(action: {
                        handleSelection(for: option.id)
                    }) {
                        Text(option.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(isSelected(optionId: option.id) ? Color.white : Color.primary)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(isSelected(optionId: option.id) ? Color("ButtonColor") : Color.clear)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(isSelected(optionId: option.id) ? Color("ButtonColor") : .secondary, lineWidth: isSelected(optionId: option.id) ? 2 : 1)
                            )
                    }
                }
            }
            .onAppear {
                // Trigger the fetch if the list is empty
                if viewModel.sexualityOptions.isEmpty {
//                    Task { await viewModel.fetchMastersOptionsForSexuality() }
                    Task { await viewModel.loadSexualityOptions() }
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
                        
                        // ✅ SAFE CHECK: Instead of force unwrapping last!
                        if let lastItem = self.items.last, item == lastItem {
                            width = 0 // last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if let lastItem = self.items.last, item == lastItem {
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

