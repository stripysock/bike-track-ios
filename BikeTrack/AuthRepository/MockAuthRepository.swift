import Foundation
import OSLog

actor MockAuthRepository: AuthRepository {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? AppEnvironment.defaultBundleID,
        category: String(describing: MockAuthRepository.self)
    )
    
    private var userDatabase: [MockUser] = []
    
    let authState: CurrentValueAsyncSequence<AuthState> = CurrentValueAsyncSequence(.unknown)
    
    init() {
#if !DEBUG
        Self.logger.warning("MockAuthRepository should only be used within a DEBUG environment.")
#endif
        self.authState.send(.signedOut)
    }
        
    func signIn(emailAddress: String, password: String) async throws {
        guard !emailAddress.isEmpty, !password.isEmpty else {
            throw(AuthError.invalidCredentials)
        }
        
        let hash = MockUser.hashedPassword(password)
        guard let user = userDatabase.first(where: { $0.emailAddress == emailAddress && $0.passwordHash == hash }) else {
            throw(AuthError.invalidCredentials)
        }
        
        authState.send(.signedIn(profile: user.profile))
    }
      
    func signOut() async throws {
        authState.send(.signedOut)
    }
    
    func signUp(emailAddress: String, password: String) async throws {
        guard !emailAddress.isEmpty, !password.isEmpty else {
            throw(AuthError.invalidCredentials)
        }
        
        if userExists(emailAddress) {
            throw(AuthError.emailInUse(emailAddress))
        }
        let user: MockUser
#if DEBUG
        user = MockUser(passwordHash: MockUser.hashedPassword(password),
                        profile: UserProfile(id: UUID(), email: emailAddress))
#else
        throw(AuthError.invalidEmail(emailAddress))
    
    #endif
        userDatabase.append(user)
    }
    
    private func userExists(_ emailAddress: String) -> Bool {
        if let _ = userDatabase.first(where: { $0.emailAddress == emailAddress }) {
            return true
        }
        return false
    }
}

private struct MockUser {
    var passwordHash: String
    var profile: UserProfile
    
    var emailAddress: String {
        profile.email
    }
    
    static func hashedPassword(_ password: String) -> String {
        "\(password.hash)"
    }
}
