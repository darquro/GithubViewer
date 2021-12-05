//
//  HomeView.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/24.
//

import SwiftUI
import Combine
import ViewComponents
import WebContent

public struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.output.state == .initialzed {
                    Spacer()
                } else if viewModel.output.state == .error {
                    ErrorView()
                } else {
                    LazyVStack {
                        ForEach(viewModel.binding.items.indices, id: \.self) { index in
                            let item = viewModel.binding.items[index]
                            NavigationLink(destination:
                                            WebContentView(url: item.url)
                                            .navigationBarTitle(item.title, displayMode: .inline),
                                           isActive: $viewModel.binding.items[index].isNavigationPushing) {
                                BigCardView(item: viewModel.$binding.items[index])
                                    .onTapGesture(perform: {
                                        viewModel.input.onTappedCardView.send(index)
                                    })
                            }
                        }
                    }
                    .padding([.leading, .trailing], 8)
                }
            }
            .padding(.top, 1) // ScrollViewをpullするとカクつく事象のworkaround。ただしNavigationBarがScroll量に応じて小さくならない。
            .refreshable(onValueChanged: { refreshControl in
                viewModel.input.onRefresh.send({
                    refreshControl.endRefreshing()
                })
            })
            .overlay(
                VStack {
                    if viewModel.output.state == .dataLoading {
                        DataLoadingView()
                    }
                }
            )
            .navigationBarTitle("Home")
            .onLoad(perform: {                
                viewModel.input.onLoad.send()
            })
            .alert(isPresented: viewModel.$binding.isAlertShowing) {
                Alert(title: Text("Error"),
                      message: Text("Please retry."))
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            HomeView(viewModel: dataFetchedViewModel)
                .previewDisplayName(HomeViewModelState.initialzed.rawValue)
        }
    }

    static var dataFetchedViewModel: HomeViewModel {
        let binding = HomeViewModel.Binding()
        let entity = CardViewEntity(imageURL: .init(string: "https://avatars.githubusercontent.com/u/10639145?s=200&v=4")!,
                                    title: "swift",
                                    subTitle: "apple",
                                    language: "Swift",
                                    star: 1000,
                                    description: "The Swift Programming Language",
                                    url: .init(string: "https://github.com/apple/swift")!)

        binding.items = [CardViewEntity](repeating: entity, count: 3)
        let output = HomeViewModel.Output()
        output.state = .dataFeched

        return HomeViewModel(
            binding: BindableObject<HomeViewModel.Binding>(binding),
            output: output)
    }
}
