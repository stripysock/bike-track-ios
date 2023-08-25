import SwiftUI

@available(iOS 16.0, *)
struct SidebarNavigationView: View {
    @Binding var navigationSelection: Navigation
    
    @State private var listNavigationSelection: Navigation?
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(Navigation.allCases, id: \.self) { navigationItem in
                    NavigationLink(destination: navigationItem.view(), tag: navigationItem, selection: $listNavigationSelection) {
                        Label {
                            Text(navigationItem.title)
                        } icon: {
                            navigationItem.image()
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            
        } detail: {
            navigationSelection.view()
        }
        .onAppear {
            listNavigationSelection = navigationSelection
        }
        .onChange(of: listNavigationSelection) { newValue in
            navigationSelection = newValue ?? .primary
        }
    }
}

#if DEBUG
@available(iOS 16.0, *)
private struct PreviewWrapper: View {
    @StateObject private var userService = UserService.preview
    @StateObject private var contentService = ContentService.preview
    
    @State private var navigationSelection: Navigation = .primary
    
    var body: some View {
        SidebarNavigationView(navigationSelection: $navigationSelection)
            .environmentObject(userService)
            .environmentObject(contentService)
    }
}

@available(iOS 16.0, *)
struct SidebarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
    }
}
#endif
