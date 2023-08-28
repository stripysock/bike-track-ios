import SwiftUI

struct WelcomeView: View {
    @Binding var interfaceState: OnboardingView.InterfaceState
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Like a family photo album for your **real** loved ones.")
                .font(.body)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            VStack {
                Button {
                    interfaceState = .signUp
                } label: {
                    Text("Create Account")
                        .font(.headline)
                        .fontDesign(.rounded)
                        .frame(minWidth: 250)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel("Create Account")
                #if os(iOS)
                .buttonBorderShape(.capsule)
                #endif
                
                Button {
                    interfaceState = .signIn
                } label: {
                    Text("I already have an account")
                        .font(.body)
                }
                .accessibilityLabel("Sign In To Account")
            }
        }
        .padding()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(interfaceState: .constant(.welcome))
    }
}
