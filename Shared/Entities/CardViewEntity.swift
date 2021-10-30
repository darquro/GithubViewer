//
//  CardViewEntity.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/24.
//

import Foundation

struct CardViewEntity: Identifiable {

    // MARK: Data
    let id: UUID = .init()
    let imageURL: URL
    let title: String
    let subTitle: String
    let language: String?
    let star: Int
    let description: String?
    let url: URL

    // MARK: User Action
    var isNavigationPushing: Bool = false
}
