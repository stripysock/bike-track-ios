import Foundation
import os.log
import Combine

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
    private var cancellables = Set<AnyCancellable>()

    @Published private (set) var signInState: AuthState = .unknown
    
    init(contentRepository: ContentRepository) {
        self.contentRepository = contentRepository
    }
    
}
