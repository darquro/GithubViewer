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
                TextField("Keyword",
                          text: $viewModel.binding.keyword,
                          onEditingChanged: { changed in
                            isKeywordEditing = changed
                          },
                          onCommit: {
                            viewModel.input.onCommit.send()
                          })
                    .modifier(SearchTextFieldModifier(keyword: $viewModel.binding.keyword, isEditing: $isKeywordEditing))
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.output.items.indices, id: \.self) { index in
                            let item = viewModel.output.items[index]
                            NavigationLink(
                                destination: WebView(url: item.url).navigationBarTitle(item.title),
                                isActive: $viewModel.output.items[index].isNavigationPushing
                                ) {
                                SmallCardView(item: $viewModel.output.items[index])
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Search")
            .navigationBarHidden(isKeywordEditing)
            .onTapGesture {
                isKeywordEditing = false
                UIApplication.shared.endEditing()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {

    @StateObject static var viewModel: ViewModelMock = .init()

    static var previews: some View {
        SearchView(viewModel: viewModel)
    }

    final class ViewModelMock: SearchViewModelProtocol {
        final class Input: SearchViewModelInput {
            var onCommit: PassthroughSubject<Void, Never> = .init()
        }

        final class Binding: SearchViewModelBinding {
            @State var keyword: String = ""
        }

        final class Output: SearchViewModelOutput {
            var items: [CardViewEntity] = []
        }

        let input: Input = .init()
        var binding: Binding = .init()
        var output: Output = .init()
    }
}
