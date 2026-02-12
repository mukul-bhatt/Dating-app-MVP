//
//  AddPicturesHeader.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//

import SwiftUI

 struct AddPicturesHeader: View {
        var title: String
        var subTitle: String
        var isFromEditProfile: Bool = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(isFromEditProfile ? .subheadline : .system(size: 18, weight: .semibold))
                    .foregroundColor(isFromEditProfile ? .secondary : .primary)
                
                Text(subTitle)
                    .font(.system(size: 15))
                    .foregroundColor(isFromEditProfile ? .secondary : .primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
