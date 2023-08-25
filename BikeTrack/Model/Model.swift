import Foundation

struct UserProfile: Identifiable, Hashable, Codable {
    var id: UUID
    var email: String
    var name: String?
}

struct Bike: Identifiable, Hashable, Codable {
    enum BikeType: String, Codable {
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
    
    var id: UUID
    var userID: UUID
    var type: BikeType
    var brand: String?
    var model: String?
    var name: String?
}
