import XCTest
@testable import BikeTrack

final class BikeTrackTests: XCTestCase {
    let mockUserService = UserService(authRepository: MockAuthRepository())
    
    func testMockAccountCreation() async {
        let expectation = XCTestExpectation(description: "User created successfully")
        
        let emailAddress = "adam@stripysock.com.au"
        let password = "password1234"
        
        do {
            try await mockUserService.signUp(emailAddress: emailAddress, password: password)
            expectation.fulfill()
        } catch {
            XCTFail("Unable to create user.")
        }
    }

}
