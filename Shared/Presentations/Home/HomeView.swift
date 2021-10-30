//
//  HomeView.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/24.
//

import SwiftUI
import Combine

struct HomeView<ViewModel: HomeViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel
    @State private var isShowing = false

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.output.isProgressViewShowing {
                    ProgressView("loading...")
                } else {
                    ScrollView {
//                        RefreshControl(coordinateSpaceName: RefreshControl.coordinateSpaceDefaultName, onRefresh: {
//                            viewModel.input.onLoad.send()
//                        })
                        LazyVStack {
                            ForEach(viewModel.output.items.indices, id: \.self) { index in
                                let item = viewModel.output.items[index]
                                NavigationLink(destination:
                                                WebView(url: item.url)
                                                .navigationBarTitle(item.title, displayMode: .inline),
                                               isActive: $viewModel.output.items[index].isNavigationPushing

                                ) {
                                    BigCardView(item: $viewModel.output.items[index])
                                        .onTapGesture(perform: {
                                            viewModel.input.onTappedCardView.send(index)
                                        })
                                }
                            }
                        }
                        .padding([.leading, .trailing], 8)
                    }
//                    .coordinateSpace(name: RefreshControl.coordinateSpaceDefaultName)
                }
            }
            .navigationBarTitle("Home")
            .onLoad(perform: {
                viewModel.input.onLoad.send()
            })
            .alert(isPresented: $viewModel.output.isAlertShowing) {
                Alert(title: Text("Error"),
                      message: Text("Please retry."))
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {

    @StateObject static var viewModel: ViewModelMock = .init()

    static var previews: some View {
        Group {
            HomeView(viewModel: viewModel.state(.initialzed))
                .previewDisplayName(ViewModelMock.State.initialzed.rawValue)
            HomeView(viewModel: viewModel.state(.dataLoading))
                .previewDisplayName(ViewModelMock.State.dataLoading.rawValue)
            HomeView(viewModel: viewModel.state(.dataFeched))
                .previewDisplayName(ViewModelMock.State.dataFeched.rawValue)
            HomeView(viewModel: viewModel.state(.error))
                .previewDisplayName(ViewModelMock.State.error.rawValue)
        }
    }

    final class ViewModelMock: HomeViewModelProtocol {
        let input: Input = .init()
        var binding: Binding = .init()
        var output: Output = .init()

        final class Input: HomeViewModelInput {
            var onLoad: PassthroughSubject<Void, Error> = .init()
            var onTappedCardView: PassthroughSubject<Int, Never> = .init()
        }
        final class Binding: HomeViewModelBinding {}
        final class Output: HomeViewModelOutput {
            var items: [CardViewEntity] = []
            var isProgressViewShowing: Bool = false
            var isAlertShowing: Bool = false
            var isNavigationPushing: [Bool] = []
        }

        enum State: String {
            case initialzed, dataLoading, dataFeched, error
        }

        func state(_ state: State) -> Self {
            switch state {
            case .initialzed:
                break
            case .dataLoading:
                output.isProgressViewShowing = true
            case .dataFeched:
                let entity = CardViewEntity(imageURL: .init(string: "https://avatars.githubusercontent.com/u/10639145?s=200&v=4")!,
                                            title: "swift",
                                            subTitle: "apple",
                                            language: "Swift",
                                            star: 1000,
                                            description: "The Swift Programming Language",
                                            url: .init(string: "https://github.com/apple/swift")!)

                output.items = [CardViewEntity](repeating: entity, count: 3)
                output.isProgressViewShowing = false
            case .error:
                output.isAlertShowing = true
                break
            }
            return self
        }
    }
}
