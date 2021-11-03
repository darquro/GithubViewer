//
//  ErrorView.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/11/01.
//

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
        ErrorView()
    }
}
