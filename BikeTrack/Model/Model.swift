import Foundation

enum Loadable<T: Hashable & Identifiable> {
    case loading
    case empty
    case loaded([T])
    case loadFailed(Error)
}

struct UserProfile: Identifiable, Hashable, Codable {
    /// A unique identifier for the user
    var id: UUID
    
    /// The user's email address
    var email: String
    
    /// A display name for the user, if supplied
    var name: String?
}

struct Bike: Identifiable, Hashable, Codable {
    /// The type of bike that our users can pick from.
    enum BikeType: String, Codable, CaseIterable {
        case crosscountry
        case trail
        case enduro
        case dh
        case gravel
        case road
        case tt
        case townie
        case cruiser
    }
    
    /// A unique identifier for the bike
    var id: UUID
    
    /// The ID of the owner of this bike
    var userID: UUID
    
    /// The type of bike this is
    var type: BikeType
    
    /// An optional brand name of the bike
    var brand: String?
    
    /// An optional model name of the bike
    var model: String?
    
    /// A display name for the bike, if supplied
    var name: String?
}
