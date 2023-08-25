import SwiftUI

@main
struct BikeTrackApp: App {
    @ObservedObject var userService = UserService(authRepository: MockAuthRepository())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userService)
        }
    }
}
