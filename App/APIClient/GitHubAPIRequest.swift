//
//  GitHubAPIRequest.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/25.
//

import Foundation
import APIClient

protocol GitHubAPIRequest: APIRequest {
}

extension GitHubAPIRequest {
    var baseURL: URL { URL(string: "https://api.github.com")! }
}
