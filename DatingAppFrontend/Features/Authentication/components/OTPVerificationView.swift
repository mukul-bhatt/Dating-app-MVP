import SwiftUI

struct OTPVerificationView: View {

    @ObservedObject var viewModel: ProfileViewModel
    @Binding var otpText : [String]
    
    
    var screenType : String = "WelcomeBack!"
    var actionForPrimaryButton : () -> Void = { }
    
    // Custom Colors
    // Keep background consistent with LoginView
    let backgroundColor = Color("BrandColor")
    let accentPink = Color("BrandColor")
    var maskedPhoneNumber: String {
        let phoneNumber = viewModel.phoneNumber
        let lastTwo = phoneNumber.suffix(2)
        let masked = "********" + lastTwo
        return masked
    }
    
    // State For Timer
    @State private var timeRemaining = 69
    @State private var isRunning = true
    @State private var timerID = UUID()
    func formatTime(_ seconds: Int) -> String {
           let minutes = seconds / 60
           let seconds = seconds % 60
           return String(format: "%d:%02d", minutes, seconds)
       }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Layer
                backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    
                    // Logo Section
                    
                    AuthHeader(
                        title: screenType,
                        subtitle: "Please enter the OTP sent on \(maskedPhoneNumber)"
                    )
                    
                    
                    // OTP View
                    VStack(alignment: .trailing) {
                        
                        LoginOtpView(otp: $otpText)

                        if timeRemaining > 0 {
                            Text("Resend OTP in \(formatTime(timeRemaining))")
                                .font(.caption)
                                .foregroundColor(.primary)
                                .padding(.top, 10)
                        } else {
                            Button("Resend OTP") {
                                timeRemaining = 60
                                isRunning = true
                                timerID = UUID()
                            }
                            .font(.caption)
                            .foregroundColor(.primary)
                            .padding(.top, 10)
                        }
                                
                    }
                    .padding(.horizontal)
                    .task(id: timerID) {
                                while isRunning && timeRemaining > 0 {
                                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                                    if isRunning {
                                        timeRemaining -= 1
                                    }
                                }
                            }
                    .onDisappear {
                            isRunning = false // Stop timer when leaving screen
                        }
                        .onAppear {
                            isRunning = true // Restart if coming back
                        }
                    Spacer()
                    
                    
                    PrimaryButton(buttonText: "Verify OTP", action: actionForPrimaryButton)
                        .padding(.horizontal)
                        
                }.padding(.top, 30)
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        
        
    }
}



//struct OTPVerificationView_Previews: PreviewProvider {
//    static var previews: some View {
//        OTPVerificationView(viewModel: <#ProfileViewModel#>, otpText: <#Binding<[String]>#>)
//    }
//}
