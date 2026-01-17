import SwiftUI

struct OTPVerificationView: View {

    
    @Binding var otpText : [String]
    
    
    var screenType : String = "WelcomeBack!"
    var actionForPrimaryButton : () -> Void = { }
    
    // Custom Colors
    // Keep background consistent with LoginView
    let backgroundColor = Color("BrandColor")
    let accentPink = Color(red: 0.9, green: 0.28, blue: 0.48)
    var isDisabled: Bool{
       return otpText.count < 4 || otpText.contains(where: { $0.isEmpty })
    }
    

    
    var body: some View {
        NavigationStack {
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

//                     Title Section
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
                        
                        LoginOtpView(otp: $otpText)
                        
                        // Timer Text
                        Text("Resend OTP in 1:09")
                            .font(.caption)
                            .foregroundColor(.primary) // CHANGE: Adapts to Dark Mode
                            .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    
                    PrimaryButton(buttonText: "Verify OTP", action: actionForPrimaryButton, isDiabled: isDisabled)
                        .padding(.horizontal)
                        
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        
        
    }
}



//struct OTPVerificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        OTPVerificationView()
//    }
//}
