//
//  RefreshControl.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/27.
//

import Foundation
import SwiftUI

public struct RefreshControl: View {

    static let coordinateSpaceDefaultName = "RefreshControl"
    @State private var isRefreshing = false
    @State private var visible = false
    var coordinateSpaceName: String
    var onRefresh: () -> Void

    init(coordinateSpaceName: String, onRefresh: @escaping () -> Void) {
        self.coordinateSpaceName = coordinateSpaceName
        self.onRefresh = onRefresh
    }

    public var body: some View {
        GeometryReader { geometry in
            if geometry.frame(in: .named(coordinateSpaceName)).midY > 30 {
                Spacer()
                    .onAppear() {
                        visible = true
                    }
            } else if geometry.frame(in: .named(coordinateSpaceName)).midY > 60 {
                Spacer()
                    .onAppear() {
                        isRefreshing = true
                    }
            } else if geometry.frame(in: .named(coordinateSpaceName)).maxY < 10 {
                Spacer()
                    .onAppear() {
                        visible = false
                        if isRefreshing {
                            isRefreshing = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if isRefreshing {
                    ProgressView()
                } else if visible {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.accentColor)
                        .frame(width: 30, height: 30)
                }
                Spacer()
            }
        }.padding(.top, -10)
    }
}
