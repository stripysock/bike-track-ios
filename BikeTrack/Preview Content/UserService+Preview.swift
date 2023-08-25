import Foundation

extension UserService {
    static var preview = UserService(authRepository: MockAuthRepository())
}
