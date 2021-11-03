//
//  GitHubSearchResponse.swift
//  
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/11/03.
//

import Foundation

public struct GitHubSearchResponse: Decodable {
    public let items: [GitHubRepository]
}
