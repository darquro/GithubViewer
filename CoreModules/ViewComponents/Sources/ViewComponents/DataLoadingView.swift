import Foundation
import SwiftUI

public struct DataLoadingView: View {

    public init() {}

    public var body: some View {
        VStack {
            ProgressView("loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 100)
        .background(Assets.Colors.overlayBackground.color)
        .cornerRadius(10)
    }
}

struct DataLoadingView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            DataLoadingView()
                .preferredColorScheme(.light)
            DataLoadingView()
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 200, height: 200))
    }
}
