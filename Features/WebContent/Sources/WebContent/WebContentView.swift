import SwiftUI
import Combine
import ViewComponents

public struct WebContentView: View {

    let url: URL
    var webView: WebView
    @State var canGoBack: Bool = false
    @State var canGoForward: Bool = false
    @State var estimatedProgress: Double = 0
    private var cancellables = Set<AnyCancellable>()

    public init(url: URL) {
        self.url = url
        self.webView = WebView(url: url)
        webView.publisher(for: \.canGoBack)
            .print("canGoBack")
            .assign(to: \.canGoBack, on: self)
            .store(in: &cancellables)

        webView.publisher(for: \.canGoForward)
            .print("canGoForward")
            .assign(to: \.canGoForward, on: self)
            .store(in: &cancellables)

        webView.publisher(for: \.estimatedProgress)
            .print("estimatedProgress")
            .assign(to: \.estimatedProgress, on: self)
            .store(in: &cancellables)
    }

    public var body: some View {
        VStack {
            ProgressView(value: estimatedProgress)
            webView
                .onLoad {
                    webView.load(url: url)
                }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {
                    webView.goBack()
                }) {
                    Image(systemName: "chevron.left")
                }
                .disabled(!canGoBack)
                Button(action: {
                    webView.goForward()
                }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(!canGoForward)
                Spacer()
                Button(action: {
                    webView.reload()                    
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}

struct WebContentView_Previews: PreviewProvider {

    static let url = URL(string: "https://example.com")!

    static var previews: some View {
        WebContentView(url: url)
    }
}
