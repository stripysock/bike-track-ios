import SwiftUI

struct TabbarNavigationView: View {
    @Binding var navigationSelection: Navigation
    
    var body: some View {
        TabView(selection: $navigationSelection) {
            ForEach(Navigation.allCases, id: \.self) { navigationItem in
                NavigationStack {
                    navigationItem.view()
                        .navigationTitle(navigationItem.title)
                }
                .tabItem {
                    Label {
                        Text(navigationItem.title)
                    } icon: {
                        navigationItem.image()
                    }
                }
            }
        }
    }
}

#if DEBUG
private struct PreviewWrapper: View {
    @StateObject private var userService = UserService.preview
    @StateObject private var contentService = ContentService.preview
    @State private var navigationSelection: Navigation = .primary
    
    var body: some View {
        TabbarNavigationView(navigationSelection: $navigationSelection)
            .environmentObject(userService)
            .environmentObject(contentService)
    }
}

struct TabbarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
}
#endif
