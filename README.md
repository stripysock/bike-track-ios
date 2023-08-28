#  BikeTrack

BikeTrack is an example SwiftUI project to outline how we're approaching design patterns in the age of SwiftUI.
This is by no means something we'll blindly declare to be the best solution in all cases, but so far this approach has worked for us. This project is also not set in stone - we'll refine things as needed.

## Background
In a UIKit world we often had view controllers that would gather multiple views, have a one-to-one relation to a view model which relied on dependency injection... ending up with a lot of verbose code getting in the way of rapid development.

SwiftUI gives us inbuilt ways to manage state (`@State`, `@Binding` etc), dependency injection (`@EnvironmentObject`, `@Environment`) and property wrappers like `@SceneStorage` to conviently access functionality from directly in our views. In short, we no longer need the overhead of the UIKit world.

## Structure
In short, we have -
* Models
* Repositories
* Services
* Views

### Models
These are the bits of content moved around our app. They may represent a user, a bit of content, or a discrete response from an API. Generally these are `Hashable` (making them easy to use within SwiftUI lists etc), `Codable` (for easy retrieval from APIs etc), and where possible, `Identifiable` (again, for more succinct SwiftUI code).

### Repositories
Repositories represent low-lying code that communicate directly with some sort of data store. They're defined by a protocol, with implementations of that protocol relating for a specific vendor or solution (think an `AuthRepository` responsible for user login, with AWS, Firebase and Mock implementations.) Any raw data retrieved is returned in the structure of our models.

### Services 
Services act as an abstraction layer between the repositories and views. Services are initialied with one or more concrete repositories. They're `@Observable`, meaning any changes to their `@Published` variables are sent to our views. Services are initialised high up in the view hierachy, being then accessible to any sub-view as an `@EnvironmentObject`. Services provide generalised data for any views that might be interested in their contents. We may have an `AuthService` that provides methods for sign in, sign out and user profile information; Any views interested in using this functionality then have a single, unified place to call.

### Views
This is what we're all here for - SwiftUI views. They provide not only the UI, but manage the navigation state of our app. Apple gives us lots of ways to do manage navigation within SwiftUI, so we'd prefer to take advantage of this as much as possible.

## But where's the logic?
Traditionally (in an MVC world), we'd have or logic in the view controller. View Models were introduced to take the burden of this logic and enable us to run tests indepedent of the VC.

However, this logic can be contextualised whilst still being testable.

### Model Extensions
If logic relates to a particular model, put it in an extension. For example...
```
struct UserProfile {
    var firstName: String
    var lastName: String
}

extension UserProfile {
    var name: String {
        "\(firstName) \(lastName)"
    }
}
```
(Obviously this is a simplified example and very euro-centric, but you get the idea.)

### Within Views
When logic relates purely to how a view should appear, keep the logic within the view declaration.
SwiftUI allows for inline logic flow; However, we should keep more complex logic within computed properties rather than inline.
```
struct SignInView: View {
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    
    private var submitIsEnabled: Bool {
        !emailAddress.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        ...
        Button {
           // Sign in
        } label: {
            Text("Sign In")
        }
        .disabled(!submitIsEnabled)
    }
}
```

### Everything else
Services should contain more complex logic that may be used by more than one type of view and containing more than one type of model. For example, returning a list of groups related to a particular user. Note that in this case we recommend using the `Loadable` wrapper to better indicate that loading state of the result.

## Testing
Yes, one of the obvious problems with having logic within the views means this particular logic can't be tested directly. 
Personally I think simplicity rules surpreme, but if you don't agree, check out the (ViewInspector)[https://github.com/nalexn/ViewInspector] SPM for running logic tests on SwiftUI views.
**However**, as mentioned above, our logic within views should be purely for the view itself. As such, it's probably better to use UI Tests to test this logic.

