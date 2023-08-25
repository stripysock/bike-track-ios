import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var userService: UserService
    
    enum InterfaceState: Hashable {
        case idle
        case signingUp
        case signUpFailed(String)
    }
    
    var returnAction: (() -> Void)? = nil
    
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var interfaceState: InterfaceState = .idle
    
    private var submitIsEnabled: Bool {
        !emailAddress.isEmpty && !password.isEmpty
    }
    
    private var fieldsAreEnabled: Bool {
        interfaceState != .signingUp
    }
    
    private var buttonLabel: String {
        if case .signingUp = interfaceState {
            return "Signing Up..."
        } else {
            return "Sign Up"
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign up for an account.")
                .font(.body)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
            
            CredentialFormView(emailAddress: $emailAddress, password: $password)
                .disabled(!fieldsAreEnabled)
            
            switch interfaceState {
            case .idle:
                EmptyView()
            case .signingUp:
                ProgressView()
            case .signUpFailed(let message):
                Text(message)
                    .font(.caption)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            VStack {
                Button {
                    self.signUp()
                } label: {
                    Text(buttonLabel)
                        .font(.headline)
                        .fontDesign(.rounded)
                        .frame(minWidth: 250)
                }
                .buttonStyle(.borderedProminent)
#if os(iOS)
                .buttonBorderShape(.capsule)
#endif
                .disabled(!fieldsAreEnabled)
                
                if let returnAction = returnAction {
                    Button {
                        returnAction()
                    } label: {
                        Text("I think I have an account. ")
                            .font(.body)
                    }
                    .disabled(!fieldsAreEnabled)
                }
            }
        }
        .padding()
    }
    
    private func signUp() {
        interfaceState = .signingUp
        Task {
            do {
                try await userService.signUp(emailAddress: emailAddress, password: password)
            } catch {
                interfaceState = .signUpFailed(error.localizedDescription)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
