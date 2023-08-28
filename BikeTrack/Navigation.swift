import SwiftUI

/**
 Navigation defines the items that will appear in our top level navigation UI (whether that be a tab bar or sidebar).
 */
enum Navigation: String, Hashable, CaseIterable, Codable {
    case list
    case account
}

// MARK: - Identifiable
extension Navigation: Identifiable {
    var id: String {
        rawValue
    }
}

// MARK: - Convenience extensions
extension Navigation {
    static var primary: Navigation {
        .list
    }
    
    @ViewBuilder func view() -> some View {
        switch self {
        case .list:
            BikeListView()
                .navigationTitle(self.title)

        case .account:
            AccountView()
                .navigationTitle(self.title)
        }
    }
    
    var title: String {
        switch self {
        case .list:
            return "Bikes"
        case .account:
            return "My Account"
        }
    }
    
    func image() -> Image {
        switch self {
        case .list:
            return Image(systemName: "bicycle.circle")
        case .account:
            return Image(systemName: "person.circle")
        }
    }
}
