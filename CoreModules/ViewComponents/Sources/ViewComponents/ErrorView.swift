import Foundation
import SwiftUI

public struct ErrorView: View {

    public init() {}

    public var body: some View {
        VStack {
            Label("Opps!", systemImage: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(.title)
            Text("An error has occurred.\nPlease try again.")
                .multilineTextAlignment(.center)
                .font(.body)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            ErrorView()
                .preferredColorScheme(.light)
            ErrorView()
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 200, height: 200))
    }
}
