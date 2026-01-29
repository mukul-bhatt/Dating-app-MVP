//
//  Profile.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 21/01/26.
//


import SwiftUI


var backgroundPink = Color("BrandColor")
var foregroundPink = Color("ButtonColor")

// MARK: - Models
//struct Profile: Identifiable {
//    let id = UUID()
//    let name: String
//    let age: Int
//    let distance: String
//    let matchPercentage: Int
//    let imageName: String
//}

// MARK: - Main View
struct DiscoverView: View {
    @Binding var path: NavigationPath
    @ObservedObject var viewModel: DiscoverViewModel
    @State var triggerSwipe: SwipeDirection? = nil
    
    var body: some View {
        ZStack {
            // Background
            Color(backgroundPink)
                .ignoresSafeArea()
            
            VStack {

                    DiscoverHeader()
                    
                    Spacer()
                    
                    CardStackView(viewModel: viewModel, triggerSwipe: $triggerSwipe, path: $path)

                    Spacer()
                    
                    ActionButtons(viewModel: viewModel, triggerSwipe: $triggerSwipe)
                    Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
    }
}

// MARK: - Buttons Section
struct ActionButtons: View {
    
    @ObservedObject var viewModel: DiscoverViewModel
    @Binding var triggerSwipe: SwipeDirection?
    
    func handleSwipe(direction: SwipeDirection){
        // Do swipe animation
        triggerSwipe = direction
        
        // inform the backend about the like/Pass
//        if direction == .left{
//            // call api for pass
//            viewModel.handleSwipeLeft(direction)
//        }else{
//            // call api for like
//            viewModel.handleSwipeRight(direction)
//            
//        }
        
    }
    
    var body: some View {
        HStack(spacing: 40) {
            // Decline/Pass Button
            Button(action: {
                print("Pass")
                handleSwipe(direction: .left)
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(foregroundPink)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            
            // Super Like/Message Button
            Button(action: {
                print("Super Like")
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 120)
                        .fill(.white)
                        .frame(width: 80, height: 80)
                    
                    Image("EnvelopeIcon")
                        .renderingMode(.template)
                        .font(.system(size: 26))
                        .foregroundColor(foregroundPink)
                        .clipShape(Rectangle())
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 18))
                        .foregroundColor(foregroundPink)
                        .offset(x: 0, y: 0)
                }
                .shadow(color: Color(red: 0.91, green: 0.33, blue: 0.55).opacity(0.4), radius: 8, x: 0, y: 4)
            }
            
            // Like/Accept Button
            Button(action: {
                print("Like")
                handleSwipe(direction: .right)
            }) {
                Image(systemName: "checkmark")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(foregroundPink)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
        }
    }
}
// MARK: - HEADER
struct DiscoverHeader: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Discover")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(foregroundPink)
            Spacer()
            Button(action: {}) {
                Image(systemName: "slider.horizontal.3")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
        }
    }
}

// MARK: - Tab Button
struct TabButton: View {
    let icon: String
    let isActive: Bool
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview
struct DiscoverView_Previews: PreviewProvider {
    
    static var previews: some View {
        NativeTabView()
    }
}




// Card Stack
//                ZStack {
//                    ForEach(profiles.indices.reversed(), id: \.self) { index in
//                        if index < 3 {
//                            ProfileCard(profile: profiles[index])
//                                .offset(y: CGFloat(index * 10))
//                                .scaleEffect(1 - CGFloat(index) * 0.05)
//                                .opacity(index == 0 ? 1 : 0.5)
//                                .offset(x: index == 0 ? dragOffset.width : 0)
//                                .rotationEffect(.degrees(index == 0 ? rotation : 0))
//                                .gesture(
//                                    index == 0 ? DragGesture()
//                                        .onChanged { value in
//                                            dragOffset = value.translation
//                                            rotation = Double(value.translation.width / 20)
//                                        }
//                                        .onEnded { value in
//                                            let threshold: CGFloat = 100
//                                            if abs(value.translation.width) > threshold {
//                                                // Swipe action
////                                                removeCard()
//                                            } else {
//                                                // Reset
//                                                withAnimation(.spring()) {
//                                                    dragOffset = .zero
//                                                    rotation = 0
//                                                }
//                                            }
//                                        } : nil
//                                )
//                        }
//                    }
//                }
//                .frame(height: 500)
//                .padding(.horizontal, 20)
