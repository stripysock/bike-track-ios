import SwiftUI

struct OnboardingView: View {
    enum InterfaceState: Hashable {
        case welcome
        case signIn
        case signUp
    }
    
    @State private var interfaceState: InterfaceState = .welcome
    
    var body: some View {
        VStack {
            LogoView()
               
            Text("BikeTrack")
                .font(.title)
                .fontDesign(.rounded)
                .bold()
                .multilineTextAlignment(.center)
            
            switch interfaceState {
            case .welcome:
                WelcomeView(interfaceState: $interfaceState)
                
            case .signIn:
                SignInView {
                    interfaceState = .welcome
                }
                
            case .signUp:
                SignUpView {
                    interfaceState = .welcome
                }
            }
        }
        .animation(.easeInOut, value: interfaceState)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
