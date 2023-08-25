import Foundation

extension ContentService {
    static var preview = ContentService(contentRepository: InMemoryContentRepository(userID: UserProfile.preview.id))
}
