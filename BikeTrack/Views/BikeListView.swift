import SwiftUI

struct BikeListView: View {
    @EnvironmentObject var contentService: ContentService
    
    @State private var bikesState: LoadState<Bike> = .loading
    
    var body: some View {
        ZStack {
            switch bikesState {
            case .loading:
                ProgressView()
            case .empty:
                Text("You haven't added any bikes yet.")
                    .font(.caption)
                
            case .loaded(let bikes):
                List(bikes) { bike in
                    Text("\(bike.name ?? "My Bike")")
                        .font(.body)
                }
                
            case .loadFailed(let error):
                Text("Error: \(error.localizedDescription)")
                    .font(.caption)
                
            }
        }
        .task {
            self.bikesState = await contentService.bikesForCurrentUser()
        }
    }
}

struct BikeListView_Previews: PreviewProvider {
    static var previews: some View {
        BikeListView()
    }
}
