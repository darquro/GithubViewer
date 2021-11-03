//
//  WebView.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/30.
//

import SwiftUI
import WebKit
import Combine

public struct WebView: UIViewRepresentable {
    public typealias UIViewType = WKWebView

    var url: URL?
    let webView = WKWebView(frame: .zero)

    public init(url: URL? = nil) {
        self.url = url
    }

    public func makeUIView(context: Context) -> WKWebView {
        webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = url {
            uiView.load(.init(url: url))
        }
    }

    public func publisher<Value>(for keyPath: KeyPath<WKWebView, Value>, options: NSKeyValueObservingOptions = [.initial, .new]) -> NSObject.KeyValueObservingPublisher<WKWebView, Value> {
        webView.publisher(for: keyPath, options: options)
    }

    public func load(url: URL) {
        webView.load(.init(url: url))
    }

    public func goBack() {
        webView.goBack()
    }

    public func goForward() {
        webView.goForward()
    }

    public func reload() {
        webView.reload()
    }
}
