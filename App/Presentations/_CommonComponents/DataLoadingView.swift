//
//  DataLoadingView.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/11/01.
//

import Foundation
import SwiftUI

struct DataLoadingView: View {

    var body: some View {
        Spacer()
        ProgressView("loading...")
        Spacer()
    }
}
