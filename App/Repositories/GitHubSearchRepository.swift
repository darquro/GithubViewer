//
//  GitHubSearchRepository.swift
//  GitHubViewer
//
//  Created by Kuroda, Yuki | Yuki | ECID on 2021/10/26.
//

import Foundation
import Combine
import APIClient
import GitHubAPIRequest

protocol GitHubSearchRepositoryProtocol {
    func fetchSwiftTopicRepos() -> AnyPublisher<GitHubSearchResponse, APIError>
    func fetch(keyword: String) -> AnyPublisher<GitHubSearchResponse, APIError>
}

final class GitHubSearchRepository: GitHubSearchRepositoryProtocol {

    func fetchSwiftTopicRepos() -> AnyPublisher<GitHubSearchResponse, APIError> {
        GitHubSearchAPIRequest(language: "swift", hasStars: 1000, topic: "swift").request()
    }

    func fetch(keyword: String) -> AnyPublisher<GitHubSearchResponse, APIError> {
        GitHubSearchAPIRequest(keyword: keyword).request()
    }
}
