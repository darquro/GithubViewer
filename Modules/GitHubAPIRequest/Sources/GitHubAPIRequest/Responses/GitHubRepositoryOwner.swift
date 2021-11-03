//
//  File.swift
//  
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/11/03.
//

import Foundation

public struct GitHubRepositoryOwner: Decodable {
    public let id: Int
    public let login: String
    public let avatarUrl: URL
}
