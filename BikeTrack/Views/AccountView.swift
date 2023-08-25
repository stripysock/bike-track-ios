import SwiftUI

struct AccountView: View {
    @EnvironmentObject var userService: UserService
    
    enum InterfaceState: Hashable {
        case idle
        case signingOut
        case signOutFailed(String)
    }
    
    @State private var interfaceState: InterfaceState = .idle
    
    private var fieldsAreEnabled: Bool {
        interfaceState != .signingOut
    }
    
    private var buttonLabel: String {
        if case .signingOut = interfaceState {
            return "Signing Out..."
        } else {
            return "Sign Out"
        }
    }
    
    var body: some View {
        VStack {
            if let userProfile = userService.currentUser {
                Text("Signed in as \(userProfile.email).")
            } else {
                Text("Not signed in.")
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    signOut()
                } label: {
                    Text(buttonLabel)
                        .font(.body)
                }
            }
        }
    }
    
    private func signOut() {
        interfaceState = .signingOut
        Task {
            do {
                try await userService.signOut()
            } catch {
                interfaceState = .signOutFailed(error.localizedDescription)
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
