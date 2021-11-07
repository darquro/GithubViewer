import SwiftUI
import Combine
import ViewComponents

public struct WebContentView: View {

    let url: URL
    let webView: WebView = WebView()
    @ObservedObject var viewModel = WebContentViewModel()

    public init(url: URL) {
        self.url = url
        viewModel.webView = webView.wkWebView
        viewModel.subscribe()
    }

    public var body: some View {
        ZStack(alignment: .top) {
            webView
                .onLoad {
                    webView.load(url: url)
                }

            ProgressView(value: viewModel.binding.estimatedProgress)
                .opacity(viewModel.output.loadCompleted ? 0 : 1)
                .transition(.opacity)
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {
                    webView.goBack()
                }) {
                    Image(systemName: "chevron.left")
                }
                .disabled(!viewModel.binding.canGoBack)
                Button(action: {
                    webView.goForward()
                }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(!viewModel.binding.canGoForward)
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
