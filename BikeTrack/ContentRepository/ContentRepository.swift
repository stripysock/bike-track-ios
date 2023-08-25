import Foundation
import Combine

enum ContentError: LocalizedError, Equatable {
    case userNotFound
    case notAuthorised
    case notImplemented
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "You don't appear to exist. Time for an existential crisis?"
        case .notAuthorised:
            return "You don't have permission to add bikes on behalf of another user."
        case .notImplemented:
            return "This feature has not been implemented."
        }
    }
}

/**
 `ContentRepository` is responsible for managing a user's bikes.
 
 Ideally your implementation would want to initiaise with some sort of user credentials, and ID, something... not going to enforce that though as Firebase and AWS have their own ways of magicking this together.
 */
protocol ContentRepository {
    
    /**
     Retrieves a list of bikes for a given user.
     
     - Parameters:
        - userID: The UUID of the user whose bikes we're interested in viewing
     
     - Throws: A ``ContentError`` will be thrown if the user doesn't exist. A system error may be thrown if there's a problem with the request.
     */
    func getBikes(userID: UUID) async throws -> [Bike]
       
    /**
     Updates a bike if it already exists, otherwise write a new entry.
    
     - parameters:
        - bike: The ``Bike`` to update or add for the user.
     
     - throws: A system error may be thrown if there's a problem with the request.
     */
    func updateBike(_ bike: Bike) async throws
  
}
