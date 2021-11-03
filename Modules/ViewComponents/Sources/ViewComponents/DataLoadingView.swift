//
//  DataLoadingView.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/11/01.
//

import Foundation
import SwiftUI

public struct DataLoadingView: View {

    public init() {}

    public var body: some View {
        VStack {
            Spacer()
            ProgressView("loading...")
            Spacer()
        }
    }
}

struct DataLoadingView_Previews: PreviewProvider {

    static var previews: some View {
        DataLoadingView()
    }
}
