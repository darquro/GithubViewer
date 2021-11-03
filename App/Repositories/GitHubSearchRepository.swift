//
//  GitHubSearchRepository.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/26.
//

import Foundation
import Combine
import APIClient

protocol GitHubSearchRepositoryProtocol {
    func fetchSwiftTopicRepos() -> AnyPublisher<GitHubSearchAPIRequest.Response, APIError>
    func fetch(keyword: String) -> AnyPublisher<GitHubSearchAPIRequest.Response, APIError>
}

final class GitHubSearchRepository: GitHubSearchRepositoryProtocol {

    func fetchSwiftTopicRepos() -> AnyPublisher<GitHubSearchAPIRequest.Response, APIError> {
        GitHubSearchAPIRequest(language: "swift", hasStars: 1000, topic: "swift").request()
    }

    func fetch(keyword: String) -> AnyPublisher<GitHubSearchAPIRequest.Response, APIError> {
        GitHubSearchAPIRequest(keyword: keyword).request()
    }
}
