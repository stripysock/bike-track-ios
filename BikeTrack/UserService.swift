import Foundation
import os.log

/**
 `UserService` provides an interface into common user account management functions.
 
 Being an observable object, `UserService` is intended to be initialised as an `ObservableObject` high up in the SwiftUI view hierarchy and observed as an EnvironmentObject by child views as required.
 Like other `[Name]Service` classes, `UserService` provides a layer of abstraction between the UI and lower level repositories, which can be swapped out at `init()`.
 */
@MainActor
class UserService: ObservableObject {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? AppEnvironment.defaultBundleID,
        category: String(describing: UserService.self)
    )
    
    private var authRepository: AuthRepository
    private var authObserver: Task<Void, Never>?
    
    @Published private(set) var authState: AuthState = .unknown {
        didSet {
            Self.logger.info("published authState changed to: \(self.authState)")
        }
    }
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        setupObservers()
    }
    
    deinit {
        authObserver?.cancel()
        authObserver = nil
    }
    
    private func setupObservers() {
        self.authObserver = authRepository.authState.observeOnMain { [weak self] newAuthState in
            self?.authState = newAuthState
        }
    }
    
    /**
     The logged in user's user profile.
     */
    var currentUser: UserProfile? {
        switch authState {
        case .signedIn(let userProfile):
            return userProfile
        default:
            return nil
        }
    }
    
    func signIn(emailAddress: String, password: String) async throws {
        try await authRepository.signIn(emailAddress: emailAddress, password: password)
    }
    
    func signUp(emailAddress: String, password: String) async throws {
        try await authRepository.signUp(emailAddress: emailAddress, password: password)
        try await signIn(emailAddress: emailAddress, password: password)
    }
    
    func signOut() async throws {
        try await authRepository.signOut()
    }
}
