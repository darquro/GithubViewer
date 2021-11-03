//
//  WebView.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/30.
//

import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {
    public typealias UIViewType = WKWebView

    let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func makeUIView(context: Context) -> WKWebView {
        WKWebView(frame: .zero)
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(.init(url: url))
    }
}
