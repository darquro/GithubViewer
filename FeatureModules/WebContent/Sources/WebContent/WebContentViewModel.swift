import Foundation
import Combine
import WebKit
import ViewComponents

public final class WebContentViewModel: NSObject, ViewModelObject {

    public final class Input: InputObject {}

    public final class Binding: BindingObject {
        @Published var canGoBack: Bool = false
        @Published var canGoForward: Bool = false
        @Published var estimatedProgress: Double = 0
    }

    public final class Output: OutputObject {
        @Published var loadCompleted: Bool = false
    }

    public let input: Input
    public var binding: Binding
    public var output: Output
    weak var webView: WKWebView? {
        didSet {
            webView?.navigationDelegate = self
        }
    }
    private var cancellables = Set<AnyCancellable>()

    init(input: Input = Input(),
         binding: Binding = Binding(),
         output: Output = Output()) {
        self.input = input
        self.binding = binding
        self.output = output
    }

    func subscribe() {
        webView?.publisher(for: \.canGoBack)
            .print("canGoBack")
            .sink(receiveValue: { [weak self] value in
                self?.binding.canGoBack = value
            })
            .store(in: &cancellables)

        webView?.publisher(for: \.canGoForward)
            .print("canGoForward")
            .sink(receiveValue: { [weak self] value in
                self?.binding.canGoForward = value
            })
            .store(in: &cancellables)

        webView?.publisher(for: \.estimatedProgress)
            .print("estimatedProgress")
            .sink(receiveValue: { [weak self] value in
                self?.binding.estimatedProgress = value
            })
            .store(in: &cancellables)
    }
}

extension WebContentViewModel: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        output.loadCompleted = false
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        output.loadCompleted = true
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        output.loadCompleted = true
    }
}
