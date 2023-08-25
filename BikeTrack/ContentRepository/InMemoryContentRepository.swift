import Foundation
import Combine
import OSLog

class InMemoryContentRepository: ContentRepository {
    
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? AppEnvironment.defaultBundleID,
        category: String(describing: InMemoryContentRepository.self)
    )
    
    private let userID: UUID
    private var bikeDatabase: [Bike] = []
    
    init(userID: UUID) {
        self.userID = userID
    }
    
    func getBikes(userID: UUID) async throws -> [Bike] {
        bikeDatabase.filter { $0.userID == userID }
    }
    
    func updateBike(_ bike: Bike) async throws {
        guard bike.userID == self.userID else {
            throw(ContentError.notAuthorised)
        }
        
        
    }
}
