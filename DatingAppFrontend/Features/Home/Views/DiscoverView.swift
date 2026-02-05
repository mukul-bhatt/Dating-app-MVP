//
//  Profile.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 21/01/26.
//


import SwiftUI


var backgroundPink = Color("BrandColor")
var foregroundPink = Color("ButtonColor")

// MARK: - Main View
struct DiscoverView: View {
    @Binding var path: NavigationPath
    @ObservedObject var viewModel: DiscoverViewModel
    @State var triggerSwipe: SwipeDirection? = nil
    @State private var showFilterModal = false
    var body: some View {
        ZStack {
            // Background
            backgroundPink
                .ignoresSafeArea()
            
            VStack {

                    DiscoverHeader(showFilterModal: $showFilterModal)
                    
                    Spacer()
                    
                    CardStackView(viewModel: viewModel, triggerSwipe: $triggerSwipe, path: $path)

                    Spacer()
                    
                    ActionButtons(viewModel: viewModel, triggerSwipe: $triggerSwipe)
                    Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
        .sheet(isPresented: $showFilterModal) {
            FilterModal(viewModel: viewModel, path: $path, showFilterModal: $showFilterModal)
                .presentationDetents([.fraction(0.8)])
                .presentationBackground(.white)
                .presentationDragIndicator(.visible)
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
//            Button(action: {
//                print("Super Like")
//            }) {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 120)
//                        .fill(.white)
//                        .frame(width: 80, height: 80)
//                    
//                    Image("EnvelopeIcon")
//                        .renderingMode(.template)
//                        .font(.system(size: 26))
//                        .foregroundColor(foregroundPink)
//                        .clipShape(Rectangle())
//                    
//                    Image(systemName: "heart.fill")
//                        .font(.system(size: 18))
//                        .foregroundColor(foregroundPink)
//                        .offset(x: 0, y: 0)
//                }
//                .shadow(color: Color(red: 0.91, green: 0.33, blue: 0.55).opacity(0.4), radius: 8, x: 0, y: 4)
//            }
//            
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
    @Binding var showFilterModal: Bool
    var body: some View {
        HStack {
            Spacer()
            Text("Discover")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(foregroundPink)
            Spacer()
            Button(action: {
                showFilterModal.toggle()
            }) {
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
