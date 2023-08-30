import Foundation
import os.log

/**
 `ContentService` provides an interface into storing and retrieving user content.
 
 Being an observable object, `ContentService` is intended to be initialised as an `ObservableObject` high up in the SwiftUI view hierarchy and observed as an EnvironmentObject by child views as required.
 Like other `[Name]Service` classes, `ContentService` provides a layer of abstraction between the UI and lower level repositories, which can be swapped out at `init()`.
 */
class ContentService: ObservableObject {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? AppEnvironment.defaultBundleID,
        category: String(describing: ContentService.self)
    )
    
    private var contentRepository: ContentRepository

    @Published private (set) var signInState: AuthState = .unknown
    
    init(contentRepository: ContentRepository) {
        self.contentRepository = contentRepository
    }
    
    func bikesForCurrentUser() async -> LoadState<Bike> {
        do {
            let bikes = try await contentRepository.getBikes()
            if bikes.isEmpty {
                return .empty
            }
            return .loaded(bikes)
        } catch {
            return .loadFailed(error)
        }
    }
}
