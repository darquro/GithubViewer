//
//  File.swift
//  
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/11/03.
//

import Foundation

public struct GitHubRepository: Decodable {
    public let id: Int
    public let name: String
    public let fullName: String
    public let owner: GitHubRepositoryOwner
    public let htmlUrl: URL
    public let description: String?
    public let language: String?
    public let stargazersCount: Int
}
