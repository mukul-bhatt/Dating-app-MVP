//
//  TwoThumbSlider.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 15/01/26.
//

import SwiftUI
    
struct RangeSlider: View {
    @Binding var minValue: Double
    @Binding var maxValue: Double
    let range: ClosedRange<Double>
    var title: String = "Preferred distance (KM):"
    
    private func xPosition(for value: Double, width: CGFloat) -> CGFloat {
        let thumbRadius: CGFloat = 12  // Half of the circle's width (24/2)
        let usableWidth = width - (2 * thumbRadius)  // Subtract space for both thumbs
        
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return (percentage * usableWidth) + thumbRadius  // Add back one radius for offset
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            
            // 1. Label
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            // 2. Slider
            GeometryReader{ geometry in
                ZStack(alignment: .leading){
                    Rectangle()
                        .fill(Color("ButtonColor"))
                        .frame(height: 4)
                    
                    
                    let minX = xPosition(for: minValue, width: geometry.size.width)
                    let maxX = xPosition(for: maxValue, width: geometry.size.width)
                    
                    Rectangle()
                        .fill(Color("ButtonColor"))
                        .frame(width: maxX - minX, height: 4)
                        .offset(x: minX)
                    
                    Circle()
                        .fill(Color.primary)
                        .frame(width: 24, height: 24)
                        .position(x: xPosition(for: minValue, width: geometry.size.width), y: 15)
                        .gesture(
                            DragGesture()
                                .onChanged{ value in
                                    let trackWidth = geometry.size.width
                                    let percentage = value.location.x / trackWidth
                                    let newValue = percentage * (range.upperBound - range.lowerBound) + range.lowerBound
                                    minValue = min(max(newValue, range.lowerBound), maxValue)
                                    
                                    print("New age: \(minValue)")
                                }
                        )
                    
                    
                    Circle()
                        .fill(Color.primary)
                        .frame(width: 24, height: 24)
                        .position(x: xPosition(for: maxValue, width: geometry.size.width), y: 15)
                        .gesture(
                            DragGesture()
                                .onChanged{ value in
                                    let trackWidth = geometry.size.width
                                    let percentage = value.location.x / trackWidth
                                    let newValue = percentage * (range.upperBound - range.lowerBound) + range.lowerBound
                                    maxValue = max(min(newValue, range.upperBound), minValue)
                                    
                                    print("New age: \(maxValue)")
                                }
                        )
                    
                    
                }
                
                
            }.frame(height: 30)
                
            // 3. Min/Max labels
           
            
            if title == "Preferred age Range" {
                HStack {
                    Text("\(Int(minValue))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(maxValue == range.upperBound ? "\(Int(maxValue))+" :"\(Int(maxValue))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }else{
                    HStack {
                            Text("\(Int(minValue))KM")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            Spacer()
                        Text(maxValue == range.upperBound ? "\(Int(maxValue))KM+" :"\(Int(maxValue))KM")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                }
            
        }
        
    }
       
}


