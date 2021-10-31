//
//  GitHubRepositoryOwner.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/30.
//

import Foundation

struct GitHubRepositoryOwner: Decodable {
    let id: Int
    let login: String
    let avatarUrl: URL
}
