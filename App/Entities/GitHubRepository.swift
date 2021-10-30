//
//  GitHubRepository.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/30.
//

import Foundation

struct GitHubRepository: Decodable {
    let id: Int
    let name: String
    let fullName: String
    let owner: GitHubRepositoryOwner
    let htmlUrl: String
    let description: String?
    let language: String?
    let stargazersCount: Int
}
