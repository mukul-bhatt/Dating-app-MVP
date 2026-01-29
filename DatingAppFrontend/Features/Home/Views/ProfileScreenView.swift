//
//  ProfileScreenView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 28/01/26.
//

import SwiftUI
import WrappingHStack

let imageUrls = [
    "https://www.verblio.com/wp-content/uploads/2018/08/ariane_stock_photo.jpg",
    "https://st2.depositphotos.com/4431055/11871/i/450/depositphotos_118714868-stock-photo-beautiful-girl-holding-hair.jpg",
    "https://c8.alamy.com/comp/D9G036/portrait-of-a-beautiful-woman-smiling-D9G036.jpg"
]

let passions: [PassionItem] = [
    PassionItem(name: "Cooking", icon: "frying.pan.fill", color: Color(red: 1.0, green: 0.95, blue: 0.8)),
    PassionItem(name: "Painting", icon: "paintpalette.fill", color: Color(red: 0.9, green: 1.0, blue: 0.9)),
    PassionItem(name: "Singing", icon: "mic.fill", color: Color(red: 0.9, green: 0.95, blue: 1.0)),
    PassionItem(name: "Gym", icon: "dumbbell.fill", color: Color(red: 1.0, green: 0.85, blue: 0.85)),
    PassionItem(name: "Travel", icon: "airplane", color: Color(red: 0.85, green: 1.0, blue: 0.9)),
    PassionItem(name: "Vlogs", icon: "video.fill", color: Color(red: 0.95, green: 0.85, blue: 1.0)),
    PassionItem(name: "Literature", icon: "book.fill", color: Color(red: 0.95, green: 0.9, blue: 1.0))
]

struct PassionItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

struct ProfileScreenView: View {
    
    @ObservedObject var viewModel: DiscoverViewModel
    
    var body: some View {
        ZStack{
            
            // Background Color
            AppTheme.backgroundPink
                    .ignoresSafeArea()
            
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 16){
                    
                   // Top slider and Images
                   HeaderView()
                    
                   //Primary information
                    PrimaryInformation()
                    
                    // Location and work information
                    LocationAndWork()
                    
                    // Bio
                    Bio()
                    
                    // Passions
                    Passions()
                    
                    // Action Buttons
                    ActionButtonsProfile()
                    
                    // Footer
                    Footer()
                        
//                    Spacer()
                }
            }.padding(.horizontal)
            
           
        }
        
       
    }
}

struct Footer: View {
    var body: some View {
        // 8. Footer
        Button(action: {}) {
            Text("Report profile")
                .font(.subheadline)
                .foregroundColor(AppTheme.foregroundPink)
                .padding(.vertical, 12)
                .padding(.horizontal, 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppTheme.foregroundPink.opacity(0.5), lineWidth: 1)
                )
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 10)
    }
}





struct Passions: View{
    var body: some View{
        VStack(alignment: .leading, spacing: 10) {
            Text("Passion")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            // Simple Flow Layout using wrapping stacks
//            WrappingHStack(items: passions)
            WrappingHStack(passions, id: \.self, spacing: .constant(15), lineSpacing: 10){ passion in
        
                    PassionChip(item: passion)
                }
            }
        }
    }


//struct WrappingHStack: View {
//    let items: [PassionItem]
//    
//    var body: some View {
//        // This is a simple logic to group items into two rows to mimic the screenshot
//        // In a real app, you might use 'Layout' protocol or a proper FlowLayout library
//        VStack(alignment: .leading, spacing: 10) {
//            HStack {
//                ForEach(items.prefix(3)) { item in
//                    PassionChip(item: item)
//                }
//            }
//            HStack {
//                ForEach(items.dropFirst(3)) { item in
//                    PassionChip(item: item)
//                }
//            }
//        }
//    }
//}

struct PassionChip: View {
    let item: PassionItem
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: item.icon)
                .font(.caption)
            Text(item.name)
                .font(.callout)
                .fontWeight(.medium)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(item.color)
        .cornerRadius(20)
        .foregroundColor(.primary.opacity(0.8))
    }
}

struct Bio: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bio")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Text("Independent, curious, and always up for deep conversations or spontaneous adventures. I love slow mornings, fast Wi-Fi, and people who can make me laugh. Looking for something real—with someone who’s kind, driven, and a little bit witty.")
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(4)
        }
    }
}

struct LocationAndWork: View {
    var body: some View {
        VStack(alignment:.leading ,spacing: 12) {
            
            VStack(alignment:.leading) {
                HStack{
                        Image("LocationPin")
                        Text("Location")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                    Text("Greater Noida  •  3 Km away")
                        .foregroundColor(.primary)
                
            }
            
            VStack(alignment:.leading) {
                HStack{
                    Image(systemName: "briefcase")
                    Text("Work")
                        .font(.caption)
                        .foregroundColor(.primary)
                    }
                Text("Data analyst")
                    .foregroundColor(.primary)
                
            }
        }
    }
}

struct PrimaryInformation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Nia Sharma, 26")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Image(systemName: "checkmark.seal.fill")
                    .font(.title3)
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image("HeartIcon").font(.title)
                    Text("89%").font(.headline)
                }
                .foregroundColor(.primary)
            }
            
            Text("Taurus  •  Hindu  •  165 cm  •  Vegan")
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}


struct HeaderView: View {
    
    @State var position: Int = 0
    
    var body: some View{
        HStack(spacing: 8) {
            
            ForEach(imageUrls.indices, id: \.self) { index in
                Capsule().fill(position == index ? AppTheme.foregroundPink : .white).frame(height: 4)
            }
        }
        .padding(.top, 10)
        
        TabView(selection: $position){
            
            ForEach(imageUrls.indices, id: \.self) { index in
                ImageView(position: index).tag(index)
                }
            
        }.tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct ImageView: View {
    
    var position: Int
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrls[position])) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Color.gray.opacity(0.3)
        }
        .frame(height: 400)
//        .clipShape(RoundedRectangle(cornerRadius: 15))
//        .clipped()
    }
}


#Preview {
    ProfileScreenView()
}
