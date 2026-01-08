//
//  DatePickerView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 06/01/26.
//

import SwiftUI



func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"  // This gives you DD/MM/YYYY
    return formatter.string(from: date)
}

struct DatePickerView: View {
    
    @Binding var date: Date
    @State private var showDatePicker: Bool = false
    @State private var hasSelectedDate: Bool = false
    
    

    var body: some View {
        VStack(alignment: .leading){
            Text("Date of Birth")
                .font(.caption)
                .foregroundStyle(.secondary)
            

            HStack{
                Text(hasSelectedDate ? formattedDate(date) : "DD/MM/YYYY")
                    .font(.system(size: 16))
                    .foregroundStyle(hasSelectedDate ? Color.primary : .secondary)
                Spacer()
                Image(systemName: "calendar")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .overlay{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary.opacity(0.5))
                }
            .onTapGesture {
               showDatePicker = true
            }
            .sheet(isPresented: $showDatePicker){
                VStack{
                    HStack {
                            Text("Please select your Date of Birth")
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                    
                    DatePicker(
                        "Today",
                        selection: $date,
                        in: ...Date(),
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    .onChange(of: date){
                        showDatePicker = false
                        hasSelectedDate = true
                    }
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showDatePicker = false
                                hasSelectedDate = true
                            }
                        }
                    }
                    
                    
                }
                .frame(maxWidth : .infinity, maxHeight: .infinity)
                .background(Color("BrandColor"))
                
            }
            
            
            
        }
        
       
    }
}

//#Preview {
//    DatePickerView().padding()
//}
