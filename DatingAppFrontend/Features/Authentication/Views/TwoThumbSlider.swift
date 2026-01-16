//
//  TwoThumbSlider.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 15/01/26.
//

import SwiftUI

struct TwoThumbSlider: View {
    
    @State var minAge: Double
    @State var maxAge: Double
    
    var body: some View {
        Slider(value: $minAge, in: 1...65, step: 1)
        Slider(value: $maxAge, in: 1...65, step: 1)
    }
}

#Preview {
    TwoThumbSlider(minAge: 18, maxAge: 65)
}
