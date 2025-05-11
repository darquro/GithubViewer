import SwiftUI
import Combine
import ViewComponents
import WebContent

public struct SearchView: View {

    @ObservedObject var viewModel: SearchViewModel
    @State var isKeywordEditing: Bool = false

    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            VStack {
                SearchTextField(keyword: viewModel.$binding.keyword,
                                isEditing: $isKeywordEditing,
                                onCommit: {
                                    viewModel.input.onCommit.send()
                                })
                if viewModel.output.state == .initialzed {
                    Spacer()
                } else if viewModel.output.state == .error {
                    ErrorView()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.binding.items.indices, id: \.self) { index in
                                let item = viewModel.binding.items[index]
                                NavigationLink(
                                    destination: WebContentView(url: item.url).navigationBarTitle(item.title, displayMode: .inline),
                                    isActive: viewModel.$binding.items[index].isNavigationPushing
                                ) {
                                    SmallCardView(item: viewModel.$binding.items[index])
                                }
                            }
                        }
                    }
                }
            }
            .overlay(
                VStack {
                    if viewModel.output.state == .dataLoading {
                        DataLoadingView()
                    }
                }
            )
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

    static var previews: some View {
        SearchView(viewModel: dataFetchedViewModel)
            .previewDisplayName(SearchViewModelState.dataFeched.rawValue)
    }

    static var dataFetchedViewModel: SearchViewModel {
        let binding = SearchViewModel.Binding()
        let entity = CardViewEntity(imageURL: .init(string: "https://avatars.githubusercontent.com/u/10639145?s=200&v=4")!,
                                    title: "swift",
                                    subTitle: "apple",
                                    language: "Swift",
                                    star: 1000,
                                    description: "The Swift Programming Language",
                                    url: .init(string: "https://github.com/apple/swift")!)

        binding.items = [CardViewEntity](repeating: entity, count: 3)
        let output = SearchViewModel.Output()
        output.state = .dataFeched
        return SearchViewModel(
            binding: BindableObject<SearchViewModel.Binding>(binding),
            output: output)
    }
}
