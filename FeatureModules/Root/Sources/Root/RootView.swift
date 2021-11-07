//
//  RootView.swift
//  Shared
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/24.
//

import SwiftUI
import Home
import Search

public struct RootView: View {

    @StateObject var homeViewModel: HomeViewModel = .init()
    @StateObject var searchViewModel: SearchViewModel = .init()

    public init() {}

    public var body: some View {
        TabView {
            HomeView(viewModel: homeViewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            SearchView(viewModel: searchViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
        }
        .accentColor(Color("Accent", bundle: .module))
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RootView()
                .preferredColorScheme(.light)
            RootView()
                .preferredColorScheme(.dark)
        }
    }
}
