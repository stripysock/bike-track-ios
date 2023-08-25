import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userService: UserService
    
    var body: some View {
        ZStack {
            switch userService.authState {
            case .unknown, .loading:
                ProgressView()
                
            case .signedIn(let userProfile):
                AuthorisedContentView(userProfile: userProfile)
            
            case .signedOut:
                OnboardingView()
            }
        }
        .animation(.easeInOut, value: userService.authState)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserService.preview)
    }
}
#endif 
