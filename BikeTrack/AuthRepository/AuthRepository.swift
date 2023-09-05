import Foundation

enum AuthError: LocalizedError, Equatable {
    case userNotFound(String)
    case userCancelled(String)
    case incorrectCredentials(String)
    case invalidEmail(String)
    case emailInUse(String)
    case invalidPassword
    case invalidCredentials
    case signUpDidNotComplete
    case notImplemented
    case withDescription(String)
    
    var errorDescription: String? {
        switch self {
            
        case .userNotFound(let username):
            return "The email address \"\(username)\" isn't a registered."
        case .userCancelled(let username):
            return "The account for \"\(username)\" has been suspended."
        case .incorrectCredentials(let username):
            return "The password for \"\(username)\" is incorrect."
        case .invalidEmail(let email):
            return "\"\(email)\" is not a valid email address."
        case .emailInUse(let email):
            return "The email address \"\(email)\" is already used by another account."
        case .invalidPassword:
            return "The password isn't valid."
        case .invalidCredentials:
            return "Invalid username or password."
        case .signUpDidNotComplete:
            return "There was a problem creating your account."
        case .notImplemented:
            return "This feature has not been implemented."
        case .withDescription(let description):
            return "Authentication service error: \(description)"
        }
    }
}

enum AuthState: Equatable {
    case unknown
    case loading
    case signedOut
    case signedIn(profile: UserProfile)
}

extension AuthState: CustomStringConvertible {
    /// Implementing CustomStringConvertible to ensure that profile details
    /// are not leaked if logging current state.
    var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .loading:
            return "loading"
        case .signedOut:
            return "signedOut"
        case .signedIn:
            return "signedIn"
        }
    }
}

protocol AuthRepository {
    /**
     The auth state is a current value sequence that can be observed by any parts of the app
     that need to change in response to whether a user is signed in or not.
     */
    var authState: CurrentValueAsyncSequence<AuthState> { get }

    /**
     Initiate a sign in with the username and password that has been provided.
     If the username and password identify a valid user then the user will be signed in and  the ``authState`` will send a value of `.signedIn`.
     
     - Parameters:
        - emailAddress: An email address of a valid account
        - password: A password for the account
     
     - Throws: An ``AuthError`` will be thrown if the credentials are invalid. A system error may be thrown if there's a problem with the request.
     */
    func signIn(emailAddress: String, password: String) async throws
       
    /**
     The  user will be signed out and any stored refresh token will be deleted.
     The ``authState`` will send a value of `.signedOut`.
     */
    func signOut() async throws
    
    /**
     Sign up for a new account.
     This will attempt to create a new account for the user using the supplied `emailAddress` and `password`.
    
     - parameters:
        - emailAddress: The email address of the account to create
        - password: A password for the account
     
     - throws: An ``AuthError`` will be thrown if the sign up token is invalid. A system error may be thrown if there's a problem with the request.
     */
    func signUp(emailAddress: String, password: String) async throws
  
}
