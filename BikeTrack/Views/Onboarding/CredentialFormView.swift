import SwiftUI

struct CredentialFormView: View {
    @Binding var emailAddress: String
    @Binding var password: String
    
    var body: some View {
        VStack(alignment: .center) {
            TextField("Email", text: $emailAddress)
                .autocorrectionDisabled()
                .labelsHidden()
                .textFieldStyle(.plain)
#if os(iOS)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
#endif
            Divider()
                .padding(.vertical, 5)
                .padding(.horizontal, -15)
            
            SecureField("Password", text: $password)
                .textContentType(.password)
                .labelsHidden()
                .textFieldStyle(.plain)
            
        }
        .padding(15)
        .background(
            Color("background")
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: Color.black.opacity(0.18),
                        radius: 55, x: 0, y: 8)
        )
    }
}

struct CredentialFormView_Previews: PreviewProvider {
    static var previews: some View {
        CredentialFormView(emailAddress: .constant(""), password: .constant(""))
            .padding()
    }
}
