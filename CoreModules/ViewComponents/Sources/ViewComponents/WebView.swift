import SwiftUI
import WebKit
import Combine

public struct WebView: UIViewRepresentable {
    public typealias UIViewType = WKWebView

    public let wkWebView = WKWebView(frame: .zero)

    public init() {
    }

    public func makeUIView(context: Context) -> WKWebView {
        wkWebView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
    }

    public func load(url: URL) {
        wkWebView.load(.init(url: url))
    }

    public func goBack() {
        wkWebView.goBack()
    }

    public func goForward() {
        wkWebView.goForward()
    }

    public func reload() {
        wkWebView.reload()
    }
}
