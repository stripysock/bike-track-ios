import SwiftUI

struct AuthorisedContentView: View {
    @ObservedObject var contentService: ContentService
    @SceneStorage("navigationSelection") private var navigationSelection: Navigation = .primary
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }
    #else
    private var isCompact = false
    #endif
    
    init(userProfile: UserProfile) {
        self.contentService = ContentService(contentRepository: InMemoryContentRepository(userID: userProfile.id))
    }
    
    var body: some View {
        if #available(iOS 16.0, *), !isCompact {
            SidebarNavigationView(navigationSelection: $navigationSelection)
                .onAppear {
                    navigationSelection = .primary
                }
        } else {
            TabbarNavigationView(navigationSelection: $navigationSelection)
                .onAppear {
                    navigationSelection = .primary
                }
        }
        
    }
}

#if DEBUG
struct AuthorisedContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorisedContentView(userProfile: .preview)
    }
}
#endif
