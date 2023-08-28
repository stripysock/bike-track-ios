import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userService: UserService
    
    enum InterfaceState: Hashable {
        case idle
        case signingIn
        case signInFailed(String)
    }
    
    var returnAction: (() -> Void)? = nil
    
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var interfaceState: InterfaceState = .idle
    
    private var submitIsEnabled: Bool {
        fieldsAreEnabled && !emailAddress.isEmpty && !password.isEmpty
    }
    
    private var fieldsAreEnabled: Bool {
        interfaceState != .signingIn
    }
    
    private var buttonLabel: String {
        if case .signingIn = interfaceState {
            return "Signing In..."
        } else {
            return "Sign In"
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign in to your account.")
                .font(.body)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
            
            CredentialFormView(emailAddress: $emailAddress, password: $password)
                .disabled(!fieldsAreEnabled)
            
            switch interfaceState {
            case .idle:
                EmptyView()
            case .signingIn:
                ProgressView()
            case .signInFailed(let message):
                Text(message)
                    .font(.caption)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            VStack {
                Button {
                    self.signIn()
                } label: {
                    Text(buttonLabel)
                        .font(.headline)
                        .fontDesign(.rounded)
                        .frame(minWidth: 250)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel("Sign In")
                #if os(iOS)
                .buttonBorderShape(.capsule)
                #endif
                .disabled(!submitIsEnabled)
                
                if let returnAction = returnAction {
                    Button {
                        returnAction()
                    } label: {
                        Text("Oh... I don't have an account. ")
                            .font(.body)
                    }
                    .disabled(!fieldsAreEnabled)
                }
            }
        }
        .padding()
    }
    
    private func signIn() {
        interfaceState = .signingIn
        Task {
            do {
                try await userService.signIn(emailAddress: emailAddress, password: password)
            } catch {
                interfaceState = .signInFailed(error.localizedDescription)
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
