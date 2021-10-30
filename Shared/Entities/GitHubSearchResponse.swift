//
//  GitHubSearchResponse.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/30.
//

import Foundation

struct GitHubSearchResponse: Decodable {
    let items: [GitHubRepository]
}
