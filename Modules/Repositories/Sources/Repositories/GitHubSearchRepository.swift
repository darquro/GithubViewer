import Foundation
import Combine
import APIClient
import GitHubAPIRequest

public protocol GitHubSearchRepositoryProtocol {
    func fetchSwiftTopicRepos() -> AnyPublisher<GitHubSearchResponse, APIError>
    func fetch(keyword: String) -> AnyPublisher<GitHubSearchResponse, APIError>
}

public final class GitHubSearchRepository: GitHubSearchRepositoryProtocol {

    public init () {}

    public func fetchSwiftTopicRepos() -> AnyPublisher<GitHubSearchResponse, APIError> {
        GitHubSearchAPIRequest(language: "swift", hasStars: 1000, topic: "swift").request()
    }

    public func fetch(keyword: String) -> AnyPublisher<GitHubSearchResponse, APIError> {
        GitHubSearchAPIRequest(keyword: keyword).request()
    }
}
