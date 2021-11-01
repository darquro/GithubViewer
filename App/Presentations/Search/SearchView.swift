//
//  SearchView.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/24.
//

import SwiftUI
import Combine

struct SearchView<ViewModel: SearchViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel
    @State var isKeywordEditing: Bool = false

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchTextField(keyword: $viewModel.binding.keyword,
                                isEditing: $isKeywordEditing,
                                onCommit: {
                                    viewModel.input.onCommit.send()
                                })
                if viewModel.output.state == .initialzed {
                    Spacer()
                } else if viewModel.output.state == .dataLoading {
                    DataLoadingView()
                } else if viewModel.output.state == .dataFeched {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.output.items.indices, id: \.self) { index in
                                let item = viewModel.output.items[index]
                                NavigationLink(
                                    destination: WebView(url: item.url).navigationBarTitle(item.title, displayMode: .inline),
                                    isActive: $viewModel.output.items[index].isNavigationPushing
                                    ) {
                                    SmallCardView(item: $viewModel.output.items[index])
                                }
                            }
                        }
                    }
                } else {
                    ErrorView()
                }
            }
            .padding(.horizontal, 8)
            .navigationBarTitle("Search")
            .navigationBarHidden(isKeywordEditing)
            .onTapGesture {
                isKeywordEditing = false
                UIApplication.shared.endEditing()
            }
        }
        .animation(.easeOut)
    }
}

struct SearchView_Previews: PreviewProvider {

    @StateObject static var viewModel: ViewModelMock = .init()

    static var previews: some View {
        SearchView(viewModel: viewModel.state(.initialzed))
            .previewDisplayName(SearchViewModelState.initialzed.rawValue)
        SearchView(viewModel: viewModel.state(.dataLoading))
            .previewDisplayName(SearchViewModelState.dataLoading.rawValue)
        SearchView(viewModel: viewModel.state(.dataFeched))
            .previewDisplayName(SearchViewModelState.dataFeched.rawValue)
        SearchView(viewModel: viewModel.state(.error))
            .previewDisplayName(SearchViewModelState.error.rawValue)
    }

    final class ViewModelMock: SearchViewModelProtocol {
        final class Input: SearchViewModelInput {
            var onCommit: PassthroughSubject<Void, Never> = .init()
        }

        final class Binding: SearchViewModelBinding {
            @State var keyword: String = ""
        }

        final class Output: SearchViewModelOutput {
            var state: SearchViewModelState = .initialzed
            var items: [CardViewEntity] = []
            var isAlertShowing: Bool = false
        }

        let input: Input = .init()
        var binding: Binding = .init()
        var output: Output = .init()

        func state(_ state: SearchViewModelState) -> Self {
            output.state = state
            switch state {
            case .initialzed:
                break
            case .dataLoading:
                break
            case .dataFeched:
                let entity = CardViewEntity(imageURL: .init(string: "https://avatars.githubusercontent.com/u/10639145?s=200&v=4")!,
                                            title: "swift",
                                            subTitle: "apple",
                                            language: "Swift",
                                            star: 1000,
                                            description: "The Swift Programming Language",
                                            url: .init(string: "https://github.com/apple/swift")!)

                output.items = [CardViewEntity](repeating: entity, count: 3)
            case .error:
                output.isAlertShowing = true
                break
            }
            return self
        }
    }
}
