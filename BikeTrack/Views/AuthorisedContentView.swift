import SwiftUI

struct AuthorisedContentView: View {
    @ObservedObject var contentService: ContentService
    init(userProfile: UserProfile) {
        self.contentService = ContentService(contentRepository: InMemoryContentRepository(userID: userProfile.id))
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#if DEBUG
struct AuthorisedContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorisedContentView(userProfile: .preview)
    }
}
#endif
