import SwiftUI

struct OTPVerificationView: View {
    
    var screenType : String = "WelcomeBack!"
    
    // Custom Colors
    // Keep background consistent with LoginView
    let backgroundColor = Color.pink.opacity(0.1)
    let accentPink = Color(red: 0.9, green: 0.28, blue: 0.48)
    
    // REMOVED: let textColor = ... (This was the problem)
    
    var body: some View {
        ZStack {
            // Background Layer
            backgroundColor
                .ignoresSafeArea()
            
            VStack {
                
                // Logo Section
                ZStack {
                    Image("appIcon")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .offset(y: 8)
                }
                .foregroundStyle(accentPink)
                .padding(.top, 50)
                .padding(.bottom, 10)
                
                // Title Section
                VStack(spacing: 8) {
                    Text(screenType)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.primary) // CHANGE: Adapts to Dark Mode
                    
                    Text("Please enter the OTP sent on ********50")
                        .font(.footnote)
                        .foregroundColor(.secondary) // CHANGE: Adapts automatically
                }
                .padding(.bottom, 30)
                
                // OTP Input Boxes
                VStack(alignment: .trailing) {
                    
                    LoginOtpView()
                    
                    // Timer Text
                    Text("Resend OTP in 1:09")
                        .font(.caption)
                        .foregroundColor(.primary) // CHANGE: Adapts to Dark Mode
                        .padding(.top, 10)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Verify Button
//                Button(action: {
//                    print("Verify OTP tapped")
//                }) {
//                    Text("Verify OTP")
//                        .font(.headline)
//                        .foregroundColor(.white) // White text on Pink button is always fine
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 60)
//                        .background(accentPink)
//                        .cornerRadius(30)
//                }
//                .padding(.bottom, 20)
//                .padding(.horizontal, 25)
                PrimaryButton(buttonText: "Verify OTP")
                    .padding(.horizontal)
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView()
    }
}
