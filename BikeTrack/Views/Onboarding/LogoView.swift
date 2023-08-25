import SwiftUI

struct LogoView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.accentColor)
            .frame(width: 90, height: 90)
            .overlay {
                Image(systemName: "bicycle")
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundColor(Color.white)
            }
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
